# Архитектура

Rheic — локальная control plane для агентских sandbox-сессий. У компонентов разные обязанности; собирать их нужно из совместимых версий модулей.

```text
rsbx CLI / терминальная панель
          │ локальный API через sandboxes-go-sdk
          ▼
      sandboxesd ───── хранилище credentials хоста
          │
          ├── runtime adapter ── microVM ── guest-агент
          └── network gateway ── политика сети guest
```

## Control plane

CLI вызывает локальный daemon через официальный Go SDK и публичный API-модуль. Daemon владеет метаданными sandbox и координирует runtime, workspace, политику и операции credentials. В state-only режиме он может управлять метаданными, но не запускает VM. Для выполнения кода guest нужен настроенный runtime backend.

## Runtime и guest

VM runtime, guest image, shim и вспомогательные бинарники — внешние зависимости с привязкой к версиям. Проверенный native VM путь сейчас нацелен на macOS с Apple silicon. Другие платформы не проверены или не завершены. Агент запускается в guest; mounts workspace определяют доступ к данным проекта на хосте.

## Сетевой периметр

Отдельный gateway при наличии конфигурации применяет поддерживаемую политику исходящего трафика guest. Отсутствие gateway не означает свободный доступ: сетевые функции могут быть недоступны. Принятый CLI синтаксис правила не доказывает, что конкретная сборка gateway его обеспечивает. См. [Сеть и порты](networking.md).

## Credentials

Secrets хранятся в системном хранилище credentials хоста. Daemon раскрывает только поддерживаемые и явно запрошенные сценарии; сохранённые credentials автоматически не передаются в guest. Авторизация аккаунта Docker не равна доступу к Docker Engine из guest. См. [Credentials](credentials.md) и [Docker](docker.md).

## Статус проверки

Rheic находится в pre-alpha. Успешный ответ CLI или state-only daemon не подтверждает изоляцию VM. Поддержка Windows, независимый security review, подпись и проверка upgrade/rollback остаются открытыми блокерами. Текущие ограничения перечислены в разделе [Безопасность](security.md).
