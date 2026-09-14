# Changelog

## 7.63 — 2026-09-15

### Added
- `showhistory` (`hist`, `cmdhistory`) is in the main `source` command list.
- `clearhistory` (`clrhist`, `wipehistory`) clears ↑/↓ history and persists the empty list.

### Fixed
- `lastcommand` / `lastcmd` no longer indexes nil when history is empty.

### Notes
- One `loadstring` of `source` is enough. Version is 7.63 in `source`, `version`, and the README badge.

## 7.62 — 2026-09-14

### Added
- `env` (`executor`, `uncinfo`) — executor name plus http/clipboard/fs/hook capability flags.
- `device` (`platform`, `input`) — mobile/desktop, platform, touch/keyboard/gamepad.
- `showprefix` (`getprefix`, `pfx`) — current command prefix.
- `timezone` (`tz`, `zone`) — local zone offset and clock.
- `display` (`resolution`, `viewport`) — viewport size and GUI inset.
- `patches.luau` now loads 756–762 and retries HttpGet once on failure.
- `hotfixes` now also reports the 762 flag.

### Notes
- Main `source` is unchanged. Load `hotfix762.luau` after `source`, or just load `patches.luau`.
- Idempotent (`_G.__IYP_762_CMDS`). RU/EN strings for the new notices.
