#!/usr/bin/env bash
# 用于演示 GitHub Actions 调用的 Bash 示例脚本。
# 支持 --name 与 --fail 参数，用于输出与失败演示。

set -euo pipefail

usage() {
  cat <<'USAGE'
用法:
  bash scripts/hello.sh [--name <name>] [--fail]

参数:
  --name <name>  设置输出名称（默认: world）
  --fail         强制失败（返回非 0）
  -h, --help     显示帮助
USAGE
}

name="world"
fail="false"

while [ $# -gt 0 ]; do
  case "$1" in
    --name)
      if [ $# -lt 2 ]; then
        echo "缺少 --name 参数值" >&2
        usage >&2
        exit 2
      fi
      name="$2"
      shift 2
      ;;
    --fail)
      fail="true"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "未知参数: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

echo "name=${name}"
echo "fail=${fail}"
echo "message=Hello, ${name}!"

if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
  {
    echo "### hello.sh"
    echo "- name: \`${name}\`"
    echo "- result: $([ "${fail}" = "true" ] && echo "failed" || echo "success")"
  } >>"${GITHUB_STEP_SUMMARY}"
fi

if [ "${fail}" = "true" ]; then
  echo "人为触发失败（--fail）" >&2
  exit 1
fi

