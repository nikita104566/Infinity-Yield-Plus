# Changelog

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
