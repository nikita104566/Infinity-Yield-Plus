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

## Features

- Command panel with search, autocomplete, keyboard arrows on an empty bar, and a **Favorites** section at the top of the list
- Add or remove favorites from the helper popup or with right-click; they stay pinned in add order
- Command history is saved across reload and rejoin (`lastcommand`, ↑ / ↓)
- Consecutive duplicates and meta-commands are not stored in history
- `showhistory` / `hist` lists recent saved commands
- `clearhistory` / `clrhist` wipes saved history
- `copyhistory` / `copycmd` copies the last command (`copyhistory all` for the full list)
- `starlast` / `favlast` pins the last command to favorites
- `repeatlast` / `again` re-runs the last real command
- `ping` / `fps` / `cmdcount` — quick diagnostics
- `placeinfo` / `copyplace` / `players` / `session` / `hotfixes` — place, roster, and loaded patches
- `whoami` / `copyuserid` / `copyjob` / `serverage` / `memory` — local player, job, uptime, RAM
- `info` / `dump` — one notify with version, you, place, job, slots, age, ping, memory
- `copyjoin` — copies `PlaceId | JobId`
- `creator` / `clock` / `maxplayers` — owner, local time, player cap
- `env` / `device` / `showprefix` / `timezone` / `display` — executor, input, prefix, zone, viewport
- `checkupdate` / `upd` compares the local version with GitHub and shows announcements
- Automation Studio — run command workflows on spawn, chat, tools, prompts, and other events
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
