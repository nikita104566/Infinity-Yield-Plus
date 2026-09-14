# Changelog

## 7.52 — 2026-09-14

### Fixed
- In-app `currentVersion` was still `7.50` after the 7.51 release (badge vs panel mismatch).
- `lastcommand` / `lastcmd` no longer errors when history is empty; shows a short notice instead.
- Command history is actually written to and restored from `IY_FE.iy` (the 7.51 note was incomplete: history lived only in memory).

### Improved
- History persist uses the existing save path, capped at 30 string entries, and is sanitized on load.
- Executing a command now schedules `updatesaves` so ↑ / ↓ history survives reload and rejoin.

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
