#!/usr/bin/env python3
"""Tests for tools/iyp.py — catalog, loader sync, snippet generation, PR grouping."""

from __future__ import annotations

import importlib.util
import json
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(Path(__file__).resolve().parent))

SPEC = importlib.util.spec_from_file_location("iyp", ROOT / "tools" / "iyp.py")
assert SPEC and SPEC.loader
iyp = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(iyp)


class CatalogTests(unittest.TestCase):
    def test_catalog_ids_are_unique_and_sorted(self):
        catalog = iyp.load_catalog()
        ids = [p["id"] for p in catalog["patches"]]
        self.assertEqual(ids, sorted(set(ids)))
        self.assertGreaterEqual(len(ids), 10)

    def test_default_chain_is_empty(self):
        catalog = iyp.load_catalog()
        defaults = [p["id"] for p in catalog["patches"] if p.get("default")]
        self.assertEqual(defaults, [])
        for patch in catalog["patches"]:
            self.assertEqual(patch.get("status"), "baked")
            self.assertFalse(patch.get("default"))

    def test_check_passes_on_this_tree(self):
        with mock.patch("builtins.print"):
            self.assertEqual(iyp.cmd_check(None), 0)

    def test_patches_luau_parses(self):
        entries, defaults = iyp.parse_patches_luau()
        self.assertEqual([i for i, _ in entries], list(range(753, 763)))
        self.assertEqual(defaults, [])


class SnippetTests(unittest.TestCase):
    def test_only_one_loads_the_file_directly(self):
        text = iyp.snippet_for_ids([762])
        self.assertIn("Infinity-Yield-Plus/main/source", text)
        self.assertIn("hotfix762.luau", text)
        self.assertNotIn("IYP_ONLY", text)

    def test_only_several_sets_iyp_only(self):
        text = iyp.snippet_for_ids([756, 762])
        self.assertIn("_G.IYP_ONLY = { 756, 762 }", text)
        self.assertIn("patches.luau", text)

    def test_unknown_id_exits(self):
        with self.assertRaises(SystemExit):
            iyp.snippet_for_ids([799])

    def test_only_cli(self):
        ns = iyp.build_parser().parse_args(["only", "762"])
        with mock.patch("builtins.print"):
            self.assertEqual(iyp.cmd_only(ns), 0)

    def test_skip_on_baked_core_prints_source_only(self):
        ns = iyp.build_parser().parse_args(["skip", "761"])
        with mock.patch("builtins.print") as printer:
            self.assertEqual(iyp.cmd_skip(ns), 0)
        text = "\n".join(str(c.args[0]) for c in printer.call_args_list)
        self.assertIn("Infinity-Yield-Plus/main/source", text)
        self.assertIn("baked into source", text)
        self.assertNotIn("IYP_ONLY", text)
        self.assertNotIn("hotfix761.luau", text)


class ThemeTests(unittest.TestCase):
    def test_known_titles(self):
        self.assertEqual(iyp.theme_for("7.63: lastcommand does not crash on empty history"), "lastcommand-empty")
        self.assertEqual(iyp.theme_for("7.63: full event names in Studio left list"), "studio-event-names")
        self.assertEqual(iyp.theme_for("7.63: open Automation Studio with ;studio"), "studio-command")
        self.assertEqual(iyp.theme_for("7.62: Command Palette RU/EN (Ctrl+K)"), "command-palette")
        self.assertEqual(iyp.theme_for("totally new idea"), "other")
        self.assertEqual(
            iyp.theme_for("WIP 7.63: empty command search line — DO NOT MERGE until source blob is restored"),
            "empty-search",
        )

    def test_recommend_skips_wip(self):
        prs = [
            {
                "number": 42,
                "title": "WIP 7.63: empty command search line — DO NOT MERGE until source blob is restored",
                "headRefName": "broken",
                "url": "https://example.test/42",
                "author": {"login": "nikita104566"},
                "createdAt": "2026-09-15T10:09:21Z",
            },
            {
                "number": 44,
                "title": "7.63: empty search state and counts in the command list",
                "headRefName": "ok",
                "url": "https://example.test/44",
                "author": {"login": "nikita104566"},
                "createdAt": "2026-09-15T11:20:11Z",
            },
        ]
        with mock.patch("builtins.print") as printer:
            iyp.print_pr_groups(prs)
        text = "\n".join(str(c.args[0]) for c in printer.call_args_list if c.args)
        self.assertIn("try this one: python3 tools/iyp.py try 44", text)
        self.assertIn("(stub/WIP)", text)
        self.assertNotIn("try this one: python3 tools/iyp.py try 42", text)

    def test_try_tiny_source_refuses_to_print_loadstring(self):
        pr = {
            "number": 42,
            "title": "WIP 7.63: empty command search line — DO NOT MERGE until source blob is restored",
            "headRefName": "iyp-7.63-empty-search",
            "url": "https://example.test/42",
            "author": {"login": "x"},
            "createdAt": "2026-09-15T10:09:21Z",
        }
        ns = iyp.build_parser().parse_args(["try", "42"])
        with mock.patch.object(iyp, "list_open_prs", return_value=[pr]), mock.patch.object(
            iyp, "head_source_bytes", return_value=(254, None)
        ), mock.patch("builtins.print") as printer:
            self.assertEqual(iyp.cmd_try(ns), 1)
        text = "\n".join(str(c.args[0]) for c in printer.call_args_list if c.args)
        self.assertIn("WARNING", text)
        self.assertNotIn("loadstring", text)

    def test_print_pr_groups_picks_newest(self):
        prs = [
            {
                "number": 1,
                "title": "7.63: lastcommand does not crash on empty history",
                "headRefName": "old",
                "url": "https://example.test/1",
                "author": {"login": "bot"},
                "createdAt": "2026-09-14T00:00:00Z",
            },
            {
                "number": 45,
                "title": "7.63: lastcommand does not crash on empty history",
                "headRefName": "cursor/iyp-d6f1",
                "url": "https://example.test/45",
                "author": {"login": "app/cursor"},
                "createdAt": "2026-09-15T11:49:54Z",
            },
        ]
        with mock.patch("builtins.print") as printer:
            iyp.print_pr_groups(prs)
        text = "\n".join(str(c.args[0]) for c in printer.call_args_list if c.args)
        self.assertIn("try this one: python3 tools/iyp.py try 45", text)
        self.assertIn("unique axes: 1", text)


class LoaderLuaTests(unittest.TestCase):
    def test_loader_documents_selectors(self):
        text = iyp.PATCHES_PATH.read_text(encoding="utf-8")
        self.assertIn("_G.IYP_ONLY", text)
        self.assertIn("_G.IYP_SKIP", text)
        self.assertIn("_G.IYP_PATCH_BASE", text)

    def test_catalog_json_is_valid(self):
        with iyp.CATALOG_PATH.open(encoding="utf-8") as fh:
            data = json.load(fh)
        for patch in data["patches"]:
            self.assertIn("id", patch)
            self.assertIn("file", patch)
            self.assertIn("summary", patch)
            self.assertIn("commands", patch)


class SourceBakeTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.source = (ROOT / "source").read_text(encoding="utf-8", errors="replace")

    def test_current_version_is_763(self):
        self.assertIn("currentVersion = '7.63'", self.source)

    def test_lastcommand_is_nil_safe(self):
        self.assertIn("addcmd('lastcommand'", self.source)
        self.assertIn('type(cmdHistory) == "table" and cmdHistory[1]', self.source)
        self.assertIn('T("lastCmdEmpty")', self.source)
        self.assertNotRegex(self.source, r"cmdHistory\[1\]:sub")

    def test_cmd_history_persists(self):
        self.assertIn("json.cmdHistory", self.source)
        self.assertIn("cmdHistory = (function()", self.source)
        self.assertIn("scoreCache.histSaveToken", self.source)

    def test_baked_commands_are_registered(self):
        for name in (
            "clearhistory",
            "showhistory",
            "checkupdate",
            "copyhistory",
            "starlast",
            "repeatlast",
            "latency",
            "fps",
            "cmdcount",
            "placeinfo",
            "copyplace",
            "players",
            "session",
            "hotfixes",
            "whoami",
            "copyuid",
            "copyjob",
            "serverage",
            "memory",
            "dump",
            "copyjoin",
            "gameowner",
            "clock",
            "maxplayers",
            "env",
            "device",
            "showprefix",
            "timezone",
            "display",
            "studio",
            "favcmd",
            "unfavcmd",
            "listfav",
        ):
            self.assertIn(f"addcmd('{name}'", self.source)

    def test_starlast_uses_favcmds_toggle(self):
        self.assertIn("FavCmds.toggle", self.source)

    def test_source_does_not_assign_i18n(self):
        self.assertNotIn("I18N", self.source)

    def test_empty_search_hint(self):
        self.assertIn("cmdNoMatch", self.source)
        self.assertIn("cmdEmptyLabel", self.source)
        self.assertIn('typedFilter ~= "" and indexnum == 0', self.source)

    def test_studio_left_list(self):
        self.assertIn("EE_LEFT_W, EE_RIGHT_W, EE_GAP, EE_FOOTER_H = 256, 248, 12, 52", self.source)
        self.assertIn("TextTruncate = Enum.TextTruncate.None", self.source)

    def test_studio_command_opens_editor(self):
        self.assertIn("addcmd('studio', {'autostudio', 'eventstudio'}", self.source)
        self.assertIn("eventEditor.Open()", self.source)

    def test_astra_prefix_chip(self):
        self.assertIn('PrefixChip.Name = "PrefixChip"', self.source)
        self.assertIn("function updatePrefixChip()", self.source)

    def test_astra_section_counts(self):
        self.assertIn("function refreshCmdSectionHeaders()", self.source)
        self.assertIn("cmdSectionFavN = #favRanked", self.source)

    def test_astra_compact_aliases(self):
        self.assertIn('compact = compact .. " +" .. tostring(#parts - 1)', self.source)

    def test_astra_picker_empty(self):
        self.assertIn("eePickerEmpty", self.source)
        self.assertIn("setPickerVisible(true, y)", self.source)


class HotfixStubTests(unittest.TestCase):
    def test_hotfixes_are_stubs(self):
        for n in range(753, 763):
            text = (ROOT / f"hotfix{n}.luau").read_text(encoding="utf-8")
            self.assertIn("compatibility stub", text)
            self.assertIn("iypStubAtLeast(7, 62)", text)
            self.assertNotRegex(text, r'currentVersion\s*=')
            self.assertNotIn("I18N", text)

    def test_version_file_is_763(self):
        data = json.loads((ROOT / "version").read_text(encoding="utf-8"))
        self.assertEqual(data["Version"], "7.63")


class IsolatedCatalogCheck(unittest.TestCase):
    def test_check_fails_when_file_missing(self):
        with tempfile.TemporaryDirectory() as tmp:
            tmp_path = Path(tmp)
            (tmp_path / "hotfix").mkdir()
            (tmp_path / "hotfix753.luau").write_text("-- stub\n", encoding="utf-8")
            catalog = {
                "patches": [
                    {
                        "id": 753,
                        "file": "hotfix753.luau",
                        "default": False,
                        "status": "stub",
                        "summary": "x",
                        "commands": [],
                        "guards": ["__MISSING__"],
                    }
                ]
            }
            (tmp_path / "hotfix" / "catalog.json").write_text(json.dumps(catalog), encoding="utf-8")
            (tmp_path / "patches.luau").write_text(
                'local PATCHES = {\n\t{ id = 753, file = "hotfix753.luau" },\n}\nlocal DEFAULT_IDS = { }\n',
                encoding="utf-8",
            )
            with mock.patch.object(iyp, "ROOT", tmp_path), mock.patch.object(
                iyp, "CATALOG_PATH", tmp_path / "hotfix" / "catalog.json"
            ), mock.patch.object(iyp, "PATCHES_PATH", tmp_path / "patches.luau"), mock.patch("builtins.print"):
                self.assertEqual(iyp.cmd_check(None), 1)


if __name__ == "__main__":
    unittest.main()
