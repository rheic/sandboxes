# Credentials and sign-in

Rheic has separate flows for Docker account authorization, registry credentials, and agent service secrets. They do not imply that credentials are available inside every guest.

## Docker account

```sh
rsbx login
rsbx logout
```

`login` uses Docker Hub device authorization and stores account credentials in the host vault. For headless use, `rsbx login --username USER --password-stdin` reads a Docker Hub personal access token from standard input. Do not put a token in shell history or command arguments.

`logout` may stop running local sandboxes before removing account credentials. It asks for confirmation; `--force` skips that prompt. Registry credentials added separately with `rsbx secret set --registry` are preserved. Docker account sign-in does not currently broker credentials into guest image pulls; see [Docker](docker.md).

## Service secrets

```sh
rsbx secret set openai --sandbox agent-task
rsbx secret ls
rsbx secret rm openai --sandbox agent-task
```

The interactive `set` command prompts without echo. Removing a secret from a terminal asks for confirmation; automation must pass `--force`. Secrets are stored in the host OS credential vault; SQLite stores only non-secret metadata. A secret can be global or scoped to a sandbox. Guest-visible `${secret:service}` references are rejected because guest processes can read environment values; migrate scripts to a supported host proxy route. The proxy keeps provider credentials on the host and adds them only to requests sent to fixed provider hosts. Support for multiple service secrets per sandbox merged to daemon `main` in PR #41, but is not in published daemon tag v0.0.32. Additional agent provider routes remain under review in PR #45. P-04 fault testing and independent security review remain open. Never print resolved values into logs.

Omit SERVICE from `secret set` to choose a supported provider with the arrow keys. Press Enter to continue or q/Escape/Ctrl-C to cancel.

When setting a service secret, the CLI uses an atomic create-only RPC and refuses to replace an existing value. Pass `--force` or `-f` to overwrite. An older daemon that does not implement the create-only RPC fails closed instead of silently overwriting.

For compatibility with Docker `sbx`, `secret set` accepts `-t` as a shorthand for `--token`.

`secret rm` also accepts `remove`, `delete`, and `unset`. Without a name, it opens a terminal selector for inventoried service secrets, registry credentials, and Docker/OpenAI account tokens; use the arrow keys and Enter to remove the selected entry, or `q`, Escape, or Ctrl-C to cancel. It requires `--force` for named removals in scripts. `secret rm --all` removes currently inventoried Rheic credentials across scopes after inventory succeeds. The operation can be partially applied if a deletion fails midway. Custom-secret storage is not implemented and is excluded; custom/placeholder secret removal remains an open parity gap.

`secret ls` also accepts the `list` alias and Docker's `--global`/`-g`, `--sandbox`, `--service`, and `--quiet`/`-q` filters.

Like Docker `sbx`, `secret rm openai` removes both the global OpenAI API key and the host OAuth session. Use `--oauth` when you want to remove only the OAuth session; a sandbox-scoped command removes only that sandbox's API key.

`secret import` reads the supported provider environment variables. It asks before importing or overwriting each value with a default of yes unless `--all` or `--force` is passed; Enter accepts, while EOF cancels. `--all` imports new entries and skips existing ones; `--force` imports without prompts and overwrites existing values. The command reports imported and skipped counts. If the credential inventory cannot be read, import stops without writing. New non-forced entries use the daemon's atomic create-only operation. When an OpenAI OAuth session is stored, its environment API key is skipped because OAuth takes precedence; an unavailable OAuth status also stops the import before writes. Like Docker `sbx`, `--dry-run` writes nothing and displays only the last four characters of the detected value. `secret set-custom` currently fails closed because custom placeholder storage and proxy substitution are not implemented.

For scripts, use `--token` only with a secret source that does not expose it in process arguments; prefer an interactive prompt or a protected standard-input flow where supported. `secret import --dry-run` previews host credential migration, and `secret import --all` imports eligible entries.

## Registry credentials

```sh
rsbx secret set --registry ghcr.io --username USER --password-stdin
rsbx secret ls
rsbx secret rm --registry ghcr.io --force
```

The password is read from standard input. Without a scope flag, `secret rm --registry` removes host-only and all-sandboxes entries. Use `--all-sandboxes` to remove only the all-sandboxes entry, or `--sandbox NAME` for one sandbox. Registry removal asks for confirmation in a terminal; scripts should use `--force`. Registry secrets are held on the host. The current source checkout has an experimental Docker Hub broker for guest pulls and pushes: it uses host-side TLS forwarding and scoped guest tokens, while the real registry bearer stays on the host. Only Docker Hub is supported by this path. It has synthetic contract coverage, but no live VM registry acceptance or `sbx` runtime comparison; it is not released or production-qualified. Host-only entries are not exposed to guest requests. Avoid sharing a sandbox with a workload that should not use a scoped credential.

## What is not connected

`rsbx login` is Docker account sign-in. To store OpenAI/Codex OAuth on the host, run `rsbx secret set openai --oauth`; tokens stay in the host credential vault, and `rsbx secret rm openai --oauth` removes them with best-effort upstream revocation. In a terminal, removal asks for confirmation; use `--force` in scripts. For a client that accepts a bearer token in `OPENAI_API_KEY`, use `rsbx run --env 'OPENAI_API_KEY=${oauth:openai}' ...`. The guest receives only a placeholder; the host proxy refreshes and injects the token on requests to `api.openai.com`. A kit can request this same fixed route under `spec.credentials[].oauth.resourceHosts`; `rsbx run --kit FILE` signs in on the host if needed. The kit subset does not configure the token endpoint, write OAuth credential files, or allow other resource hosts. `rsbx run codex` follows the same host-first order: a stored OpenAI API key is used through the host proxy when present; otherwise the CLI checks for an OpenAI OAuth session, signs in on the host if needed, and passes only the OAuth reference into the sandbox. This implementation covers Codex requests that use `OPENAI_API_KEY`; it does not yet relay Claude's in-sandbox OAuth flow, write provider credential files, or support other OAuth providers.
