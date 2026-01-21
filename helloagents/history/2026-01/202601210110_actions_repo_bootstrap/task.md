# 任务清单: GitHub Actions 仓库初始化（标准模板）

目录: `helloagents/history/2026-01/202601210110_actions_repo_bootstrap/`

---

## 1. docs
- [√] 1.1 在 `README.md` 中补齐：快速开始、目录结构、如何新增 workflow、Secrets/权限约定、示例用法（验证 why.md#需求-README-与新增工作流指南）

## 2. workflows
- [√] 2.1 新增 `.github/workflows/manual.yml`：支持 `workflow_dispatch` 输入参数，并分别演示 bash/Python/Node 脚本调用（验证 why.md#需求-手动触发工作流模板-场景-手动触发运行脚本）
- [√] 2.2 新增 `.github/workflows/scheduled.yml`：支持 `schedule` cron，并配置并发控制与最小权限（验证 why.md#需求-定时任务工作流模板-场景-定时运行脚本）
- [√] 2.3 新增 `.github/dependabot.yml`：启用 GitHub Actions 生态依赖更新（验证 why.md#风险评估）

## 3. scripts
- [√] 3.1 新增 `scripts/hello.sh`：演示参数读取、统一输出、失败退出码（验证 why.md#需求-多语言脚本示例-场景-统一输出与退出码）
- [√] 3.2 新增 `scripts/hello.py`：演示参数读取、统一输出、失败退出码（验证 why.md#需求-多语言脚本示例-场景-统一输出与退出码）
- [√] 3.3 新增 `scripts/hello.js`：演示参数读取、统一输出、失败退出码（验证 why.md#需求-多语言脚本示例-场景-统一输出与退出码）

## 4. 仓库基础文件
- [√] 4.1 新增 `.editorconfig`：统一编码与缩进
- [√] 4.2 新增 `.gitignore`：忽略常见 Node/Python/系统文件
- [√] 4.3 （可选）新增 `.gitattributes`：统一文本文件行尾策略

## 5. 安全检查
- [√] 5.1 执行安全检查（按G9：最小权限、敏感信息、第三方 actions 更新策略）

## 6. 文档与知识库同步
- [√] 6.1 更新 `helloagents/wiki/overview.md` 模块索引与说明（如结构有调整）
- [√] 6.2 更新 `helloagents/CHANGELOG.md`：记录初始化仓库模板与示例工作流

## 7. 本地校验
- [√] 7.1 执行 `bash -n scripts/hello.sh`、`python3 -m py_compile scripts/hello.py`、`node --check scripts/hello.js`
- [√] 7.2 检查 `git status` 干净、文件可读性与换行编码一致
