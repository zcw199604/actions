#!/usr/bin/env python3
"""用于演示 GitHub Actions 调用的 Python 示例脚本。"""

from __future__ import annotations

import argparse
import os
import sys


def main() -> int:
    parser = argparse.ArgumentParser(description="Hello 示例脚本（Python）")
    parser.add_argument("--name", default="world", help="输出名称（默认: world）")
    parser.add_argument("--fail", action="store_true", help="强制失败（返回非 0）")
    args = parser.parse_args()

    print(f"name={args.name}")
    print(f"fail={args.fail}")
    print(f"message=Hello, {args.name}!")

    summary_path = os.getenv("GITHUB_STEP_SUMMARY")
    if summary_path:
        with open(summary_path, "a", encoding="utf-8") as handle:
            handle.write("### hello.py\n")
            handle.write(f"- name: `{args.name}`\n")
            handle.write(f"- result: {'failed' if args.fail else 'success'}\n")

    if args.fail:
        print("人为触发失败（--fail）", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())

