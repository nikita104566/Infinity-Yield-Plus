# Changelog

## 7.63 — 2026-09-15

### Improved
- Automation Studio Inspector: selecting an event (no card) shows the event name, what fires it, clickable `$` variables that insert into the command box, and a list of commands to open for editing — empty events say to type one below.

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

## 7.59 — 2026-09-14

### Added
- `placeinfo` (`gameinfo`, `placeid`) — shows PlaceId, GameId, and JobId.
- `copyplace` (`cpplace`) — copies PlaceId to the clipboard when available.
- `players` (`plrs`, `plrlist`) — player count plus a short name sample.
- `session` (`ses`, `status`) — one-line snapshot: version, place, players, ping, fps.
- `hotfixes` (`hf`, `patches`) — which 754–759 hotfix flags are loaded.

### Notes
- Main `source` is unchanged. Load `hotfix759.luau` after `source` (and after 756–758 if you still use them).
- Idempotent (`_G.__IYP_759_CMDS`). RU/EN strings for the new notices.

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

## 7.50 — 2026-09-09

### Changed
- Bumped release version to **7.50** (`version`, README badge, in-app `currentVersion`).
- Synced Automation Studio build from the latest GPT polish pass into `source`.
