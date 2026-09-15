# Infinity Yield Plus — agent rules

This file is the contract for Cursor automations and agents working in this repo.
Read it before changing `source`, `hotfix*.luau`, or `patches.luau`.

## What this repo actually is

- `source` on `main` is the 7.50 core (plus earlier baked history work). It is ~1 MB.
- Player-facing 7.56–7.62 commands live in `hotfix756.luau` … `hotfix762.luau`.
- `patches.luau` loads the default chain (756–762). It does **not** replace `source`.
- `hotfix/catalog.json` is the inventory. `python3 tools/iyp.py check` must stay green.
- The version badge on `main` is 7.62. Do not invent 7.63/7.64/7.65/7.66 in docs unless that version is actually in `source` on the branch.

## First command, every tick

```bash
python3 tools/iyp.py status
```

That prints what is on `main` and groups **open** automation PRs by theme. If your idea already has an open PR, **stop**. Do not open a duplicate. Improve that existing branch or pick a different axis.

## How a human runs one fix

Local hotfix (already on `main`):

```bash
python3 tools/iyp.py only 762
```

One open automation PR (loads that branch’s `source`):

```bash
python3 tools/iyp.py try 49
```

If `try` warns that `source` is tiny, the branch is a failed upload. Do not merge it. Do not load it.

## What you may change in one PR

Exactly **one** player-visible axis. Examples of axes (pick one that is not already open):

- Command panel empty-search hint
- Favorite mark in the command list
- `lastcommand` empty-history notify
- Automation Studio left-list event names
- `;studio` command
- History persist in `IY_FE.iy`

Do not mix two axes. Do not “also bump version + rewrite README loadstring + add hotfix763”.

## Hard stops

1. **Do not create `hotfix763.luau` (or any new numbered hotfix)** unless the human explicitly asked for a new sidecar file. New work belongs in `source`, or in an existing catalogued hotfix if you are fixing that file.
2. **Do not replace `source` with a stub loader.** If the blob is too large to upload in one tool call, commit a `*.patch` (or say so in the PR and leave `source` untouched). A 1 KB `source` that HttpGets `main` is a broken branch.
3. **Do not overwrite a newer `currentVersion` with 7.62** from leftover hotfixes. If you touch a hotfix badge stamp, keep the `major*1000+minor` / “already newer” guard.
4. **Do not add eventEditor IIFE top-level locals.** The Studio IIFE is at the Luau local cap.
5. **Do not insert `\u00` escapes into `source`.**
6. **Do not claim in-game testing** if Potassium / a Roblox executor was not available. Write “static pass only”.
7. **Do not duplicate an open theme.** `python3 tools/iyp.py prs` is the source of truth.

## PR description (required shape)

1. What the player sees (one sentence).
2. Where to click (numbered).
3. Empty path (what happens when there is nothing to show).
4. What file changed (`source` hunk vs hotfix vs docs).
5. How it was checked (static / compile / in-game).
6. “Not this tick” — the axes you left alone.

Title: `7.62: <visible change>` until `source` on `main` actually becomes a newer version.

## After you touch hotfixes or the loader

```bash
python3 tools/iyp.py check
python3 tools/test_iyp.py
```

If you add or rename a hotfix file, update `hotfix/catalog.json` **and** the `PATCHES` / `DEFAULT_IDS` tables in `patches.luau` in the same commit.
