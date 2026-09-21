# Changelog

## 7.63 — 2026-09-21

### Improved
- Command list rows show the primary name and arguments; aliases no longer eat the line and clip the name. Extra aliases appear as a small +N. Rows are tighter so more commands fit. Hover title clips by character, not raw bytes.

## 7.62 — 2026-09-14

### Added
- `env` (`executor`, `uncinfo`) — executor name plus http/clipboard/fs/hook capability flags.
- `device` (`platform`, `input`) — mobile/desktop, platform, touch/keyboard/gamepad.
- `showprefix` (`getprefix`, `pfx`) — current command prefix.
- `timezone` (`tz`, `zone`) — local zone offset and clock.
- `display` (`resolution`, `viewport`) — viewport size and GUI inset.
- `patches.luau` now loads 756–762 and retries HttpGet once on failure.
- `hotfixes` now also reports the 762 flag.
