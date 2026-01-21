#!/usr/bin/env bash
set -euo pipefail

VOLUME_DIR="${VOLUME_DIR:-/app/Volume}"
RUN_COMMAND="${RUN_COMMAND:-7}"

python - <<'PY'
import json
import os
import pathlib
import sqlite3

volume_dir = pathlib.Path(os.environ.get("VOLUME_DIR", "/app/Volume"))
run_command = str(os.environ.get("RUN_COMMAND", "7"))

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
PY

exec "$@"
