# CLI reference

The canonical user-facing executable is `rsbx`. Most commands accept `--socket PATH`; `SANDBOXES_SOCKET` can set the same default for a shell session.

> **Pre-alpha implementation note:** this page documents the CLI interface. Runtime and daemon include exec/PTY paths, and a limited VM-backed lifecycle passed live acceptance on macOS ARM64. Full interactive agent workflows and platform parity remain unverified. The [quick start](quickstart.md) intentionally demonstrates state-only mode; see [requirements](requirements.md) before configuring a VM backend.

## Create and run

```sh
rsbx run shell .
rsbx run --detach --name api --cpus 2 --memory 2g shell .
rsbx create --name api shell . /path/to/docs:ro
```

The CLI grammar defines `run` as create-or-reuse, start, and attach. Runtime and daemon include exec/PTY implementations, but the complete agent lifecycle has not passed shared platform acceptance. The current directory is the default workspace. `--detach` returns after startup; `create` creates without attaching. The CLI README describes only the shell adapter as implemented; other agent support is marked preview or unsupported.

## Inspect and control

```sh
rsbx ls
rsbx get api
rsbx start api
rsbx stop api
rsbx exec -it api /bin/sh
rsbx rm --force api
```

`ls` lists sandboxes; `get` shows a sandbox's details; `ports` reports published ports. `start`, `stop`, and `rm` accept multiple sandbox names. Destructive removal prompts for confirmation unless `--force` is supplied. `rm --all` removes every sandbox, so inspect the list first.

## Workspaces and files

```sh
rsbx run shell . /path/to/reference:ro
rsbx cp ./input.txt api:/tmp/input.txt
rsbx cp api:/tmp/output.txt ./output.txt
```

A workspace ending in `:ro` is mounted read-only. `cp` transfers regular files and directory trees. Guest paths must be absolute. The implementation rejects traversal and unsupported file types; source symlinks are rejected unless link following is explicitly enabled.

Workspace paths are host paths. Only add directories the agent needs. A writable workspace lets guest processes change those host files; `:ro` prevents writes through that mount but does not hide files inside the guest image.

## Environment and secrets

```sh
rsbx exec -e MODE=debug api env
rsbx secret set openai --sandbox api
rsbx secret ls
rsbx secret rm openai --sandbox api
```

Use `-e KEY=VALUE` for a session override. Values passed on a command line may be visible in host process arguments; do not pass secrets that way. `rsbx env plan [PATH...]` provides a static, read-only preview. Without paths it reads `sbxenv.yaml` from the current directory and merges optional `~/.sbxenv.yaml` defaults first; explicit file or directory paths merge in order and skip user defaults. YAML values support `${{ env.projectDir }}` and `${{ env.fileDir }}`. The preview lists declared ports but does not bind them. Declared `args` are checked with `--env-arg` and `--env-args-file`; values are redacted in the preview. Combined argument input is limited to 8 MiB and 20,000 values. Direct `--env-arg` values can appear in process listings, so use an argument file for sensitive values. Declared `${{ env.args.NAME }}` references are expanded once in YAML values; kit arguments are not implemented. `--name NAME` overrides the previewed sandbox name. Environment values are masked in previews. `rsbx env create [PATH...]` creates a local sandbox from the supported subset: agent, name, workspace mounts, ports, environment variables, and CPU/memory options. It asks for approval in a terminal; use `--force` for a one-command approval in non-interactive scripts. `rsbx env run` creates a missing sandbox or attaches to a matching existing one; `--detach` starts without attaching. `rsbx env exec` runs a command in a matching existing sandbox and starts it if stopped. `rsbx env rm` removes only the sandbox matching the declared name, agent, and workspaces. Kits, credential bindings, host commands, and MCP declarations remain unsupported and fail closed. Environment lifecycle execution has command and unit-test coverage; full cross-platform Docker parity and live runtime acceptance remain open. `rsbx run --env` applies values to one run/session and is not an environment-file workflow. `rsbx secret` stores provider values in the host credential vault and keeps them out of SQLite and logs. Read the [security model](security.md) before enabling secret proxy features. Docker account sign-in is separate and is described in [Docker and Rheic](docker.md).

On upgrade, existing settings are read from the previous `~/.config/klorq/settings.toml` path when no Rheic settings file exists. Existing credentials remain readable from the previous OS keychain namespace; saving a credential under the new namespace removes its old entry.

## Network and ports

```sh
rsbx run --publish 127.0.0.1:8080:3000 shell .
rsbx ports api
rsbx policy ls api
```

The default egress policy is deny. Explicit policy supports IPv4 CIDR and domain targets where the configured gateway supports them. Port publishing is limited to host loopback addresses; public host bindings are rejected. A successful `--publish` setup does not grant the guest outbound access. Configure only the egress destinations the workload needs.

## Docker

The CLI accepts `--docker` for an opt-in guest Docker profile. It can start `dockerd`, but nested `docker run/load/build` and Compose remain blocked by guest `unshare` restrictions in the current runtime. This does not mean the VM fails to start. `rsbx login` stores Docker account authorization on the host; it does not forward registry credentials into the guest. Read the [Docker guide](docker.md) for the current status and history.

## Get exact options

Use the binary's built-in help for the version you installed:

```sh
rsbx --help
rsbx run --help
rsbx policy --help
```

The CLI is pre-alpha, so flags and behavior can change between releases. Check installed-binary help before relying on a command.
