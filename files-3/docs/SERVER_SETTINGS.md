# Настройка мира и параметров сервера Minecraft

Документ описывает, как управлять игровыми настройками, мирами и техническими параметрами сервера на основе Docker-образа `itzg/minecraft-server`.

## 1. Быстрый чек-лист перед запуском

1. Задай переменные в `.env`:
   - `MODE`, `DIFFICULTY`, `MAX_PLAYERS`, `VIEW_DISTANCE` и т.д.
   - `LEVEL` — имя папки мира.
2. Убедись, что в `data/<LEVEL>/` лежат файлы `level.dat`, `region/`, `playerdata/`.
3. При необходимости скопируй конфиги/моды.
4. Запусти: `make up`.

## 2. Ключевые переменные `.env`

| Переменная | Назначение | Примечание |
|------------|------------|------------|
| `MEMORY` | Объём RAM для JVM (`4G`, `3072M`) | Убедись, что на VPS хватает RAM/SWAP |
| `LEVEL` | Имя папки мира в `data/` | Должно совпадать с папкой, где лежит `level.dat` |
| `MODE` | Режим игры (`survival`, `creative`, `adventure`, `spectator`) | Меняет тип игры при генерации мира |
| `DIFFICULTY` | Сложность (`peaceful`, `easy`, `normal`, `hard`) | Для уже созданного мира менять через консоль или `server.properties` |
| `FORCE_GAMEMODE` | Принудительно переключает игроков в `MODE` при входе (`true/false`) | Используй `true`, если мир создан в другом режиме |
| `ALLOW_CHEATS` | Разрешить команды оператора (`true/false`) | При `true` операторы могут использовать `/gamemode`, `/give` и т.д. |
| `MAX_PLAYERS` | Лимит игроков | При использовании whitelist можно понижать |
| `VIEW_DISTANCE` | Радиус загрузки чанков | 8–10 оптимально для слабых VPS |
| `SIMULATION_DISTANCE` | Радиус симуляции | Мин. значение снижает нагрузку |
| `ONLINE_MODE` | Проверка лицензии | `TRUE` — только Mojang аккаунты; `FALSE` — оффлайн, включи whitelist |
| `ENABLE_WHITELIST` / `WHITELIST` | Белый список | Список через запятую; требует перезапуска |
| `ENABLE_COMMAND_BLOCK` | Разрешить командные блоки | `true/false` |
| `SPAWN_PROTECTION` | Радиус защиты спавна | 0 отключает |

Полный список переменных см. в [офф. документации](https://github.com/itzg/docker-minecraft-server#environment-variables).

## 3. Работа с мирами

### 3.1 Импорт своего мира

1. Останови сервер: `make stop`.
2. Проверь папку `data/`. Желательно удалить временные файлы нового мира (если успел создаться).
3. Скопируй содержимое сохранения так, чтобы структура была вида:
   ```
   data/my_world/
     level.dat
     region/
     playerdata/
     ...
   ```
4. В `.env` установи `LEVEL=my_world` (или другое название, совпадающее с папкой).
5. Запусти сервер: `make start`.
6. Убедись по логам, что загружается нужный мир (`Preparing level "my_world"`).

### 3.2 Несколько миров

Docker-образ поддерживает указание нового `LEVEL`. Для переключения:
1. Останови сервер.
2. Создай папку `data/<новый_мир>/` с содержимым другого мира.
3. Обнови `.env`: `LEVEL=<новый_мир>`.
4. Запусти сервер.

### 3.3 Резервные копии

- Архивируй папку `data/<LEVEL>/` (например, `tar czf backup-$(date +%F).tar.gz data/my_world`).
- Можно настроить cron на хосте для автоматических бэкапов.
- При восстановлении распакуй архив поверх текущего `data/<LEVEL>/`.

## 4. Настройка `server.properties`

Файл генерируется автоматически и хранится в `data/server.properties`. При ручном редактировании соблюдай синтаксис `ключ=значение`. Полезные параметры:

| Параметр | Описание |
|----------|----------|
| `motd` | Текст приветствия в списке серверов |
| `spawn-protection` | Радиус защиты спавна |
| `enable-command-block` | Разрешение командных блоков |
| `pvp` | PvP-включено/выключено |
| `force-gamemode` | Принудительный режим для входящих игроков |
| `level-type` | Тип генерации (`default`, `flat`, `largeBiomes`, `buffet`) |
| `generator-settings` | JSON/строка для настройки генератора (для `flat`, `buffet`) |
| `seed` | Сид мира (при первой генерации) |

После внесения правок перезапусти сервер (`make restart`).

## 5. Game Rules (произвольные правила)

Используй консоль или RCON для настройки `gamerule`:

```bash
docker compose exec mc mc-send-to-console "gamerule keepInventory true"
```

Часто используемые правила:
- `keepInventory true`
- `doDaylightCycle false`
- `doMobSpawning false`
- `randomTickSpeed 0`

Полный список: [Minecraft Wiki](https://minecraft.fandom.com/wiki/Game_rule).

`gamerule` сохраняются в данных мира, поэтому не требуют перезапуска.

## 6. Настройка whitelist и blacklist

- `whitelist.json`: находится в `data/`. Можно редактировать вручную (`make stop`), затем `make start`.
- Команды:
  ```bash
  docker compose exec mc mc-send-to-console "whitelist add <ник>"
  docker compose exec mc mc-send-to-console "whitelist remove <ник>"
  docker compose exec mc mc-send-to-console "whitelist reload"
  ```
- `banned-players.json`, `banned-ips.json` работают аналогично.

## 7. Производительность

- Уменьши `VIEW_DISTANCE` / `SIMULATION_DISTANCE` при лаге.
- Оптимизируй моды: убери тяжёлые моды или клиентские-only.
- Следи за логами: `make logs` → ищи WARN/ERROR.
- Можно включить Aikar флаги (`USE_AIKAR_FLAGS=true` в `.env`) для JVM-оптимизации.

## 8. Полезные команды администратора

```bash
# Сменить время
mc-send-to-console "time set day"

# Выдать предмет
mc-send-to-console "give <ник> minecraft:diamond 64"

# Телепорт игрока
mc-send-to-console "tp <ник> <ник_2>"

# Выкинуть игрока
mc-send-to-console "kick <ник> Причина"
```

(Команды выполняй через `docker compose exec mc mc-send-to-console "..."`, как и в предыдущих разделах.)

---

Этот документ дополняет `README.md`, `docs/USAGE.md` и `docs/ADMIN.md`. Подстраивай переменные и файлы под свой сценарий, скачивай моды в `data/mods/`, и не забывай делиться бэкапами перед экспериментами.