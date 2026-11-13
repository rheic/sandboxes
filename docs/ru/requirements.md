# Системные требования

Rheic находится в стадии pre-alpha и пока не имеет универсального установщика. Проверенный нативный VM-путь рассчитан на macOS с Apple silicon. Перед запуском VM соберите модули и подготовьте runtime-артефакты.

## Поддерживаемая среда разработки

| Host-система | Текущий статус |
|---|---|
| macOS с Apple silicon | Нативный VM-путь проверялся локально; квалификация релиза не завершена |
| Linux с KVM | Ведётся разработка; это руководство не заявляет готовую к использованию платформу |
| Windows с WHP | Интеграция runtime и guest-сценарий не завершены; для общего использования недоступны |

Актуальные результаты и блокеры платформ смотрите в плане проекта.

## Инструменты сборки

Для сборки из исходников нужны Go 1.27 и tagged-репозитории модулей Rheic. Каждый модуль — отдельный Go-модуль; `modules/go.work` предназначен для локальной разработки. Релизные сборки используют tagged-версии без подмены workspace.

Соберите CLI и daemon из каталогов модулей:

```sh
cd modules/sandboxes-cli
mkdir -p ./bin
go build -o ./bin/rsbx ./cmd/rsbx

cd ../sandboxes-daemon
mkdir -p ./bin
go build -o ./bin/sandboxesd ./cmd/sandboxesd
```

Эти команды только собирают бинарники. Они не устанавливают системную службу, не настраивают keychain и не готовят VM-runtime.

## Компоненты VM-runtime

Для нативного VM-backend нужны закреплённые компоненты из `modules/sandboxes-runtime/build/manifest.yaml`:

- containerd и `ctr`
- libkrun и nerdbox shim
- соответствующие guest kernel и EROFS root filesystem
- policy-enabled сборка `gvproxy`, если нужен сетевой доступ
- `mkfs.erofs` и `mkfs.ext4` для образов и хранилища runtime

Процесс containerd должен находить patched nerdbox shim раньше штатного shim через `PATH`. Собирайте точные версии по инструкции runtime. Не подменяйте их произвольными системными бинарниками QEMU, shim или gateway.

## Настройка runtime

Если `--containerd` не задан, daemon работает в state-only режиме. Этот режим не запускает VM. VM-конфигурации нужны явные пути к сокету containerd, совместимому runtime, образу и guest-артефактам. Сеть отключена, пока daemon не настроен с совместимым policy gateway.

В [быстром старте](quickstart.md) объяснена разница между state-only и VM-режимами. В [архитектуре](architecture.md) описаны границы компонентов.
