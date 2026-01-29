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
import time

COOKIE_PATTERN = re.compile(r"[!#$%&'*+\-.^_`|~0-9A-Za-z]+=([^;\s][^;]*)")

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

def find_chromium_executable() -> str | None:
    candidates = [
        os.environ.get("CHROMIUM_PATH"),
        "/usr/bin/chromium",
        "/usr/bin/chromium-browser",
        "/usr/bin/google-chrome",
        "/usr/bin/google-chrome-stable",
    ]
    for c in candidates:
        if c and os.path.exists(c):
            return c
    return None


def get_cookie_str_from_douyin() -> str:
    url = os.environ.get("DOUYIN_COOKIE_URL", "https://www.douyin.com/")
    timeout_ms = int(os.environ.get("DOUYIN_COOKIE_TIMEOUT_MS", "30000"))
    wait_total_ms = int(os.environ.get("DOUYIN_COOKIE_WAIT_MS", "8000"))
    wait_step_ms = int(os.environ.get("DOUYIN_COOKIE_WAIT_STEP_MS", "500"))
    user_agent = os.environ.get(
        "DOUYIN_COOKIE_USER_AGENT",
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    )

    chromium_path = find_chromium_executable()
    if not chromium_path:
        raise RuntimeError("Chromium executable not found (expected /usr/bin/chromium)")

    try:
        from playwright.sync_api import sync_playwright
    except Exception as e:
        raise RuntimeError(f"playwright not available: {e}") from e

    with sync_playwright() as p:
        browser = p.chromium.launch(
            headless=True,
            executable_path=chromium_path,
            args=[
                "--no-sandbox",
                "--disable-dev-shm-usage",
                "--disable-gpu",
                "--no-first-run",
                "--no-default-browser-check",
            ],
        )
        try:
            context = browser.new_context(
                user_agent=user_agent,
                locale="zh-CN",
                viewport={"width": 1280, "height": 720},
            )
            page = context.new_page()
            page.goto(url, wait_until="domcontentloaded", timeout=timeout_ms)

            elapsed = 0
            cookie_str = ""
            while elapsed <= wait_total_ms:
                cookies = context.cookies([url])
                pairs = [
                    f"{c.get('name')}={c.get('value')}"
                    for c in sorted(cookies, key=lambda x: (x.get("name") or ""))
                    if c.get("name") and c.get("value")
                ]
                cookie_str = "; ".join(pairs)
                if COOKIE_PATTERN.search(cookie_str):
                    break
                page.wait_for_timeout(wait_step_ms)
                elapsed += wait_step_ms

            return cookie_str
        finally:
            browser.close()


def cookie_has_value(value) -> bool:
    if isinstance(value, str):
        return bool(value.strip())
    if isinstance(value, dict):
        return bool(value)
    return False


cookie_timestamp_path = volume_dir / "douyin_cookie_saved_at.txt"
try:
    cookie_ttl_hours = float(os.environ.get("DOUYIN_COOKIE_TTL_HOURS", "6"))
except ValueError:
    cookie_ttl_hours = 6.0
cookie_ttl_seconds = max(cookie_ttl_hours, 0) * 60 * 60

now = time.time()
need_refresh_cookie = False

if not cookie_has_value(cfg.get("cookie")):
    need_refresh_cookie = True
elif cookie_timestamp_path.exists():
    try:
        saved_at = float(cookie_timestamp_path.read_text(encoding="utf-8").strip())
        if cookie_ttl_seconds == 0 or (now - saved_at) >= cookie_ttl_seconds:
            need_refresh_cookie = True
    except Exception:
        need_refresh_cookie = True
else:
    # cookie 已存在但没有时间戳：视为用户手动配置，避免自动覆盖
    need_refresh_cookie = False

if need_refresh_cookie:
    try:
        cookie_str = get_cookie_str_from_douyin()
        if COOKIE_PATTERN.search(cookie_str):
            cfg["cookie"] = cookie_str
            cookie_timestamp_path.write_text(str(int(now)), encoding="utf-8")
        else:
            print("Warning: Douyin cookie fetch returned empty cookie, skipping write", flush=True)
    except Exception as e:
        print(f"Warning: Douyin cookie fetch failed: {e}", flush=True)

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
