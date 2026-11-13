# Frequently asked questions

Rheic is pre-alpha. This page separates what Docker Sandboxes documents from what has been implemented and validated in Rheic.

## Does Docker Sandboxes use full microVMs?

Docker documents one lightweight microVM and Linux kernel per agent, with a separate Docker Engine inside the VM. The hypervisor is the primary isolation boundary; host workspaces and other integrations cross that boundary only when explicitly shared. See Docker's [isolation layers](https://docs.docker.com/ai/sandboxes/security/isolation/) and [architecture](https://docs.docker.com/ai/sandboxes/architecture/) guides. “MicroVM” describes the virtualization boundary; it is not a guarantee that every configuration or integration is risk-free.

Rheic also targets a microVM boundary, but it does not currently claim Docker parity or complete security qualification. A limited VM-backed lifecycle passed on macOS ARM64. Linux KVM is not qualified, Windows WHP is incomplete, and independent security review remains open. See the [Rheic architecture](architecture.md), [platform requirements](requirements.md), and [security model](security.md).

## Does the quick start launch a VM?

No. It starts the daemon in state-only mode so you can inspect the local control plane. A VM requires additional platform components described in [system requirements](requirements.md).

## Can I run a coding agent inside a Rheic sandbox?

The CLI and runtime include agent and exec paths, and limited VM-backed lifecycle acceptance passed on macOS ARM64. Full interactive workflows for every agent and platform have not passed acceptance. See the [agent guide](agents.md) and [platform status](requirements.md).

## Does a successful command prove isolation?

No. A successful CLI response confirms only that command's result. VM isolation requires separate live runtime and security evidence. See the [security model](security.md).

## Is Docker Engine inside the guest ready for workloads?

The opt-in guest Docker daemon can start, but nested `docker run`, `docker load`, `docker build`, and Compose are blocked by guest `unshare` restrictions in the current runtime. This is not the Docker Engine workflow documented by Docker Sandboxes. See [Docker and Rheic](docker.md).

## Can the guest access my host files or Docker daemon?

Only explicitly configured workspace paths are shared with the guest. A writable workspace lets guest processes change those host files, so mount only what the task needs. The host Docker socket is not mounted. See [workspaces and files](workspaces.md) and the [security model](security.md).
