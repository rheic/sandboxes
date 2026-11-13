# Terminal dashboard

`rsbx tui` opens a read-only terminal view of local sandboxes. It uses the local daemon through the Go SDK.

```sh
rsbx tui
```

Use the arrow keys or `j`/`k` to move through the list, `r` to refresh, and `q` or `Esc` to exit. The dashboard does not start, stop, delete, or attach to a sandbox; use the corresponding CLI command for changes.

If the dashboard cannot connect, check the selected daemon socket with `rsbx --socket PATH tui` and confirm that the daemon is running. See [Troubleshooting](troubleshooting.md).
