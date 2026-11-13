# Credentials и вход

В Rheic отдельно устроены авторизация аккаунта Docker, credentials реестров и secrets для сервисов агентов. Наличие записи не означает, что она доступна внутри любой guest-среды.

## Аккаунт Docker

```sh
rsbx login
rsbx logout
```

`login` использует device authorization Docker Hub и сохраняет данные аккаунта в хранилище credentials хоста. Для headless-сценария `rsbx login --username USER --password-stdin` читает personal access token Docker Hub из стандартного ввода. Не помещайте токен в историю shell или аргументы процесса.

Перед удалением credentials команда `logout` может остановить запущенные локальные sandbox. Она спрашивает подтверждение; `--force` пропускает только этот вопрос. Credentials реестров, добавленные отдельно через `rsbx secret set --registry`, сохраняются. Вход в аккаунт Docker пока не передаёт credentials в guest для скачивания образов; см. [Docker](docker.md).

## Secrets сервисов

```sh
rsbx secret set openai --sandbox agent-task
rsbx secret ls
rsbx secret rm openai --sandbox agent-task
```

Интерактивная команда `set` запрашивает значение без отображения. При удалении из терминала CLI просит подтверждение; для автоматизации передавайте `--force`. Secrets хранятся в системном хранилище credentials хоста; SQLite содержит только несекретные метаданные. Secret может быть глобальным или ограниченным sandbox. Ссылки `${secret:service}` отклоняются: процессы в гостевой системе могут прочитать переменные окружения. Переведите скрипты на поддерживаемый host proxy route. Proxy хранит provider credentials на host и добавляет их только к запросам на фиксированные provider hosts. Поддержка нескольких service secrets на sandbox слита в daemon `main` через PR #41, но отсутствует в опубликованном теге v0.0.32. Дополнительные provider routes агентов проходят review в PR #45. Для P-04 остаются fault matrix и независимый security review. Не выводите раскрытые значения в логи.

Если не указывать SERVICE в `secret set`, появится список поддерживаемых providers. Выберите нужный стрелками и нажмите Enter; q/Escape/Ctrl-C отменяет команду.

При установке service secret CLI использует атомарный create-only RPC и отказывается заменять существующее значение. Для перезаписи укажите `--force` или `-f`. Старый daemon без этого RPC завершит команду ошибкой, не перейдя к небезопасной перезаписи.

Для совместимости с Docker `sbx` команда `secret set` принимает `-t` как сокращение `--token`.

Команда `secret rm` также принимает алиасы `remove`, `delete` и `unset`. Без имени открывается терминальный выбор известной daemon записи service secret, registry credential или Docker/OpenAI account token: стрелки выбирают, Enter удаляет, `q`, Escape или Ctrl-C отменяет. Для удаления по имени в скриптах указывайте `--force`. `secret rm --all` после успешного чтения инвентаря удаляет известные записи во всех scope. Если удаление прервётся ошибкой, часть записей уже может быть удалена. Хранилище custom secrets пока не реализовано и не входит в эту команду; удаление custom/placeholder secrets остаётся пробелом parity.

Для `secret ls` доступен алиас `list`, а также фильтры Docker `--global`/`-g`, `--sandbox`, `--service` и `--quiet`/`-q`.

Как и в Docker `sbx`, команда `secret rm openai` удаляет и глобальный OpenAI API key, и host OAuth-сессию. Укажите `--oauth`, чтобы удалить только OAuth-сессию; команда с `--sandbox` удаляет только API key выбранного sandbox.

`secret import` читает поддерживаемые переменные окружения провайдеров. Команда спрашивает подтверждение перед импортом или перезаписью каждого значения с ответом по умолчанию «да», если не указан `--all` или `--force`; Enter подтверждает, EOF отменяет. `--all` импортирует новые записи и пропускает существующие; `--force` импортирует без prompt и перезаписывает существующие значения. Команда показывает количество импортированных и пропущенных записей. Если список credentials прочитать не удалось, импорт завершается без записи. Новые записи без `--force` daemon создаёт атомарно. Если сохранена OpenAI OAuth-сессия, её API key из переменной окружения пропускается, так как OAuth имеет приоритет; недоступность статуса OAuth также останавливает импорт до любых записей. Как и Docker `sbx`, `--dry-run` ничего не записывает и показывает только последние четыре символа найденного значения. `secret set-custom` пока завершается с отказом: хранение custom placeholders и подстановка через proxy не реализованы.

Для скриптов используйте `--token` только с источником, который не раскрывает его в аргументах процесса; предпочтительны интерактивный ввод или защищённый поток stdin, если он поддерживается. `secret import --dry-run` показывает план миграции credentials хоста, а `secret import --all` импортирует подходящие записи.

## Credentials реестров

```sh
rsbx secret set --registry ghcr.io --username USER --password-stdin
rsbx secret ls
rsbx secret rm --registry ghcr.io --force
```

Пароль читается из стандартного ввода. Если scope не указан, `secret rm --registry` удаляет host-only и all-sandboxes записи. Используйте `--all-sandboxes`, чтобы удалить только общую запись, или `--sandbox NAME` для одного sandbox. В терминале удаление просит подтверждение; в скриптах передавайте `--force`. Credentials реестра хранятся на хосте. В текущем checkout есть экспериментальный Docker Hub broker для pull и push из guest: TLS завершается на host, guest получает scoped token, а реальный registry bearer остаётся на host. Поддерживается только Docker Hub. Есть synthetic contract-тесты, но нет live-приёмки registry в VM и runtime-сравнения с `sbx`; функция не выпущена и не прошла production-квалификацию. Host-only credentials в запросах guest не используются. Не делитесь sandbox с задачей, которой нельзя использовать scoped credential.

## Что пока не подключено

`rsbx login` — это вход в аккаунт Docker. Чтобы сохранить OpenAI/Codex OAuth на хосте, выполните `rsbx secret set openai --oauth`; токены остаются в хранилище учётных данных хоста. Команда `rsbx secret rm openai --oauth` удаляет их и пытается отозвать refresh token у провайдера. В терминале удаление просит подтверждение; для скриптов используйте `--force`. Для клиента, который принимает bearer token через `OPENAI_API_KEY`, используйте `rsbx run --env 'OPENAI_API_KEY=${oauth:openai}' ...`. В гостевую систему попадает только placeholder; host proxy обновляет токен и подставляет его в запросы к `api.openai.com`. Kit может запросить этот же фиксированный маршрут через `spec.credentials[].oauth.resourceHosts`; `rsbx run --kit FILE` выполнит вход на хосте, если credential ещё не сохранён. Эта ограниченная схема не настраивает token endpoint, не создаёт OAuth-файлы и не разрешает другие resource hosts. `rsbx run codex` использует такой же порядок входа на хосте: при наличии сохранённого OpenAI API key запросы идут через host proxy; иначе CLI проверяет OAuth-сессию OpenAI, при необходимости запускает вход на хосте и передаёт в sandbox только ссылку OAuth. Сейчас это работает для Codex-запросов через `OPENAI_API_KEY`; relay для OAuth-входа Claude из sandbox, запись provider credential-файлов и другие OAuth-провайдеры ещё не реализованы.
