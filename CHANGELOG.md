# Changelog

## 7.50 — 2026-09-09

### Changed
- Bumped release version to **7.50** (`version`, README badge, in-app `currentVersion`).
- Synced Automation Studio build from the latest GPT polish pass into `source`.

### Improved
- Command picker: skip empty `NAME` separators, full A–Z list, scroll to the last command.
- Variable chips stay inside the center panel; insert into the focused command box.
- Inspector hides empty Conditions; Runtime uses compact rows.

## Automation Studio UI — 2026-09-09

### Improved
- Rebuilt the Automation Studio header into a clean single-row layout with balanced 8 px spacing and 16 px vertical margins.
- Extended the header background to the panel boundary, removing the dark 12 px strip below the top bar.
- Unified the workflow counter, Pause, History, and Close controls with neutral backgrounds and outlines; accent color is now limited to status text and dots.
- Added clearer OFF, PAUSED, GROUP OFF, and ERROR states to workflow cards.
- Reworked workflow action controls with vector icons, larger hit areas, consistent alignment, and front-layer tooltips for Move up, Move down, Run, Preview, Copy, and Delete.
- Added a centralized inspector tooltip overlay so hints no longer render behind neighboring panels.
- Fixed inspector bottom clipping, scrolling behavior, top/bottom fades, and selective scroll reset.
- Standardized panel/footer spacing to a 12 px grid and scrollbars to 5 px.
- Changed category chips to wrap automatically instead of using a fixed 48 px row.
- Added focus outlines for inspector fields and clearer vector icons for copy, group folding, rename, and undo.
- Improved topbar spacing, card alignment, responsive scaling, rerun cleanup, localization persistence, and keyboard shortcuts.

### Validation
- Final build: `UI9R`
- Source size: `958695` bytes
- SHA-256: `2f888ba99f42e5272ab2c2220f6215f28d6b717b985e87d5942c6b4cceb6cfb0`
- Luau compile check: passed
- Client runtime verification: window opened and visible; header clean, gap-free, neutral, and aligned.
- Inspector verification: 6 actions and 6 tooltips, with no clipped controls.
