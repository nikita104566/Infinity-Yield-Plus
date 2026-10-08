# Changelog

## 7.64 — 2026-10-08

- Each command row has a star: click it to pin or unpin that command in Favorites.

## 7.63 — 2026-10-06

### Added
- **Native Baked Hotfixes:** Integrated all 26+ hotfix loader utilities directly into `source`, eliminating secondary network calls (`patches.luau`).
- **Tactical Crosshair:** Added `crosshair` (`ch`, `customcrosshair`) and `uncrosshair` (`noch`) with full color presets, hex support, size, gap, and stroke configuration.
- **Inspection Commands:** Added `listplugins`, `listaliases`, and `listkeybinds` to inspect active configurations directly in-game.
- **System & Session Telemetry:** Added `ping`, `fps`, `cmdcount`, `placeinfo`, `copyplace`, `players`, `session`, `hotfixes`, `whoami`, `copyuserid`, `copyjob`, `serverage`, `memory`, `info`, `copyjoin`, `creator`, `clock`, `maxplayers`, `env`, `device`, `showprefix`, `timezone`, and `display`.
- **History Toolkit:** Added `showhistory`, `clearhistory`, `copyhistory`, `starlast`, and `repeatlast` with debounce and disk persistence.

### Improved
- **Minimalist Cmdbar & Command List:** Placeholder simplified to clean `Command`/`Команда`. Removed confusing `+N` alias count numbers from command rows.
- **Dynamic Favorites Section:** Favorites header and hints now remain completely hidden until at least one command is favorited.
- **Roblox Escape Menu Tab Isolation:** Intercepted and sunk `Tab` via high-priority `ContextActionService` when the command bar is focused, preventing accidental UI selection changes in Roblox's Escape Menu.
- **Streamlined Settings:** Removed redundant search bar and manual "Saved" status button; settings rows display immediately under the title.
- **Automation Studio:** Dynamic multi-line wrapping for event names (e.g., `OnCharacterRemoving`), wrapped variable chip row (`$me`, `$place`, `$job`, `$time`, `$event`), and empty match state in workflow picker.
- **Full Localization Parity:** 100% RU/EN translation coverage for all UI chrome, hints, dialogs, and command descriptions.
- **Memory & Teardown Integrity:** Hardened `IYR_CLEANUP` to prevent duplicate ScreenGui leaks on hot reload and client reconnects.

## 7.62 — 2026-09-14

### Added
- `env` (`executor`, `uncinfo`) — executor name plus http/clipboard/fs/hook capability flags.
- `device` (`platform`, `input`) — mobile/desktop, platform, touch/keyboard/gamepad.
- `showprefix` (`getprefix`, `pfx`) — current command prefix.
- `timezone` (`tz`, `zone`) — local zone offset and clock.
- `display` (`resolution`, `viewport`) — viewport size and GUI inset.
- `patches.luau` now loads 756–762 and retries HttpGet once on failure.
- `hotfixes` now also reports the 762 flag.

## 7.61 — 2026-09-14

### Added
- `info` (`dump`, `fullinfo`) — one notify: version, you, PlaceId, JobId, slots, server age, ping, memory.
- `copyjoin` (`cpjoin`, `joinline`) — copies `PlaceId | JobId` when clipboard exists.
- `creator` (`ownerid`, `gameowner`) — place name, CreatorType, CreatorId.
- `clock` (`datetime`, `now`) — local `os.date` stamp.
- `maxplayers` (`slots`, `cap`) — current / max players.
- `patches.luau` — one loader for hotfixes 756–761 so README only needs two loadstrings.
- `hotfixes` now also reports the 761 flag.

## 7.60 — 2026-09-14

### Added
- `whoami` (`myinfo`, `iypme`) — local name, display name, UserId.
- `copyuserid` (`cpuid`, `copyuid`) — copies your UserId when clipboard is available.
- `copyjob` (`cpjob`, `copyjobid`) — copies JobId.
- `serverage` (`uptime`, `srvage`) — `DistributedGameTime` as h/m/s.
- `memory` (`mem`, `ram`) — total client memory usage when Stats allows it.
- `hotfixes` now also reports the 760 flag.

## 7.59 — 2026-09-14

### Added
- `placeinfo` (`gameinfo`, `placeid`) — shows PlaceId, GameId, and JobId.
- `copyplace` (`cpplace`) — copies PlaceId to the clipboard when available.
- `players` (`plrs`, `plrlist`) — player count plus a short name sample.
- `session` (`ses`, `status`) — one-line snapshot: version, place, players, ping, fps.
- `hotfixes` (`hf`, `patches`) — which 754–759 hotfix flags are loaded.

## 7.58 — 2026-09-14

### Added
- `repeatlast` (`again`, `rerun`) — re-runs the last real command from history (skips meta-commands).
- `ping` (`latency`) — shows current Data Ping when Stats is available.
- `fps` — shows physics / frame estimate.
- `cmdcount` (`cmdn`) — reports how many commands are registered.
- `checkupdate` now also shows the GitHub `Announcement` field when it is set.

## 7.57 — 2026-09-14

### Added
- `checkupdate` (`upd`, `vercheck`) — compares local version with GitHub `version` file.
- `copyhistory` (`copyhist`, `copycmd`) — copies the last command; `copyhistory all` copies the full list.
- `starlast` (`favlast`, `pinlast`) — pins the last history command to favorites when the favorites API is present.

## 7.56 — 2026-09-14

### Improved
- Consecutive duplicate history entries are collapsed.
- Meta commands (`clearhistory`, `lastcommand`, `showhistory` and aliases) are not stored in ↑/↓ history.
- New command: `showhistory` (`hist`, `cmdhistory`) — shows the last few saved commands.
- History is re-sanitized and capped at 30 after each exec (still debounced ~0.35s).
- Version badge set to 7.56. Idempotent (`_G.__IYP_756_*` guards).

## 7.55 — 2026-09-14

### Improved
- Save-on-exec from 7.54 is now debounced (~0.35s). Rapid commands no longer hammer `IY_FE.iy`.
- New command: `clearhistory` (`clrhist`, `wipehistory`) — clears ↑/↓ history and persists the empty list.
- Version badge set to 7.55. Idempotent (`_G.__IYP_755_*` guards).

## 7.50 — 2026-09-09

### Changed
- Bumped release version to **7.50** (`version`, README badge, in-app `currentVersion`).
- Synced Automation Studio build from the latest GPT polish pass into `source`.
