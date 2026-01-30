#!/usr/bin/env bash
set -euo pipefail

VOLUME_DIR="${VOLUME_DIR:-/app/Volume}"
RUN_COMMAND="${RUN_COMMAND:-7}"

python - <<'PY'
import json
import os
import pathlib
import re
import sqlite3

volume_dir = pathlib.Path(os.environ.get("VOLUME_DIR", "/app/Volume"))
run_command = str(os.environ.get("RUN_COMMAND", "7"))
port_env = os.environ.get("PORT")

volume_dir.mkdir(parents=True, exist_ok=True)

settings_path = volume_dir / "settings.json"
cfg = {}
if settings_path.exists():
    try:
        cfg = json.loads(settings_path.read_text(encoding="utf-8"))
    except Exception:
        cfg = {}
cfg["run_command"] = run_command

settings_path.write_text(
    json.dumps(cfg, ensure_ascii=False, indent=4),
    encoding="utf-8",
)

db_path = volume_dir / "DouK-Downloader.db"
con = sqlite3.connect(db_path)
con.execute(
    "CREATE TABLE IF NOT EXISTS config_data (NAME TEXT PRIMARY KEY, VALUE INTEGER NOT NULL CHECK(VALUE IN (0, 1)));"
)
con.execute("INSERT OR REPLACE INTO config_data (NAME, VALUE) VALUES ('Disclaimer', 1);")
con.commit()
con.close()

if port_env:
    try:
        port = int(port_env)
        if not (1 <= port <= 65535):
            raise ValueError
    except ValueError:
        raise SystemExit(f"Invalid PORT: {port_env!r}")

    static_path = pathlib.Path("/app/src/custom/static.py")
    if not static_path.exists():
        raise SystemExit("Missing /app/src/custom/static.py, cannot apply PORT")

    text = static_path.read_text(encoding="utf-8")
    updated, count = re.subn(
        r"^SERVER_PORT\s*=\s*\d+\s*$",
        f"SERVER_PORT = {port}",
        text,
        flags=re.MULTILINE,
    )
    if count == 0 and f"SERVER_PORT = {port}" not in text:
        raise SystemExit("Failed to set SERVER_PORT in static.py")
    if count > 0:
        static_path.write_text(updated, encoding="utf-8")
PY

exec "$@"
