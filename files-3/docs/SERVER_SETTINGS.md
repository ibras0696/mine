# Настройки сервера

## Основные параметры
| Переменная | Значение по умолчанию | Описание |
|------------|-----------------------|----------|
| `SERVER_NAME` | MirageCraft | имя сервера в списке клиентов |
| `VERSION` / `FORGE_VERSION` | 1.20.1 / 47.3.0 | версия Minecraft и Forge |
| `MEMORY` | 6G | сколько RAM отдаём JVM |
| `PUBLISHED_PORT` | 25565 | внешний порт Docker |
| `TIMEZONE` | Europe/Moscow | временная зона контейнера |

## Мир и генерация
| Переменная | Что делает |
|------------|------------|
| `LEVEL` | имя каталога мира в `data/` |
| `LEVEL_TYPE` | тип генерации (`default`, `flat`, `large_biomes`, `amplified`) |
| `SEED` | сид мира, оставь пустым для случайного |
| `ALLOW_NETHER` | разрешить портал в ад |

## Геймплей
| Переменная | Что меняет |
|------------|------------|
| `MODE` | `survival`, `creative`, `adventure`, `spectator` |
| `DIFFICULTY` | `peaceful`, `easy`, `normal`, `hard` |
| `MAX_PLAYERS` | лимит игроков |
| `VIEW_DISTANCE` / `SIMULATION_DISTANCE` | сколько чанков подгружается/симулируется |
| `ALLOW_FLIGHT` | включить полёты с модами или Elytra |
| `ALLOW_CHEATS` | включает команды типа `/gamemode` без OP |
| `FORCE_GAMEMODE` | принудительно выставляет режим всем игрокам |
| `ENABLE_COMMAND_BLOCK` | активирует блоки команд |
| `SPAWN_PROTECTION` | радиус защиты вокруг spawn |

## Безопасность
| Переменная | Что делает |
|------------|------------|
| `ONLINE_MODE` | проверка лицензий Mojang (`TRUE`/`FALSE`) |
| `ENABLE_WHITELIST` | включает whitelist |
| `ENFORCE_WHITELIST` | не пускает никого вне whitelist |
| `WHITELIST` | список ников через запятую |
| `OPS` | игроки с правами оператора (через запятую) |
| `CREATE_CONSOLE_IN_PIPE` | включает именованный pipe для `mc-send-to-console` |
| `ENABLE_RCON`, `RCON_PASSWORD` | доступ по RCON (по умолчанию выключен) |

## Полезные gamerules
Выполняются через `scripts/mc-console.sh`.

| Команда | Назначение |
|---------|------------|
| `gamerule keepInventory true` | игроки не теряют вещи после смерти |
| `gamerule doDaylightCycle false` | фиксированное время суток |
| `gamerule doWeatherCycle false` | отключить смену погоды |
| `gamerule mobGriefing false` | криперам запрещено ломать блоки |
| `time set day` / `night` | смена времени |

## Настройка производительности
1. Следи за занятым объёмом памяти (`MEMORY`). Если `docker stats` показывает >90%, увеличь значение на 1–2 ГБ.
2. Уменьши `VIEW_DISTANCE` и `SIMULATION_DISTANCE`, если задержки > 100 мс.
3. Для больших миров включи `USE_AIKAR_FLAGS=true` в `.env` (жёсткая оптимизация памяти JVM).
4. Если игроков больше 10, подними лимиты CPU/RAM на уровне VPS.

Эти параметры покрывают большинство сценариев. Остальные необязательные переменные можно взять из официальной документации образа.
