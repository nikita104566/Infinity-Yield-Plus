# Changelog

## 7.63 — 2026-09-21

### Improved
- Automation Studio left list shows full event names (`OnCharacterRemoving` is no longer cut to `OnCharact…`); the command-count badge sits on the category line so the name has room.

### Notes
- One loadstring: `source`. `hotfix762` no longer overwrites a newer in-app version badge.

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

## 7.61 — 2026-09-14

### Added
- `info` (`dump`, `fullinfo`) — one notify: version, you, PlaceId, JobId, slots, server age, ping, memory.
- `copyjoin` (`cpjoin`, `joinline`) — copies `PlaceId | JobId` when clipboard exists.
- `creator` (`ownerid`, `gameowner`) — place name, CreatorType, CreatorId.
- `clock` (`datetime`, `now`) — local `os.date` stamp.
- `maxplayers` (`slots`, `cap`) — current / max players.
- `patches.luau` — one loader for hotfixes 756–761 so README only needs two loadstrings.
- `hotfixes` now also reports the 761 flag.

### Notes
- Main `source` is unchanged. Load `hotfix761.luau` after `source` (and after 756–760 if you still use them), or just load `patches.luau`.
- Idempotent (`_G.__IYP_761_CMDS`). RU/EN strings for the new notices.

## 7.60 — 2026-09-14

### Added
- `whoami` (`myinfo`, `iypme`) — local name, display name, UserId.
- `copyuserid` (`cpuid`, `copyuid`) — copies your UserId when clipboard is available.
- `copyjob` (`cpjob`, `copyjobid`) — copies JobId.
- `serverage` (`uptime`, `srvage`) — `DistributedGameTime` as h/m/s.
- `memory` (`mem`, `ram`) — total client memory usage when Stats allows it.
- `hotfixes` now also reports the 760 flag.

### Notes
- Main `source` is unchanged. Load `hotfix760.luau` after `source` (and after 756–759 if you still use them).
- Idempotent (`_G.__IYP_760_CMDS`). RU/EN strings for the new notices.
