# Agents

The CLI includes an agent registry. On macOS ARM64, live probes launched the pinned shell and Gemini images; a shell fixture ran successfully and Gemini's version command completed without contacting a provider. This does not establish provider login, complete sessions for every agent, or platform parity.

## Registry status

| Status | Meaning |
|---|---|
| Available | The CLI has a pinned image or command and release-tag evidence exists for the listed path |
| Preview | An image or command is registered, but end-to-end behavior or authentication is incomplete |
| Unsupported | The CLI rejects the agent because its image or integration contract is not available |

The P-05 feature branch registry includes:

| Agent | Status | Notes |
|---|---|---|
| `claude`, `codex`, `copilot`, `cursor`, `devin`, `docker-agent`, `droid`, `gemini`, `kiro`, `opencode`, `shell` | Preview | Launchable with pinned Docker template images; provider authentication, nested Docker workloads, and full VM lifecycle are not yet validated |
| `kimi` | Available in the existing registry | Rheic extension with earlier released-tag evidence |
| `dsh` | Preview extension | Rheic-specific agent, not part of Docker's built-in set |
| `cline` | Unsupported | Not part of the Docker built-in set |

The Docker built-in set for the pinned `sbx v0.50.1` baseline is Claude,
Codex, Copilot, Cursor, Devin, Docker Agent, Droid, Gemini, Kiro, OpenCode,
and Shell. The P-05 branch makes all names launchable through `rsbx run`; the
Docker built-ins remain preview until their auth and owned-VM checks pass. Run
`rsbx agents list` to inspect image, launch command, and auth notes.

In the same branch, `rsbx run claude` detects a stored host `anthropic` secret
and passes only the `${proxy:anthropic}` reference to the guest. The real key
stays in the host vault. CLI tests cover this path, but it has not been tested
with a live Claude VM. Claude guest OAuth remains disabled because it can store
credentials inside the sandbox and needs a separate host-side adapter.

The registry changes with the CLI module. Inspect `rsbx run --help` and the embedded `internal/agent/registry.yaml` from the version you use.

## CLI command shape

The documented command shape for an interactive shell is:

```sh
rsbx run shell .
```

The CLI also accepts a detached invocation:

```sh
rsbx run --detach --name review kimi .
rsbx ls
rsbx exec -it review /bin/sh
```

Agent arguments follow `--`:

```sh
rsbx run cursor . -- -p "review this change"
rsbx run kiro . -- login --use-device-flow
```

If the first argument after `--` starts with a flag, Rheic keeps the agent's
default launch flags and appends the argument. A bare command or subcommand
replaces the defaults, matching Docker's documented launch rule.

The CLI grammar defines `run` as create-or-reuse, start, and attach. Runtime and daemon include exec/PTY implementations, and limited VM-backed lifecycle and exec checks passed on macOS ARM64; complete agent lifecycle and TTY behavior have not passed shared platform acceptance. The current directory is the default workspace. `--detach` returns after startup, while `create` creates without attaching. Shell and Gemini image launch probes passed, but all Docker built-ins remain preview pending per-agent auth and lifecycle checks. `--image` selects a custom image. These examples do not establish a working guest session for every agent.

## Authentication

Provider sign-in is separate from Rheic's Docker account sign-in. Codex uses a
stored `openai` secret through the host proxy, or host OAuth when no API key is
stored. Claude uses a stored `anthropic` secret through the host proxy. Gemini
uses a stored `google` API key through a fixed host proxy route; Google account
OAuth and Vertex credentials are not brokered. OpenCode and Docker Agent also
receive proxy references for stored `openai`, `anthropic`, `google`, `groq`, `mistral`, `openrouter`, and `xai` keys. Their provider setup and live
authentication remain unvalidated. Stored GitHub tokens now use fixed host
proxy routes for Copilot, Cursor API keys use fixed Cursor host routes, and
Factory API keys use fixed routes for Droid. Their OAuth flows and live agent
requests remain unvalidated. Store these keys with `rsbx secret set github`,
`rsbx secret set cursor`, and `rsbx secret set droid`. Claude/Codex/Gemini and
multi-provider key selection are also not live-tested. Devin still needs its
host credential relay. Kiro's documented device flow persists credentials in
the VM, which Rheic's host-only secret rule does not allow; this remains a
parity blocker. Do not
assume `rsbx login` authenticates an AI agent; it signs in to Docker. See
[credentials and sign-in](credentials.md) for credential scopes.

## Current limits

No Docker built-in has completed the full provider-auth and lifecycle acceptance required for an available status. Agent registry entries and two image launch probes do not establish platform support or security qualification. See [system requirements](requirements.md) and the [security guide](security.md) before selecting an agent.
