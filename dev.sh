#!/usr/bin/env bash
set -euo pipefail

site_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
venv_dir="$site_dir/.venv"
action="${1:-serve}"

usage() {
  cat <<'USAGE'
Usage: ./docs/site/dev.sh [serve|check]

  serve  Install the pinned docs dependencies if needed, then start live preview.
         Set DOCS_HOST or DOCS_PORT to change the bind address (default 127.0.0.1:8000).
  check  Build both languages with strict warnings and verify the output pages.
USAGE
}

case "$action" in
  serve|check) ;;
  -h|--help|help) usage; exit 0 ;;
  *) usage >&2; exit 2 ;;
esac

if [[ ! -x "$venv_dir/bin/mkdocs" ]]; then
  python3 -m venv "$venv_dir"
  "$venv_dir/bin/python" -m pip install --disable-pip-version-check -r "$site_dir/requirements.txt"
fi

if [[ "$action" == "serve" ]]; then
  read -r serve_mode serve_port < <("$venv_dir/bin/python" - "${DOCS_PORT:-8000}" <<'PY'
import socket
import sys
from urllib.request import urlopen

preferred = int(sys.argv[1])
port = preferred
while port < 65536:
    try:
        with urlopen(f"http://127.0.0.1:{port}/", timeout=1) as response:
            html = response.read().decode("utf-8", errors="replace")
        if 'id="home-title"' in html and "rheic.css" in html:
            print("reuse", port)
            raise SystemExit(0)
    except OSError:
        pass

    probe = socket.socket()
    try:
        probe.bind(("127.0.0.1", port))
    except OSError:
        port += 1
        continue
    finally:
        probe.close()
    print("start", port)
    raise SystemExit(0)

raise SystemExit("no available documentation preview port found")
PY
  )
  if [[ "$serve_mode" == "reuse" ]]; then
    printf 'Rheic docs preview is already responding at http://127.0.0.1:%s/\n' "$serve_port"
    exit 0
  fi
  exec "$venv_dir/bin/mkdocs" serve \
    --config-file "$site_dir/mkdocs.yml" \
    --dev-addr "${DOCS_HOST:-127.0.0.1}:${serve_port}"
fi

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/rheic-docs-check.XXXXXX")"
trap 'rm -rf "$tmp_dir"' EXIT
"$venv_dir/bin/mkdocs" build \
  --strict \
  --config-file "$site_dir/mkdocs.yml" \
  --site-dir "$tmp_dir/site"
test -s "$tmp_dir/site/index.html"
test -s "$tmp_dir/site/ru/index.html"
printf 'Docs check passed: English and Russian pages rendered.\n'
