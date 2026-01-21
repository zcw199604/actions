# 项目技术约定

---

## 技术栈
- **核心:** GitHub Actions（YAML 工作流）+ bash / Python / Node.js 脚本

---

## 开发约定
- **编码:** UTF-8（无 BOM）
- **换行:** LF
- **命名约定:**
  - workflow 文件：小写 + 连字符（如 `manual.yml`、`scheduled.yml`）
  - 脚本文件：小写 + 连字符（如 `hello.sh`、`hello.py`、`hello.js`）
- **权限策略:** 以最小权限为默认（workflow 内显式声明 `permissions`）

---

## 错误与日志
- **策略:** 失败即退出（bash `set -euo pipefail`；脚本返回非 0 视为失败）
- **日志:** 统一输出关键步骤与摘要，避免输出敏感信息

---

## 测试与流程
- **测试:** 以 workflow 自身可执行为主（包含 lint/格式化可选）
- **提交:** 建议使用 Conventional Commits（中文描述可保留）

