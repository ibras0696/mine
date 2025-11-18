# Администрирование сервера

## Права оператора (OP)
1. Убедись, что сервер запущен (`make up`).
2. Выполни команду:
   ```bash
   scripts/mc-console.sh "op НикИгрока"
   ```
3. Чтобы снять права, отправь `"deop Ник"`.
4. Альтернатива — прописать список в `ops.json` внутри `data/` и перезапустить сервер.

## Работа с whitelist
- Включить белый список: в `.env` установи `ENABLE_WHITELIST=true`, `ENFORCE_WHITELIST=true` и перечисли игроков в `WHITELIST=ник1,ник2`.
- Добавить/удалить игрока на лету:
  ```bash
  scripts/mc-console.sh "whitelist add Ник"
  scripts/mc-console.sh "whitelist remove Ник"
  scripts/mc-console.sh "whitelist reload"
  ```

## Команды через консоль
- `scripts/mc-console.sh "time set day"`
- `scripts/mc-console.sh "gamerule keepInventory true"`
- `scripts/mc-console.sh "tp Ник1 Ник2"`

## Обновление сервера
1. Останови сервер: `make down`.
2. Обнови образ: `make pull` (или `make build`, если менялся Dockerfile).
3. Проверь список модов и версию Forge (`FORGE_VERSION` в `.env`).
4. Подними стек снова: `make up`.

## Очистка после краша
1. Запусти `docker compose logs mc` и найди последнюю ошибку.
2. Если мир повреждён, откати его из резервной копии (`cp -r backup_folder data/my_world`).
3. Удали временные/битые моды из `data/mods`.
4. Запусти `make up` и убедись через `make logs`, что Forge дошёл до строки `Done (X.Xs)!`.

## Типичные проблемы
| Симптом | Причина | Решение |
|---------|---------|---------|
| Контейнер постоянно рестартует | Ошибка модов или нехватка RAM | Проверь `data/logs/latest.log`, увеличь `MEMORY` в `.env` |
| Игрок не может подключиться | Неверный `ONLINE_MODE` или порт | Проверь `.env`, открой порт в firewall, перезапусти Docker |
| Команда `mc-console` висит | Не включён `CREATE_CONSOLE_IN_PIPE` | Включи в `.env` и перезапусти сервер |
| Опции в игре не применяются | Изменён `.env`, но сервер не перезапускали | Выполни `make down && make up` |

## Полезные ссылки
- `docs/SERVER_SETTINGS.md` — таблица настроек Forge/Vanilla.
- `docs/vpn/RADMIN.md` — подключение друзей через VPN.
- Официальная документация образа: https://docker-minecraft-server.readthedocs.io/
