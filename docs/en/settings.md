# Settings

The CLI reads settings from `~/.config/rheic/settings.toml` by default. Set `RHEIC_SETTINGS_FILE` to use another file. Prefer `rsbx settings set` so the CLI validates and writes supported keys. The daemon accepts an explicit path with `--settings`; restart it after changing daemon-owned DNS or gateway settings.

`rsbx settings ls` lists the full pinned Docker Sandboxes settings matrix (49 keys — proxy and no_proxy variants, kit sources and signature policy, MCP, SSH, model providers, daemon log rotation, diagnostics, platform images, and more) plus the Rheic extension keys. Every key reports its evaluated value, source (`default` or `file`), built-in default, type, restart requirement, and description. Unknown keys are rejected; values are validated against the key's type (`bool`, `int`, `string`, or `json`).

Keys the local runtime consumes today:

```sh
rsbx settings set dns.upstream 192.0.2.53:53
rsbx settings set policy.profile deny-all
rsbx settings set defaults.cpus 2
rsbx settings set defaults.memory_mib 2048
rsbx settings set sandbox.disk.dockerVolume 10g
```

Other catalogued keys are stored as validated overrides and reported by `settings ls`; they take effect as the corresponding runtime support lands. Use `rsbx settings get KEY --json` for the full record and `rsbx settings unset KEY` to remove an override.

The DNS address above is an example from a documentation-only IP range; replace it with a resolver reachable through your configured gateway. The default policy is deny-all. Settings files contain configuration, not secret values; store credentials with `rsbx secret`. The daemon's flat file keys are `dns_upstream`, `default_policy_profile`, `default_cpus`, `default_memory_mib`, and `docker_volume_size`; they are not TOML tables.

On upgrade, the CLI can read the legacy `~/.config/klorq/settings.toml` when no Rheic settings file exists. Existing credentials may also be migrated from the legacy OS keychain namespace. See [Credentials](credentials.md).

For daemon paths and runtime flags, see [Quick start](quickstart.md) and the module runtime documentation. Flags vary with build and platform; use `sandboxesd --help` from the installed binary.
