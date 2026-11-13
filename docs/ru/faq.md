# Частые вопросы

Rheic находится в pre-alpha. Здесь отдельно описано, что заявляет документация Docker Sandboxes и что реализовано и проверено в Rheic.

## В Docker Sandboxes действительно используются полноценные microVM?

В документации Docker указано, что для каждого агента запускается отдельная лёгкая microVM со своим Linux kernel и Docker Engine внутри VM. Основная граница изоляции — гипервизор; доступ к workspace и другим ресурсам хоста появляется только при явной передаче. Подробнее — в разделах Docker про [слои изоляции](https://docs.docker.com/ai/sandboxes/security/isolation/) и [архитектуру](https://docs.docker.com/ai/sandboxes/architecture/). Термин «microVM» описывает границу виртуализации, но не означает, что любая конфигурация и интеграция полностью лишена рисков.

Rheic тоже рассчитан на границу microVM, но пока не заявляет паритет с Docker или полную квалификацию безопасности. Ограниченная проверка VM lifecycle прошла на macOS ARM64. Linux KVM не квалифицирован, поддержка Windows WHP не завершена, независимый security review остаётся открытым. См. [архитектуру Rheic](architecture.md), [требования платформ](requirements.md) и [модель безопасности](security.md).

## Быстрый старт запускает VM?

Нет. Он запускает daemon в state-only режиме, чтобы проверить локальную control plane. Для VM нужны дополнительные компоненты платформы из раздела [системных требований](requirements.md).

## Можно ли запустить coding-агента внутри Rheic sandbox?

CLI и runtime содержат agent и exec-пути; ограниченная проверка VM lifecycle прошла на macOS ARM64. Полная интерактивная работа каждого агента на каждой платформе ещё не прошла acceptance. См. [руководство по агентам](agents.md) и [статус платформ](requirements.md).

## Успешная команда подтверждает изоляцию?

Нет. Успешный ответ CLI подтверждает только результат этой команды. Для проверки VM-изоляции нужны отдельные runtime- и security-evidence. См. [модель безопасности](security.md).

## Готов ли Docker Engine внутри guest к запуску workloads?

Опциональный Docker daemon внутри guest запускается, но вложенные `docker run`, `docker load`, `docker build` и Compose блокируются ограничениями guest `unshare` в текущем runtime. Это не тот Docker Engine workflow, который описан для Docker Sandboxes. См. [Docker и Rheic](docker.md).

## Есть ли у guest доступ к файлам хоста или его Docker daemon?

Guest получает доступ только к явно подключённым workspace. Процессы внутри guest могут менять файлы подключённого workspace, если он доступен на запись, поэтому подключайте только нужные для задачи каталоги. Docker socket хоста не подключается. См. [workspace и файлы](workspaces.md) и [модель безопасности](security.md).
