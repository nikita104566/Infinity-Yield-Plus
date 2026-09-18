<p align="center">
  <img src="logo.png" alt="Infinity Yield Plus" width="360">
</p>

<p align="center">
  <b>Infinity Yield Plus</b><br>
  Admin commands for Roblox — modern UI, themes, keybinds, RU/EN
</p>

[![Version](https://img.shields.io/badge/version-7.63-blue.svg)](https://github.com/nikita104566/Infinity-Yield-Plus)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## Loadstring

```lua
loadstring(game:HttpGet('https://raw.githubusercontent.com/nikita104566/Infinity-Yield-Plus/main/source'))()
```

Open the panel with your prefix (default `;`).

One line is enough. History, diagnostics, and Automation Studio live in `source` (7.63). The old second loadstring (`patches.luau`) is optional compatibility: its default queue is empty, and `hotfix753.luau`–`hotfix762.luau` are no-op stubs when the core is already 7.62 or newer.

From a checkout: `python3 tools/iyp.py list` (legacy sidecar inventory), `python3 tools/iyp.py try 49` (one open automation PR). Details: [docs/FIXES.md](docs/FIXES.md). Agent rules: [AGENTS.md](AGENTS.md).

## Features

- Command panel with search, autocomplete, and a **Favorites** section at the top of the list (headers show counts)
- Command bar shows the current prefix as a gold chip
- Long alias lists collapse to `/ first +N`; favorited rows show a gold star
- Empty search keeps the panel open and shows an EN/RU “no match” hint
- Add or remove favorites from the helper popup, right-click, or `favcmd` / `unfavcmd` / `listfav`
- Command history is saved across reload and rejoin (`lastcommand`, ↑ / ↓)
- Consecutive duplicates and meta-commands are not stored in history
- `showhistory` / `hist` lists recent saved commands
- `clearhistory` / `clrhist` wipes saved history
- `copyhistory` / `copycmd` copies the last command (`copyhistory all` for the full list)
- `starlast` / `favlast` pins the last command to favorites
- `repeatlast` / `again` re-runs the last real command
- `latency` / `fps` / `cmdcount` — quick diagnostics (`ping` still maps to `notifyping`)
- `placeinfo` / `copyplace` / `players` / `session` / `hotfixes` — place, roster, and baked-patch status
- `whoami` / `copyuid` / `copyjob` / `serverage` / `memory` — local player, job, uptime, RAM
- `dump` / `fullinfo` — one notify with version, you, place, job, slots, age, ping, memory
- `copyjoin` — copies `PlaceId | JobId`
- `gameowner` / `clock` / `maxplayers` — owner, local time, player cap
- `env` / `device` / `showprefix` / `timezone` / `display` — executor, input, prefix, zone, viewport
- `checkupdate` / `upd` compares the local version with GitHub and shows announcements
- `studio` / `autostudio` / `eventstudio` opens or closes Automation Studio
- Automation Studio — full event names in the left list, run workflows on spawn, chat, tools, prompts, and other events
- Themes, keybinds, aliases, waypoints
- Russian / English UI
- Chain commands with `\\\\`
- Hot reload via `reload`

## Credits

Based on Infinite Yield and Infinite Yield Reborn. Thanks to the original IY / IYR teams and contributors.

## License

MIT — see [LICENSE](LICENSE).

## Disclaimer

This is an exploit script and violates Roblox ToS. Use at your own risk. Not affiliated with Roblox.
