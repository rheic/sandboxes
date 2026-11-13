# Troubleshooting

Start with the exact binary version and its built-in help:

```sh
rsbx --help
rsbx diagnose
sandboxd --help
```

The daemon binary is named `sandboxesd`; use `sandboxesd --help` if the command above is not found.

`rsbx diagnose` prints a sectioned report (installation, platform, storage, connection) of individually graded checks with a pass/fail/warning/skip summary and exits non-zero when a check fails. `rsbx policy log` shows the gateway audit decisions (allowed/denied destinations with the matching rule) recorded in the daemon run directory.

## The CLI cannot connect

Point the CLI at the same local socket used by the daemon:

```sh
rsbx --socket "$HOME/.sandboxes/sandboxesd.sock" ls
```

Check that the daemon is running and that your account can access the socket. `SANDBOXES_SOCKET` can provide the default socket path. Do not replace an unknown socket or state directory.

## A sandbox does not start

The daemon command in the [quick start](quickstart.md) runs in state-only mode: it starts the control plane but does not configure a VM backend, so that command alone will not boot a VM. Guest execution also requires compatible containerd, runtime, guest image, shim, and helper artifacts configured for the platform. A limited VM-backed CLI lifecycle passed live acceptance on macOS ARM64; this does not validate the full agent workflow. The Windows WHPX backend is not wired into the production daemon, and Linux KVM is not qualified. Check the [requirements](requirements.md) and [architecture](architecture.md) for the platform-specific setup and current limits.

## Network access fails

Guest egress defaults to deny. Check the sandbox policy, configured gateway, and DNS upstream. Add only the required destination rule. `rsbx policy check` evaluates stored policy inputs; it does not verify live packet enforcement by the gateway. `rsbx policy log` prints recent gateway audit decisions with the matched rule; `rsbx policy inspect RULE_ID|SANDBOX` shows one rule or sandbox policy in detail. See [Network and ports](networking.md).

## Docker sign-in worked, but guest pulls fail

Docker account authorization is stored on the host. Guest registry credential brokering is not currently connected to the runtime image pull path. See [Docker](docker.md).

## A name is already tied to another workspace

Use a new sandbox name for a different workspace, or inspect the existing sandbox with `rsbx get NAME`. Do not assume reusing a name switches the mounted host directory.

## Removing a sandbox did not remove host files

Sandbox removal does not delete the host workspace. Review and remove project files yourself after confirming their location; Rheic does not own arbitrary host directories.

For an unresolved issue, capture `rsbx diagnose` output after checking it for local paths or sensitive metadata, and include the exact module versions and platform. Never attach credentials or unredacted secrets.
