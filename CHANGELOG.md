# Changelog

## 7.58 — 2026-09-14

### Added
- `repeatlast` (`again`, `rerun`) — re-runs the last real command from history (skips meta-commands).
- `ping` (`latency`) — shows current Data Ping when Stats is available.
- `fps` — shows physics / frame estimate.
- `cmdcount` (`cmdn`) — reports how many commands are registered.
- `checkupdate` now also shows the GitHub `Announcement` field when it is set.

### Notes
- Main `source` is unchanged. Load `hotfix758.luau` after `source` (and after 756/757 if you still use them).
- Idempotent (`_G.__IYP_758_CMDS`). RU/EN strings for the new notices.

## 7.57 — 2026-09-14

### Added
- `checkupdate` (`upd`, `vercheck`) — compares local version with GitHub `version` file.
- `copyhistory` (`copyhist`, `copycmd`) — copies the last command; `copyhistory all` copies the full list.
- `starlast` (`favlast`, `pinlast`) — pins the last history command to favorites when the favorites API is present.

### Notes
- Main `source` is unchanged. Load `hotfix757.luau` after `source`. You can skip 754–756 if you only need the new commands; keep 756 if you want history dedup / `showhistory`.
- Idempotent (`_G.__IYP_757_CMDS`). RU/EN strings for the new notices.

## 7.56 — 2026-09-14

### Improved
- Consecutive duplicate history entries are collapsed.
- Meta commands (`clearhistory`, `lastcommand`, `showhistory` and aliases) are not stored in ↑/↓ history.
- New command: `showhistory` (`hist`, `cmdhistory`) — shows the last few saved commands.
- History is re-sanitized and capped at 30 after each exec (still debounced ~0.35s).
- Version badge set to 7.56. Idempotent (`_G.__IYP_756_*` guards).

### Notes
- Main `source` is still the 7.50 core plus earlier baked fixes. Load `hotfix756.luau` after `source`. You can skip 754/755 if you load 756.

## 7.55 — 2026-09-14

### Improved
- Save-on-exec from 7.54 is now debounced (~0.35s). Rapid commands no longer hammer `IY_FE.iy`.
- New command: `clearhistory` (`clrhist`, `wipehistory`) — clears ↑/↓ history and persists the empty list.
- Version badge set to 7.55. Idempotent (`_G.__IYP_755_*` guards).

### Notes
- Main `source` is still the 7.50 core plus earlier baked fixes. Load `hotfix755.luau` after `source`. `hotfix754` is optional if you already load 755.

## 7.54 — 2026-09-14

### Fixed
- `lastcommand` / `lastcmd` no longer errors when history is empty; shows a short RU/EN notice instead.
- Command history is written to and restored from `IY_FE.iy`.
- Panel version badge is set to 7.54 by `hotfix754.luau` (main `source` still ships as 7.50 core).

### Improved
- History persist is sanitized (strings only, max 30) on load and save.
- Executing a command schedules `updatesaves` so ↑ / ↓ history survives reload and rejoin.
- Hotfix is idempotent (`_G.__IYP_754_*` guards) and safe if loaded twice.

## 7.53 — 2026-09-14

### Fixed
- In-app `currentVersion` was still `7.50` while README / `version` said `7.52`.
- `lastcommand` / `lastcmd` no longer errors when history is empty; shows a short RU/EN notice instead.
- Command history is now written to and restored from `IY_FE.iy` (`updatesaves` previously never stored `cmdHistory`).

### Improved
- History persist uses the existing save path, capped at 30 string entries, and is sanitized on load.
- Executing a command schedules `updatesaves` so ↑ / ↓ history survives reload and rejoin.

## 7.52 — 2026-09-14

### Fixed
- In-app `currentVersion` was still `7.50` after the 7.51 release (badge vs panel mismatch).
- `lastcommand` / `lastcmd` no longer errors when history is empty; shows a short notice instead.
- Command history is actually written to and restored from `IY_FE.iy` (the 7.51 note was incomplete: history lived only in memory).

### Improved
- History persist uses the existing save path, capped at 30 string entries, and is sanitized on load.
- Executing a command now schedules `updatesaves` so history survives reload and rejoin.

## 7.51 — 2026-09-14

### Fixed
- `lastcommand` / `lastcmd` no longer errors when the history list is empty.

### Improved
- Command history (↑ / ↓ in the command bar) is now saved to `IY_FE.iy` and restored after reload or rejoin.
- History is capped at 30 entries and written through the existing save cooldown.

## 7.50 — 2026-09-09

### Changed
- Bumped release version to **7.50** (`version`, README badge, in-app `currentVersion`).
- Synced Automation Studio build from the latest GPT polish pass into `source`.

### Improved
- Command picker: skip empty `NAME` separators, full A–Z list, scroll to the last command.
- Variable chips stay inside the center panel; insert into the focused command box.
- Inspector hides empty Conditions; Runtime uses compact rows.
