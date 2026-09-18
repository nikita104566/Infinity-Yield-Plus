Apply before merge:

```
curl -sL https://raw.githubusercontent.com/nikita104566/Infinity-Yield-Plus/main/source -o source
patch -p1 < SOURCE_7.63_hist.diff
```

Do not replace `source` with a stub. After patch, `currentVersion` in source is 7.63.
