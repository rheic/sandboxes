# Workspaces and files

A workspace is a host directory mounted into a sandbox. A writable workspace lets processes in the guest change those host files. Add only the directories the agent needs. Runtime and daemon include exec/PTY paths, and a limited macOS VM-backed lifecycle test passed; these CLI options do not establish workspace safety or full agent parity on every platform.

## Choose what to mount

Use the current directory as the default workspace:

```sh
cd /path/to/project
rsbx run shell .
```

Pass additional directories after the agent name. Add `:ro` to mount a directory read-only:

```sh
rsbx run shell . /path/to/reference:ro
```

Use `--deny-write` to make a subdirectory read-only while its parent workspace remains writable:

```sh
rsbx run --deny-write ./secrets shell .
```

Omit all workspace paths for a mountless sandbox. A mountless sandbox still receives files from its image; it is not an empty filesystem.

## Copy files

Exactly one side of `rsbx cp` must be a sandbox path. Guest paths must be absolute:

```sh
rsbx cp ./result.json build:/tmp/result.json
rsbx cp build:/tmp/report.txt ./report.txt
```

The command copies regular files and directory trees. Symbolic links, hard links, and special files are rejected by default. `-L` follows a top-level source symlink; its target must stay within a mounted workspace when the source is inside one. Nested links remain rejected.

## Reuse a named sandbox

`rsbx run --name NAME` reuses the named sandbox and starts it if needed. Explicitly different workspace paths or read/write modes are rejected instead of silently changing the existing sandbox. Use a new name when you need a different mount set.

## Limits

Workspace mounts are direct host file access. A read-only mount prevents writes through that mount; it does not hide data in the guest image or protect a different writable mount to the same host path. Host crash cleanup and broad adversarial filesystem validation remain open work. See the [security guide](security.md) before mounting sensitive directories.
