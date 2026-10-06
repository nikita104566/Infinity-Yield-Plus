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

All v7.63 hotfixes and utilities (history persistence, diagnostics, custom crosshair, UI polish) are natively baked directly into `source` with zero external loader overhead.

### Standalone Tactical Crosshair

If you only need the pixel-perfect tactical crosshair without the full admin suite:

```lua
loadstring(game:HttpGet('https://raw.githubusercontent.com/nikita104566/Infinity-Yield-Plus/main/crosshair.luau'))()
```

## Features

- Command panel with search, autocomplete, and a **Favorites** section
- Add or remove favorites from the helper popup or with right-click; they stay pinned in add order
- Command history persistence across reloads and rejoins (`lastcommand`, ↑ / ↓)
- Consecutive duplicates and meta-commands automatically filtered from history
- `showhistory` / `clearhistory` / `copyhistory` / `starlast` / `repeatlast` — complete history toolkit
- `crosshair` / `ch` / `uncrosshair` / `noch` — customizable screen crosshair (color, size, gap, thickness)
- `listplugins` / `listaliases` / `listkeybinds` — instant in-panel inspection of active configurations
- `ping` / `fps` / `cmdcount` / `placeinfo` / `session` / `whoami` / `info` / `env` / `device` — instant diagnostics
- `antilag` / `boostfps` / `lowgraphics` — immediate rendering optimization for low-end machines
- Automation Studio — run command workflows on spawn, chat, tools, prompts, and other events
- Themes, keybinds, aliases, waypoints
- Complete English and Russian UI localization
- Chain commands with `\`
- Hot reload via `reload`

## Credits

Based on Infinite Yield and Infinite Yield Reborn. Thanks to the original IY / IYR teams and contributors.

## License

MIT — see [LICENSE](LICENSE).

## Disclaimer

This is an exploit script and violates Roblox ToS. Use at your own risk. Not affiliated with Roblox.
