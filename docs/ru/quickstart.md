# Быстрый старт

Соберём локальные CLI и daemon и запустим control plane в state-only режиме. Rheic находится в pre-alpha. На macOS ARM64 прошла ограниченная live acceptance CLI lifecycle с owned daemon и VM. Она не подтверждает полную интерактивную работу всех агентов. Команды ниже намеренно не настраивают VM-runtime.

## Требования

- macOS на Apple silicon для ограниченно проверенного нативного VM-пути.
- Go 1.27 и checkout-ы модулей Rheic для сборки из исходников.
- `containerd`, `ctr`, `libkrun`, patched nerdbox shim и guest image, `mkfs.erofs`, policy-enabled сборка `gvproxy`.
- Локальные бинарники CLI и daemon, собранные с совместимыми tagged-версиями модулей.

Development bundle собирает CLI и daemon, но не устанавливает системную службу и не готовит VM-артефакты. Ограниченная live acceptance на macOS ARM64 подтвердила конкретный VM-backed service-secret lifecycle, но не полную agent/TTY parity и не release readiness. Руководство не устанавливает приложение и не готовит машину для production. Runtime требует закреплённых артефактов и явных путей; незакреплённые зависимости автоматически не загружаются.

## Запустите daemon

Для разработки в режиме хранения состояния:

```sh
sandboxesd \
  --state "$HOME/.sandboxes" \
  --socket "$HOME/.sandboxes/sandboxesd.sock"
```

Daemon владеет каталогом состояния и локальным сокетом. Он не заменяет уже существующий путь сокета. Эта команда предназначена для разработки с хранением состояния и сама по себе не запускает VM-backend. Для VM-backend укажите явные пути к containerd, gateway, image и guest helper согласно документации модулей runtime и daemon. Не используйте сокет или каталог состояния другой установки.

В другом терминале укажите тот же сокет:

```sh
rsbx --socket "$HOME/.sandboxes/sandboxesd.sock" ls
```

## Проверьте локальную control plane

```sh
rsbx --socket "$HOME/.sandboxes/sandboxesd.sock" ls
rsbx --socket "$HOME/.sandboxes/sandboxesd.sock" diagnose
```

Эти команды проверяют связь CLI с daemon и состояние control plane; они не загружают guest. Runtime и daemon содержат exec/PTY пути, а отдельная macOS live acceptance прошла, но этот quick start не настраивает VM backend и не подтверждает полную agent-сессию или platform parity. См. [требования](requirements.md), [архитектуру](architecture.md) и [модель безопасности](security.md).

## Следующие шаги

Перед сборкой runtime прочитайте [системные требования](requirements.md). В [справочнике CLI](cli.md) описан интерфейс команд, отдельно доступны [workspace](workspaces.md), [сеть](networking.md) и [credentials](credentials.md). [Руководство Docker](docker.md) объясняет различие входа в аккаунт и Docker в guest. Перед подключением проекта или сохранением credentials изучите [модель безопасности](security.md).
