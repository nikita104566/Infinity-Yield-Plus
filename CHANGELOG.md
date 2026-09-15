# Changelog

## 7.63 — 2026-09-15

### Improved
- Command list shows a star and a count on the Favorites header so pinned rows are obvious at a glance.
- While typing a search, alias tails are hidden so the primary command name is not cut off.
- A typed search with no hits shows “No matching commands” instead of a blank list.

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
