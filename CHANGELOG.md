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
- Main `source` is unchanged. Load `hotfix757.luau` after `source`.
- Idempotent (`_G.__IYP_757_CMDS`).
