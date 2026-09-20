# Changelog

## 7.63 — 2026-09-20

### Improved
- Command list rows show the primary name and arguments only; long alias chains no longer eat the 300px row.
- Hover helper title is the primary command; aliases appear above the description.

### Notes
- One loadstring of `source` is enough for this change.
- If an old `hotfix762.luau` still loads after source, it no longer overwrites a newer badge.
