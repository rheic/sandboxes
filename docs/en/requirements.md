# System requirements

Rheic is pre-alpha and does not have a general-purpose installer. The validated native VM path currently targets macOS on Apple silicon. Build and configure the modules and runtime artifacts before trying the VM workflow.

## Supported development host

| Host | Current status |
|---|---|
| macOS on Apple silicon | Native VM path has local validation; release qualification remains open |
| Linux with KVM | Development work exists; this documentation does not claim a qualified release |
| Windows with WHP | Runtime integration and guest workflow are incomplete; not available for general use |

Use the project plan for current validation evidence and platform blockers.

## Build tools

A source build uses Go 1.27 and the tagged Rheic module repositories. The modules are separate Go modules; `modules/go.work` is for local development. Release builds must use tagged versions without workspace substitutions.

Build the CLI and daemon from their module directories:

```sh
cd modules/sandboxes-cli
mkdir -p ./bin
go build -o ./bin/rsbx ./cmd/rsbx

cd ../sandboxes-daemon
mkdir -p ./bin
go build -o ./bin/sandboxesd ./cmd/sandboxesd
```

These commands build binaries only. They do not install a system service, configure a keychain, or prepare a VM runtime.

## VM runtime components

The native VM backend also needs the pinned components in `modules/sandboxes-runtime/build/manifest.yaml`:

- containerd and `ctr`
- libkrun and the nerdbox shim
- the matching guest kernel and EROFS root filesystem
- the policy-enabled `gvproxy` build when network access is required
- `mkfs.erofs` and `mkfs.ext4` for runtime image and storage tasks

The containerd process must find the patched nerdbox shim before the stock shim on `PATH`. Use the runtime build instructions to build the exact pinned inputs. Do not substitute an arbitrary system QEMU, shim, or gateway binary.

## Runtime configuration

The daemon starts in state-only mode when `--containerd` is empty. State-only mode does not start VMs. A VM configuration requires the explicit containerd socket, a compatible runtime, image, and the guest artifacts. Networking stays disabled unless the daemon receives a compatible policy gateway.

See the [quick start](quickstart.md) for the distinction between state-only mode and the VM backend, and the [architecture guide](architecture.md) for component boundaries.
