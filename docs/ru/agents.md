# Агенты

В CLI есть реестр агентов. На macOS ARM64 живые проверки запустили закреплённые образы shell и Gemini; shell fixture успешно выполнился, а команда версии Gemini завершилась без обращения к провайдеру. Это не подтверждает вход в аккаунт провайдера, полноценную сессию каждого агента или платформенную parity.

## Статусы реестра

| Статус | Значение |
|---|---|
| Available | CLI знает закреплённый образ или команду; для указанного сценария есть evidence на выпущенном теге |
| Preview | Образ или команда зарегистрированы, но сквозной сценарий или авторизация не завершены |
| Unsupported | CLI отклоняет агента: контракт образа или интеграции пока отсутствует |

В реестре feature-ветки P-05 есть:

| Агент | Статус | Примечание |
|---|---|---|
| `claude`, `codex`, `copilot`, `cursor`, `devin`, `docker-agent`, `droid`, `gemini`, `kiro`, `opencode`, `shell` | Preview | Запускаются с закреплёнными Docker-образами; авторизация провайдера, nested Docker workload и полный VM lifecycle ещё не проверены |
| `kimi` | Available в существующем реестре | Расширение Rheic с предыдущим evidence на выпущенном теге |
| `dsh` | Preview extension | Агент Rheic, отсутствующий во встроенном списке Docker |
| `cline` | Unsupported | Не входит во встроенный список Docker |

Встроенный список для зафиксированной базы `sbx v0.50.1`: Claude, Codex,
Copilot, Cursor, Devin, Docker Agent, Droid, Gemini, Kiro, OpenCode и Shell.
Ветка P-05 позволяет запускать все эти имена через `rsbx run`; встроенные
агенты Docker остаются preview до проверки авторизации и собственного VM-сценария.
`rsbx agents list` показывает образ, команду запуска и заметки по авторизации.

В той же ветке `rsbx run claude` автоматически выбирает сохранённый host secret
`anthropic` и передаёт гостю только ссылку `${proxy:anthropic}`. Реальный ключ
остаётся в host vault. Это пока проверено тестами CLI, но не живым Claude VM
сценарием. OAuth-вход Claude внутри гостя не включён: он может сохранить
учётные данные в sandbox и требует отдельного безопасного host-side адаптера.

Состав реестра меняется вместе с модулем CLI. Проверьте `rsbx run --help` и `internal/agent/registry.yaml` в используемой версии.

## Формат команд CLI

Формат команды для интерактивной оболочки:

```sh
rsbx run shell .
```

CLI также принимает команду запуска без подключения терминала:

```sh
rsbx run --detach --name review kimi .
rsbx ls
rsbx exec -it review /bin/sh
```

Аргументы агента передаются после `--`:

```sh
rsbx run cursor . -- -p "review this change"
rsbx run kiro . -- login --use-device-flow
```

Если первый аргумент после `--` начинается с флага, Rheic сохраняет стандартные
флаги агента и добавляет переданный аргумент. Обычная команда или подкоманда
заменяет значения по умолчанию, как в Docker.

Грамматика CLI определяет `run` как создание или повторное использование sandbox, запуск и подключение. Runtime/daemon содержат exec/PTY реализацию; ограниченные VM lifecycle и exec-проверки прошли на macOS ARM64, но общий agent lifecycle и TTY пока не прошли platform acceptance. Текущий каталог — workspace по умолчанию. `--detach` завершает команду после старта; `create` создаёт sandbox без подключения. Проверки подтвердили запуск образов shell и Gemini, но все встроенные агенты Docker остаются preview до per-agent проверки авторизации и lifecycle. `--image` задаёт пользовательский образ; эти примеры не подтверждают рабочую guest-сессию для каждого агента.

## Авторизация

Вход к AI-провайдеру отделён от входа в Docker account. Codex использует
сохранённый `openai` secret через proxy или host OAuth, если API key не задан.
Claude использует сохранённый `anthropic` secret через proxy. Gemini использует
сохранённый API key `google` через фиксированный host proxy; Google account OAuth
и Vertex credentials не брокируются. OpenCode и Docker Agent автоматически
получают proxy-ссылки для сохранённых `openai`, `anthropic`, `google`, `groq`,
`mistral`, `openrouter` и `xai` ключей. Их настройка и live-авторизация ещё не
проверены. Для Copilot настроены proxy-маршруты по сохранённому `github` token,
для Cursor — по API key `cursor`, для Droid — по Factory API key `droid`.
Их OAuth-вход и live-запросы не проверялись. Добавить API keys можно командами
`rsbx secret set github`, `rsbx secret set cursor` и `rsbx secret set droid`.
Claude/Codex/Gemini и multi-provider ключи тоже ещё не проверялись в live VM.
Для Devin нужен host credential relay. Kiro по документации сохраняет device-flow
credentials внутри VM; правило Rheic требует хранить их только на host, поэтому
это остаётся parity blocker. Не
считайте, что `rsbx login` авторизует AI-агента: команда выполняет вход в Docker.
Текущие credential-сценарии описаны в разделе [Credentials и вход](credentials.md).

## Текущие ограничения

Ни один встроенный агент Docker не прошёл полный набор проверок авторизации и lifecycle, необходимый для статуса available. Запись в реестре и две проверки запуска образов не подтверждают поддержку платформы или security qualification. Перед выбором агента прочитайте [системные требования](requirements.md) и [руководство по безопасности](security.md).
