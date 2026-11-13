# Настройки

CLI читает настройки из `~/.config/rheic/settings.toml` по умолчанию. Переменная `RHEIC_SETTINGS_FILE` задаёт другой файл. Используйте `rsbx settings set`, чтобы CLI провалидировал и записал поддерживаемые ключи. Daemon принимает явный путь через `--settings`; перезапускайте его после изменения DNS и gateway-настроек.

`rsbx settings ls` показывает полную закреплённую матрицу настроек Docker Sandboxes (49 ключей — варианты proxy и no_proxy, источники и политика подписей kit, MCP, SSH, model providers, ротация логов daemon, diagnostics, platform images и другие) плюс Rheic-расширения. Каждый ключ показывает действующее значение, источник (`default` или `file`), встроенное значение по умолчанию, тип, необходимость перезапуска и описание. Неизвестные ключи отклоняются; значения валидируются по типу ключа (`bool`, `int`, `string` или `json`).

Ключи, которые локальный runtime использует сегодня:

```sh
rsbx settings set dns.upstream 192.0.2.53:53
rsbx settings set policy.profile deny-all
rsbx settings set defaults.cpus 2
rsbx settings set defaults.memory_mib 2048
rsbx settings set sandbox.disk.dockerVolume 10g
```

Остальные каталожные ключи сохраняются как провалидированные overrides и отображаются в `settings ls`; они начнут действовать по мере появления соответствующей поддержки в runtime. `rsbx settings get KEY --json` показывает полную запись, `rsbx settings unset KEY` удаляет override.

DNS-адрес выше — пример из documentation-only диапазона; замените его на resolver, доступный через ваш gateway. Политика по умолчанию — deny-all. Файлы настроек содержат конфигурацию, не секреты; credentials храните через `rsbx secret`. Плоские ключи файла daemon: `dns_upstream`, `default_policy_profile`, `default_cpus`, `default_memory_mib`, `docker_volume_size`; это не TOML-таблицы.

При обновлении CLI может читать legacy `~/.config/klorq/settings.toml`, если файла Rheic нет. Существующие credentials также могут быть перенесены из legacy namespace OS keychain. См. [Credentials](credentials.md).

Пути daemon и runtime-флаги см. в [Quick start](quickstart.md) и документации модулей runtime. Флаги зависят от сборки и платформы; используйте `sandboxesd --help` из установленного бинарника.
