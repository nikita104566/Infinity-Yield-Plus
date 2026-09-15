#!/usr/bin/env python3
"""List, select, and print loadstrings for Infinity Yield Plus hotfixes and automation PRs."""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
import urllib.error
import urllib.request
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CATALOG_PATH = ROOT / "hotfix" / "catalog.json"
PATCHES_PATH = ROOT / "patches.luau"
DEFAULT_OWNER_REPO = "nikita104566/Infinity-Yield-Plus"

THEMES: list[tuple[str, re.Pattern[str]]] = [
    ("lastcommand-empty", re.compile(r"lastcommand|empty history", re.I)),
    ("studio-event-names", re.compile(r"event names|OnCharact|left list", re.I)),
    ("history-persist", re.compile(r"history survives|IY_FE|rejoin|persist", re.I)),
    ("showhistory", re.compile(r"showhistory|clearhistory|\bhist\b", re.I)),
    ("empty-search", re.compile(r"empty search|empty command search|search is empty|no match|nomatch|empty state|counts in the command", re.I)),
    ("favorite-star", re.compile(r"favorite|gold star|★|pin a favorite|row to pin", re.I)),
    ("studio-command", re.compile(r";studio|open Automation Studio with", re.I)),
    ("alias-highlight", re.compile(r"alias first|alias highlight|typed alias", re.I)),
    ("studio-chips", re.compile(r"chip|\$place|\$job", re.I)),
    ("studio-picker", re.compile(r"picker", re.I)),
    ("command-palette", re.compile(r"palette|Ctrl\+K|Cyrillic", re.I)),
    ("reload-listeners", re.compile(r";reload|listeners", re.I)),
    ("studio-inspector", re.compile(r"Inspector", re.I)),
    ("studio-groups", re.compile(r"group icon|group-off|ungrouped|fold", re.I)),
    ("keyboard-list", re.compile(r"Down highlights|arrow|keyboard", re.I)),
    ("cmd-row-layout", re.compile(r"alias(?:es)? on line|readable command names|cmd-row", re.I)),
    ("studio-filter", re.compile(r"filter commands in Automation", re.I)),
]


def load_catalog() -> dict:
    with CATALOG_PATH.open(encoding="utf-8") as fh:
        return json.load(fh)


def patches_by_id(catalog: dict) -> dict[int, dict]:
    return {int(p["id"]): p for p in catalog["patches"]}


def raw_url(ref: str, path: str, owner_repo: str | None = None) -> str:
    repo = owner_repo or DEFAULT_OWNER_REPO
    ref = ref.strip("/")
    return f"https://raw.githubusercontent.com/{repo}/{ref}/{path.lstrip('/')}"


def loadstring(url: str) -> str:
    return f"loadstring(game:HttpGet('{url}'))()"


def snippet_for_ids(ids: list[int], *, ref: str = "main", catalog: dict | None = None) -> str:
    catalog = catalog or load_catalog()
    known = patches_by_id(catalog)
    missing = [i for i in ids if i not in known]
    if missing:
        raise SystemExit(f"unknown hotfix id(s): {', '.join(map(str, missing))}")
    source = loadstring(raw_url(ref, "source"))
    if len(ids) == 1:
        file_name = known[ids[0]]["file"]
        return source + "\n" + loadstring(raw_url(ref, file_name))
    only = ", ".join(str(i) for i in ids)
    lines = [
        source,
        f"_G.IYP_ONLY = {{ {only} }}",
    ]
    if ref != "main":
        base = raw_url(ref, "").rstrip("/") + "/"
        lines.append(f"_G.IYP_PATCH_BASE = '{base}'")
    lines.append(loadstring(raw_url(ref, "patches.luau")))
    return "\n".join(lines)


def parse_patches_luau() -> tuple[list[tuple[int, str]], list[int]]:
    text = PATCHES_PATH.read_text(encoding="utf-8")
    entries = [(int(i), f) for i, f in re.findall(r"\{\s*id\s*=\s*(\d+)\s*,\s*file\s*=\s*\"([^\"]+)\"\s*\}", text)]
    default_match = re.search(r"DEFAULT_IDS\s*=\s*\{([^}]+)\}", text)
    if not default_match:
        raise SystemExit("patches.luau: DEFAULT_IDS not found")
    defaults = [int(x) for x in re.findall(r"\d+", default_match.group(1))]
    return entries, defaults


def cmd_list(_args: argparse.Namespace) -> int:
    catalog = load_catalog()
    print(f"{'id':<6} {'ver':<6} {'def':<4} {'status':<10} summary")
    print("-" * 78)
    for patch in catalog["patches"]:
        flag = "yes" if patch.get("default") else "no"
        print(
            f"{patch['id']:<6} {patch['version']:<6} {flag:<4} {patch['status']:<10} {patch['summary']}"
        )
        if patch.get("commands"):
            print(f"       commands: {', '.join(patch['commands'])}")
    print()
    print("Run one:  python3 tools/iyp.py only 762")
    print("Skip one: python3 tools/iyp.py skip 761")
    print("Try a PR: python3 tools/iyp.py try 49")
    return 0


def cmd_only(args: argparse.Namespace) -> int:
    ids = [parse_id(x) for x in args.ids]
    print(snippet_for_ids(ids, ref=args.ref))
    return 0


def cmd_skip(args: argparse.Namespace) -> int:
    catalog = load_catalog()
    skip = {parse_id(x) for x in args.ids}
    defaults = [p["id"] for p in catalog["patches"] if p.get("default")]
    keep = [i for i in defaults if i not in skip]
    if not keep:
        raise SystemExit("skip list removed every default patch")
    print(snippet_for_ids(keep, ref=args.ref, catalog=catalog))
    return 0


def parse_id(value: str) -> int:
    cleaned = re.sub(r"^hotfix", "", value.strip(), flags=re.I)
    cleaned = re.sub(r"\.luau$", "", cleaned, flags=re.I)
    try:
        return int(cleaned)
    except ValueError as exc:
        raise SystemExit(f"not a hotfix id: {value}") from exc


def theme_for(title: str) -> str:
    for name, pattern in THEMES:
        if pattern.search(title):
            return name
    return "other"


def gh_json(args: list[str]) -> object:
    proc = subprocess.run(
        ["gh", *args],
        check=False,
        capture_output=True,
        text=True,
    )
    if proc.returncode != 0:
        raise SystemExit(proc.stderr.strip() or f"gh failed: {' '.join(args)}")
    return json.loads(proc.stdout)


def list_open_prs() -> list[dict]:
    data = gh_json(
        [
            "pr",
            "list",
            "--state",
            "open",
            "--limit",
            "100",
            "--json",
            "number,title,headRefName,url,author,createdAt",
        ]
    )
    if not isinstance(data, list):
        raise SystemExit("unexpected gh pr list payload")
    return data


def is_unusable(pr: dict) -> bool:
    title = pr.get("title") or ""
    return bool(re.search(r"DO NOT MERGE|\bWIP\b", title, re.I))


def pick_recommended(items: list[dict]) -> dict:
    ranked = sorted(items, key=lambda p: p["createdAt"], reverse=True)
    usable = [p for p in ranked if not is_unusable(p)]
    return (usable or ranked)[0]


def print_pr_groups(prs: list[dict], *, recommend: bool = True) -> None:
    groups: dict[str, list[dict]] = defaultdict(list)
    for pr in prs:
        groups[theme_for(pr["title"])].append(pr)
    print(f"Open PRs: {len(prs)}  |  unique axes: {len(groups)}")
    print()
    for theme, items in sorted(groups.items(), key=lambda kv: (-len(kv[1]), kv[0])):
        items = sorted(items, key=lambda p: p["createdAt"], reverse=True)
        pick = pick_recommended(items)
        print(f"## {theme}  ({len(items)})")
        if recommend:
            print(f"   try this one: python3 tools/iyp.py try {pick['number']}")
            print(f"   {pick['title']}")
            print(f"   {pick['url']}")
        for pr in items:
            author = (pr.get("author") or {}).get("login", "?")
            mark = " ★" if recommend and pr is pick and len(items) > 1 else ""
            broken = " (stub/WIP)" if is_unusable(pr) else ""
            print(f"   #{pr['number']:<4} {pr['headRefName']:<42} {author:<16}{mark}{broken}")
        print()


def cmd_prs(_args: argparse.Namespace) -> int:
    prs = list_open_prs()
    print_pr_groups(prs)
    return 0


def cmd_status(_args: argparse.Namespace) -> int:
    catalog = load_catalog()
    raw_version = (ROOT / "version").read_text(encoding="utf-8").strip()
    try:
        parsed = json.loads(raw_version)
        print(f"main version: {parsed.get('Version')}  ({parsed.get('Announcement') or 'no announcement'})")
    except json.JSONDecodeError:
        print(f"main version file: {raw_version}")
    print(f"pinned core commit: {catalog['core']['pinnedCommit']}")
    print(f"default patches: {', '.join(str(p['id']) for p in catalog['patches'] if p.get('default'))}")
    print()
    try:
        prs = list_open_prs()
    except SystemExit as exc:
        print(f"(open PRs unavailable: {exc})")
        return 0
    print_pr_groups(prs)
    print("Automation keeps opening new PRs on the same axes. Pick one per theme with `try`.")
    print("Do not merge a branch whose `source` is a tiny stub (see `try` warnings).")
    return 0


def head_source_bytes(ref: str) -> tuple[int, str | None]:
    url = raw_url(ref, "source")
    req = urllib.request.Request(url, method="HEAD")
    try:
        with urllib.request.urlopen(req, timeout=20) as resp:
            length = resp.headers.get("Content-Length")
            if length and length.isdigit():
                return int(length), None
    except urllib.error.HTTPError as err:
        return -1, f"HTTP {err.code} for {url}"
    except urllib.error.URLError as err:
        return -1, str(err.reason)
    # Some CDNs skip Content-Length on HEAD; fall back to a ranged GET.
    get = urllib.request.Request(url, headers={"Range": "bytes=0-0"})
    try:
        with urllib.request.urlopen(get, timeout=20) as resp:
            cr = resp.headers.get("Content-Range") or ""
            match = re.search(r"/(\d+)$", cr)
            if match:
                return int(match.group(1)), None
            length = resp.headers.get("Content-Length")
            if length and length.isdigit():
                return int(length), None
    except urllib.error.HTTPError as err:
        return -1, f"HTTP {err.code} for {url}"
    except urllib.error.URLError as err:
        return -1, str(err.reason)
    return -1, "could not determine source size"


def resolve_try_target(target: str) -> tuple[str, dict | None]:
    if target.isdigit():
        prs = list_open_prs()
        match = next((p for p in prs if int(p["number"]) == int(target)), None)
        if not match:
            raise SystemExit(f"no open PR #{target}")
        return match["headRefName"], match
    return target, None


def cmd_try(args: argparse.Namespace) -> int:
    catalog = load_catalog()
    target = args.target
    if re.fullmatch(r"hotfix?\d+|\d+", target.replace(".luau", ""), flags=re.I) and not target.startswith("cursor/"):
        maybe_id = parse_id(target)
        if maybe_id in patches_by_id(catalog):
            print("-- local hotfix on this ref")
            print(snippet_for_ids([maybe_id], ref=args.ref, catalog=catalog))
            return 0
    ref, pr = resolve_try_target(target)
    size, err = head_source_bytes(ref)
    print(f"-- branch: {ref}")
    if pr:
        print(f"-- PR #{pr['number']}: {pr['title']}")
        print(f"-- {pr['url']}")
        print(f"-- theme: {theme_for(pr['title'])}")
    if err:
        print(f"-- warning: {err}")
    elif size >= 0:
        print(f"-- source size: {size} bytes")
        if size < 50_000:
            print("-- WARNING: source on this branch is tiny. Likely a stub from a failed upload.")
            print("-- Do not load it. Pick another PR in the same theme: python3 tools/iyp.py prs")
            return 1
    print(loadstring(raw_url(ref, "source")))
    return 0


def cmd_check(_args: argparse.Namespace) -> int:
    catalog = load_catalog()
    errors: list[str] = []
    disk = sorted(p.name for p in ROOT.glob("hotfix*.luau"))
    catalog_files = [p["file"] for p in catalog["patches"]]
    if disk != sorted(catalog_files):
        errors.append(f"hotfix files on disk {disk} != catalog {sorted(catalog_files)}")
    for patch in catalog["patches"]:
        path = ROOT / patch["file"]
        if not path.is_file():
            errors.append(f"missing {patch['file']}")
            continue
        text = path.read_text(encoding="utf-8", errors="replace")
        for guard in patch.get("guards") or []:
            if guard not in text:
                errors.append(f"{patch['file']} missing guard {guard}")
    entries, defaults = parse_patches_luau()
    luau_ids = [i for i, _ in entries]
    catalog_ids = [p["id"] for p in catalog["patches"]]
    if luau_ids != catalog_ids:
        errors.append(f"patches.luau ids {luau_ids} != catalog {catalog_ids}")
    catalog_defaults = [p["id"] for p in catalog["patches"] if p.get("default")]
    if defaults != catalog_defaults:
        errors.append(f"DEFAULT_IDS {defaults} != catalog defaults {catalog_defaults}")
    for i, file_name in entries:
        expected = patches_by_id(catalog)[i]["file"]
        if file_name != expected:
            errors.append(f"id {i}: loader {file_name} != catalog {expected}")
    if errors:
        print("check failed:")
        for err in errors:
            print(f"  - {err}")
        return 1
    print("ok: catalog, hotfix files, and patches.luau match")
    return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="iyp",
        description="Run Infinity Yield Plus automation fixes one at a time.",
    )
    sub = parser.add_subparsers(dest="cmd", required=True)

    sub.add_parser("list", help="List local hotfixes (753–762) and what they do")

    only = sub.add_parser("only", help="Print a loadstring for one or more hotfix ids")
    only.add_argument("ids", nargs="+", help="Hotfix id(s), e.g. 762 or hotfix762")
    only.add_argument("--ref", default="main", help="Git ref for raw.githubusercontent.com (default: main)")

    skip = sub.add_parser("skip", help="Print a loadstring for the default chain minus some ids")
    skip.add_argument("ids", nargs="+")
    skip.add_argument("--ref", default="main")

    try_p = sub.add_parser("try", help="Print a loadstring for an open PR, branch, or hotfix id")
    try_p.add_argument("target", help="PR number, branch name, or hotfix id")
    try_p.add_argument("--ref", default="main", help="Used only when target is a hotfix id")

    sub.add_parser("prs", help="Group open automation PRs by theme")
    sub.add_parser("status", help="What is on main vs what automation is duplicating")
    sub.add_parser("check", help="Validate catalog.json against files and patches.luau")
    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    handlers = {
        "list": cmd_list,
        "only": cmd_only,
        "skip": cmd_skip,
        "try": cmd_try,
        "prs": cmd_prs,
        "status": cmd_status,
        "check": cmd_check,
    }
    return handlers[args.cmd](args)


if __name__ == "__main__":
    os.chdir(ROOT)
    sys.exit(main())
