# Kits

Kit — локальный YAML-файл или каталог Docker v2 с `spec.yaml` (либо `spec.yml`), который объединяет агента или образ с конфигурацией sandbox. Сейчас kits — неподписанные локальные файлы. Считайте их исполняемой конфигурацией и проверяйте содержимое перед запуском.

## Проверка и запуск

```sh
rsbx kit inspect ./kit.yaml
rsbx kit ls
rsbx run --kit ./kit.yaml .
```

Доступные команды и поля зависят от версии CLI. Для установленной сборки ориентируйтесь на registry CLI и `rsbx --help`.

## Минимальный пример

```yaml
apiVersion: rheic.dev/v1alpha1
kind: Kit
metadata:
  name: review
spec:
  agent: shell
  policy:
    profile: deny-all
  mounts:
    - path: /reference
      read_only: true
  workspace:
    seed: https://github.com/example/project.git
```

Нужно указать `agent` или `image`. Поддерживаются профили `deny-all`, `balanced` и `sbx-compat`. Seed workspace клонируется в локальный cache один раз; lifecycle hooks для этого пути отключены. Используйте URL репозитория только после проверки источника и получившейся workspace.

## Текущие ограничения

- Парсер принимает строгий subset Docker Kits v2 `spec.yaml` sandbox и вложенных OAuth-полей. Пока запускается только встроенное объявление `openai` с фиксированным маршрутом daemon на `api.openai.com`. Generic OAuth daemon отклоняет при создании, пока не реализованы TLS interception на хосте, маршрутизация сервисов, запись credential-файлов в guest и очистка по жизненному циклу.
- Встроенный `rsbx run codex` сначала проверяет сохранённый API key, затем использует OpenAI OAuth на хосте. Приём схемы kit не означает parity runtime с Docker; удалённые kits, mixins и проверка подписей не реализованы.
- Kits — локальный YAML; распространение через OCI и проверка подписей не реализованы.
- Непустой MCP allowlist отклоняется, а не игнорируется.
- Kit не делает preview-агентов или заблокированные функции runtime готовыми к production.
- Перед запуском проверьте итоговую конфигурацию, пути mounts и сетевую политику.
