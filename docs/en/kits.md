# Kits

A kit is a local YAML file or Docker v2 directory containing `spec.yaml` (or `spec.yml`) that groups an agent or image with sandbox configuration. Current kits are unsigned local files; treat them as executable configuration and inspect them before use.

## Inspect and apply

```sh
rsbx kit inspect ./kit.yaml
rsbx kit ls
rsbx run --kit ./kit.yaml .
```

The available commands and fields depend on the CLI version. The CLI registry and `rsbx --help` are authoritative for an installed build.

## Minimal example

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

The kit needs an `agent` or an `image`. Supported policy profiles include `deny-all`, `balanced`, and `sbx-compat`. A workspace seed is cloned into a local cache once; lifecycle hooks are disabled for this path. Use a real repository URL only after reviewing the source and the resulting workspace.

## Current limits

- The parser accepts a strict subset of Docker Kits v2 `spec.yaml` sandboxes and nested OAuth fields. Only the built-in `openai` OAuth declaration is currently runnable: it uses the daemon's fixed `api.openai.com` route. Generic OAuth declarations are rejected by the daemon at create time until host TLS interception, per-service routing, guest credential-file setup and lifecycle cleanup are implemented.
- The built-in `rsbx run codex` path checks a stored API key first and otherwise uses host-side OpenAI OAuth. Docker kit schema acceptance does not imply Docker runtime parity; remote kits, mixins and signature verification are not implemented.
- Kits are local YAML; OCI distribution and signature verification are not implemented.
- A non-empty MCP allowlist is rejected rather than silently ignored.
- Kit configuration does not make preview agents or blocked runtime features production-ready.
- Inspect the rendered configuration and verify mount paths and network policy before running it.
