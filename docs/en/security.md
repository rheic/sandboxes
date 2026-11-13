# Security model

Rheic is designed to keep agent workloads inside isolated microVM sandboxes and to keep host credentials under host control. This is an implementation direction, not a blanket security certification. Rheic remains pre-alpha.

## Trust boundaries

- The local CLI talks to a local daemon over a permission-restricted socket.
- The daemon owns sandbox metadata and coordinates the runtime.
- The VM runtime separates guest workloads from host processes.
- Network access is deny-by-default where the policy gateway is enabled.
- Provider credentials are stored in the native host credential vault. They are not intended to enter sandbox metadata, SQLite, or logs.

## Safe operating practices

- Review workspace contents before sharing a writable workspace with an agent. Use `:ro` for read-only inputs.
- Keep network access denied unless a task needs it. Grant only the destinations and ports required.
- Do not put credentials in command arguments or ordinary environment overrides. Prefer the host credential-vault commands where the feature is supported.
- Treat host hooks, MCP stdio servers, lifecycle commands, and writable mounts as code running with the permissions of their host process. Use them only with explicit approval and a constrained environment.
- Use isolated test directories and uniquely named sandboxes for experiments. Remove only resources created by your own run.

## Current limitations

Rheic does not yet claim parity with Docker Sandboxes or a complete production security boundary. A VM-backed lifecycle has passed limited acceptance on macOS ARM64. The opt-in `--docker` profile can start a Docker daemon inside the guest, but nested workload operations such as `docker run`, `docker load`, `docker build`, and Compose remain blocked in the current runtime by guest `unshare` restrictions. This limitation does not mean the VM itself fails to start. The host Docker socket is not mounted. Platform coverage is incomplete; Windows WHP is not validated on physical Windows hardware. OAuth expiry and refresh lifecycle, host crash and power-loss cleanup, independent security review, and complete network bypass coverage remain open work. Some registry and agent paths are incomplete or fail closed. The service-secret proxy supports one configured service per sandbox and still needs its full fault matrix and independent security review.

Runtime and daemon include exec/PTY paths, and one limited VM-backed lifecycle passed live acceptance on macOS ARM64. This does not qualify complete agent sessions or other platforms. Read the [requirements](requirements.md), [architecture](architecture.md), [workspace](workspaces.md), [network](networking.md), and [credentials](credentials.md) guides for tested scope and component-specific limits.

See the [Docker guide](docker.md) for the difference between host account sign-in, registry access, and Docker Engine inside a sandbox.

This page summarizes the security model and its known limitations. A missing validation result means unknown or unverified, not safe by assumption.
