# Как запускать фиксы по одному

Автоматизация в этом репозитории часто открывает десятки похожих PR и не всегда пишет, что именно изменилось. Здесь — как смотреть, что уже есть на `main`, и как пробовать **один** фикс, а не всю кучу сразу.

## Что сейчас на main

| Слой | Файл | Что это |
| --- | --- | --- |
| Ядро | `source` | Скрипт 7.50 + старые baked-правки истории. Один огромный файл. |
| Фиксы автоматизации | `hotfix756.luau` … `hotfix762.luau` | Команды 7.56–7.62. Подключаются **после** `source`. |
| Загрузчик | `patches.luau` | По умолчанию тянет 756→762 по порядку. |
| Каталог | `hotfix/catalog.json` | Список id, команд и статуса. Это источник правды. |

753 и 754/755 **не** входят в дефолтную цепочку: 753 — заглушка, 754/755 почти перекрыты 756. Их всё ещё можно запустить отдельно.

Полный список с описаниями:

```bash
python3 tools/iyp.py list
python3 tools/iyp.py status
```

`status` ещё группирует открытые PR автоматизации по темам (одно и то же «7.63: имена событий в Studio» может быть в пяти ветках).

## Запустить один hotfix с main

В Roblox-исполнителе, **после** обычного `source`:

```lua
loadstring(game:HttpGet('https://raw.githubusercontent.com/nikita104566/Infinity-Yield-Plus/main/source'))()
loadstring(game:HttpGet('https://raw.githubusercontent.com/nikita104566/Infinity-Yield-Plus/main/hotfix762.luau'))()
```

Или сгенерировать сниппет:

```bash
python3 tools/iyp.py only 762
python3 tools/iyp.py only 756 759
python3 tools/iyp.py skip 761
```

Селектор в самом загрузчике (удобно, если файлов несколько):

```lua
loadstring(game:HttpGet('https://raw.githubusercontent.com/nikita104566/Infinity-Yield-Plus/main/source'))()
_G.IYP_ONLY = 762                 -- один id
-- _G.IYP_ONLY = { 756, 762 }     -- несколько, в этом порядке
-- _G.IYP_SKIP = { 761 }          -- дефолтная цепочка без этих id
loadstring(game:HttpGet('https://raw.githubusercontent.com/nikita104566/Infinity-Yield-Plus/main/patches.luau'))()
```

В консоли исполнителя должно появиться: `[IYP patches] loaded 762 (IYP_ONLY)`.

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

1. Смотри `python3 tools/iyp.py status` — не делай пятый PR про те же имена событий.
2. Один видимый эффект на PR. Правила для агентов: [`AGENTS.md`](../AGENTS.md).
3. Новые команды — в `source` (или правка существующего hotfix), **не** `hotfix763.luau`.
4. Не подменяй `source` заглушкой «скачай main». Если blob не влезает в тул — клади `*.patch`.
5. После правок каталога/загрузчика: `python3 tools/iyp.py check && python3 tools/test_iyp.py`.

Автоматизацию Cursor (`Infinity yiled plus`) лучше держать выключенной, пока открытые дубликаты не разобраны: иначе она снова откроет тот же набор осей.
