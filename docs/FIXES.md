# Как запускать фиксы по одному

Автоматизация в этом репозитории часто открывает десятки похожих PR. Здесь — что уже впечено в `source`, и как пробовать **один** оставшийся фикс, а не всю кучу сразу.

## Что сейчас в ядре (7.63)

| Слой | Файл | Что это |
| --- | --- | --- |
| Ядро | `source` | Скрипт **7.63**. История, lastcommand, диагностика 7.56–7.62, `;studio`, полные имена событий, hint пустого поиска. Один loadstring. |
| Legacy sidecar | `hotfix753.luau` … `hotfix762.luau` | Стубы. Если `currentVersion` ≥ 7.62 — ничего не делают и не даунгрейдят бейдж. |
| Загрузчик | `patches.luau` | Дефолтная очередь **пустая**. `_G.IYP_ONLY` всё ещё может загрузить файл, если человек явно просит. |
| Каталог | `hotfix/catalog.json` | Список id, `status: "baked"`. Это источник правды для CLI. |

Полный список с описаниями:

```bash
python3 tools/iyp.py list
python3 tools/iyp.py status
```

`status` ещё группирует открытые PR автоматизации по темам.

## Запуск

Обычный путь — **один** loadstring:

```lua
loadstring(game:HttpGet('https://raw.githubusercontent.com/nikita104566/Infinity-Yield-Plus/main/source'))()
```

Вторая строка (`patches.luau`) опциональна и по умолчанию ничего не грузит.

Явно подтянуть legacy-stub (почти никогда не нужно):

```bash
python3 tools/iyp.py only 762
```

```lua
loadstring(game:HttpGet('https://raw.githubusercontent.com/nikita104566/Infinity-Yield-Plus/main/source'))()
_G.IYP_ONLY = 762
loadstring(game:HttpGet('https://raw.githubusercontent.com/nikita104566/Infinity-Yield-Plus/main/patches.luau'))()
```

## Запустить фикс из открытого PR автоматизации

Эти ветки правят `source`, а не sidecar-hotfix. Их нужно грузить **с ветки**, не с `main`:

```bash
python3 tools/iyp.py prs          -- темы и дубликаты
python3 tools/iyp.py try 49       -- loadstring на source этой ветки
```

Если `try` пишет `source on this branch is tiny` — ветка сломана (агент не смог залить 1 МБ blob). Не мержить и не запускать. Возьми соседний PR той же темы.

Пример вручную:

```lua
loadstring(game:HttpGet('https://raw.githubusercontent.com/nikita104566/Infinity-Yield-Plus/cursor/iyp-fec1/source'))()
```

## Как дальше улучшать проект, а не копить хаос

1. Смотри `python3 tools/iyp.py status` — не делай пятый PR про те же имена событий (эта ось уже в 7.63).
2. Один видимый эффект на PR. Правила для агентов: [`AGENTS.md`](../AGENTS.md).
3. Новые команды — в `source`, **не** `hotfix763.luau`.
4. Не подменяй `source` заглушкой «скачай main». Если blob не влезает в тул — клади `*.patch`.
5. Не затирай существующие `info` / `creator` / `ping` / `copyuserid`.
6. После правок каталога/загрузчика: `python3 tools/iyp.py check && python3 tools/test_iyp.py`.

Автоматизацию Cursor (`Infinity yiled plus`) лучше держать выключенной, пока открытые дубликаты не разобраны: иначе она снова откроет тот же набор осей.
