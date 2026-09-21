# Changelog

## 7.63 — 2026-09-21

### Fixed
- `lastcommand` / `lastcmd` no longer errors when history is empty — the panel shows a short EN/RU notice instead.

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
- Main `source` is unchanged for 7.62 extras. Load `hotfix762.luau` after `source`, or just load `patches.luau`.
- Idempotent (`_G.__IYP_762_CMDS`). RU/EN strings for the new notices.

## 7.61 — 2026-09-14

### Added
- `info` (`dump`, `fullinfo`) — one notify: version, you, PlaceId, JobId, slots, server age, ping, memory.
- `copyjoin` (`cpjoin`, `joinline`) — copies `PlaceId | JobId` when clipboard exists.
- `creator` (`ownerid`, `gameowner`) — place name, CreatorType, CreatorId.
- `clock` (`datetime`, `now`) — local `os.date` stamp.
- `maxplayers` (`slots`, `cap`) — current / max players.

## 7.50 — 2026-09-09

### Changed
- Bumped release version to **7.50** (`version`, README badge, in-app `currentVersion`).
- Synced Automation Studio build from the latest GPT polish pass into `source`.
