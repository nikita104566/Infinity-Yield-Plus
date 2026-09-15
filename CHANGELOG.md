# Changelog

## 7.63 — 2026-09-15

### Improved
- Command list shows a star and a count on the Favorites header so pinned rows are obvious at a glance.
- While typing a search, alias tails are hidden so the primary command name is not cut off.
- A typed search with no hits shows “No matching commands” instead of a blank list.

## 7.62 — 2026-09-14

### Added
- Diagnostic hotfix commands (`env`, `device`, `showprefix`, `timezone`, `display`) via patches.luau / hotfix762.
- `patches.luau` retries HttpGet once on failure.

### Notes
- 7.62 did not change main `source`.
