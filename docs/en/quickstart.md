# Quick start

This guide builds the local CLI and daemon and starts the state-only control plane. Rheic is pre-alpha. A limited VM-backed CLI lifecycle passed live acceptance on macOS ARM64, but that does not establish complete interactive workflows for every agent. The commands below intentionally do not configure the VM runtime.

## Requirements

- macOS on Apple silicon for the limitedly validated native VM path.
- Go 1.27 and the Rheic module checkouts for a source build.
- `containerd`, `ctr`, `libkrun`, the patched nerdbox shim and guest image, `mkfs.erofs`, and the policy-enabled `gvproxy` build.
- A local daemon binary and CLI binary built from compatible tagged module versions.

The repository's development bundle builds CLI and daemon binaries, but does not install a system service or provision VM runtime artifacts. A limited macOS ARM64 live acceptance covered a VM-backed service-secret lifecycle; it does not validate complete agent/TTY parity or release readiness. This guide does not install a packaged app or prepare a production-ready machine. Runtime artifacts require exact pinned inputs and explicit paths; the build does not download unpinned dependencies automatically.

## Start the daemon

For a state-only development session:

```sh
sandboxesd \
  --state "$HOME/.sandboxes" \
  --socket "$HOME/.sandboxes/sandboxesd.sock"
```

The daemon owns the state directory and local socket. It refuses to replace an existing socket path. This invocation is for state-only development and does not start a VM backend by itself. To use the VM backend, configure the explicit containerd, gateway, image, and guest helper paths documented by the runtime and daemon modules. Do not point the daemon at a socket or state directory owned by another installation.

In another terminal, point the CLI at the same socket:

```sh
rsbx --socket "$HOME/.sandboxes/sandboxesd.sock" ls
```

## Check the local control plane

```sh
rsbx --socket "$HOME/.sandboxes/sandboxesd.sock" ls
rsbx --socket "$HOME/.sandboxes/sandboxesd.sock" diagnose
```

These commands confirm that the CLI can reach the local daemon and inspect control-plane state; they do not boot a guest. Runtime and daemon include exec/PTY paths, and a separate macOS live acceptance passed, but this quick start does not configure the VM backend or validate complete agent sessions and platform parity. See [requirements](requirements.md), [architecture](architecture.md), and [security](security.md) for the tested scope and remaining work.

## Where to go next

Read the [requirements](requirements.md) before building runtime components. See the [CLI reference](cli.md) for command syntax, [workspaces](workspaces.md), [networking](networking.md), and [credentials](credentials.md). The [Docker guide](docker.md) explains why account sign-in and guest Docker are separate. Read the [security model](security.md) before connecting a project or storing credentials.
