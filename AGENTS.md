# Infinity Yield Plus — agent rules

This file is the contract for Cursor automations and agents working in this repo.
Read it before changing `source`, `hotfix*.luau`, or `patches.luau`.

## What this repo actually is

- `source` on this branch is the **7.63** core (~1 MB). History, diagnostics, and `;studio` live here.
- `hotfix753.luau` … `hotfix762.luau` are **legacy stubs**. If `currentVersion` is already ≥ 7.62 they do nothing and must not downgrade the badge.
- `patches.luau` default queue is **empty**. `_G.IYP_ONLY` can still load a stub if a human asks.
- `hotfix/catalog.json` is the inventory (`status: "baked"`). `python3 tools/iyp.py check` must stay green.
- The version badge is 7.63. Do not invent 7.64+ in docs unless that version is actually in `source` on the branch.

## First command, every tick

```bash
python3 tools/iyp.py status
```

That prints what is on `main` and groups **open** automation PRs by theme. If your idea already has an open PR, **stop**. Do not open a duplicate. Improve that existing branch or pick a different axis.

## How a human runs the script

```bash
python3 tools/iyp.py try 49
```

If `try` warns that `source` is tiny, the branch is a failed upload. Do not merge it. Do not load it.

Legacy sidecar (almost never needed after 7.63):

```bash
python3 tools/iyp.py only 762
```

## What you may change in one PR

Exactly **one** player-visible axis unless the human asked to bake or ship a version bump.

Examples of axes (pick one that is not already open):

- Favorite mark in the command list
- Alias highlight
- Ctrl+K command palette
- `;reload` listeners

Do not mix two axes. Do not add `hotfix763`.

## Hard stops

1. **Do not create `hotfix763.luau` (or any new numbered hotfix)** unless the human explicitly asked for a new sidecar file. New work belongs in `source`.
2. **Do not replace `source` with a stub loader.** If the blob is too large to upload in one tool call, commit a `*.patch` (or say so in the PR and leave `source` untouched). A 1 KB `source` that HttpGets `main` is a broken branch.
3. **Do not overwrite a newer `currentVersion` with 7.62** from leftover hotfixes. Stubs must no-op when the core is already ≥ 7.62.
4. **Do not add eventEditor IIFE top-level locals.** The Studio IIFE is at the Luau local cap.
5. **Do not insert `\u00` escapes into `source`.**
6. **Do not claim in-game testing** if Potassium / a Roblox executor was not available. Write “static pass only”.
7. **Do not duplicate an open theme.** `python3 tools/iyp.py prs` is the source of truth.
8. **Do not clobber existing commands.** `info`/`serverinfo`, `creator`/`creatorid`, `ping`/`notifyping`, `copyuserid`/`copyid` already exist — use new names (`dump`, `gameowner`, `latency`, `copyuid`).
9. **Use `UI_L` / `T()`, not `I18N`.** There is no `I18N` table in `source`.
10. **`starlast` must go through `FavCmds.toggle`** (or `toggleFavoriteCmd`). There is no `addFavorite` API.

## PR description (required shape)

1. What the player sees (one sentence).
2. Where to click (numbered).
3. Empty path (what happens when there is nothing to show).
4. What file changed (`source` hunk vs hotfix vs docs).
5. How it was checked (static / compile / in-game).
6. “Not this tick” — the axes you left alone.

Title: `7.63: <visible change>` until `source` on `main` actually becomes a newer version.

## After you touch hotfixes or the loader

```bash
python3 tools/iyp.py check
python3 tools/test_iyp.py
```

If you add or rename a hotfix file, update `hotfix/catalog.json` **and** the `PATCHES` / `DEFAULT_IDS` tables in `patches.luau` in the same commit.
