# scripts

## 目的
存放可被 GitHub Actions 调用的脚本（bash / Python / Node.js），用于复用逻辑、减少 YAML 重复，并便于本地调试。

## 模块概述
- **职责:** 提供脚本示例与执行约定（参数、退出码、日志、依赖）
- **状态:** ✅稳定
- **最后更新:** 2026-01-21

## 规范

### 需求: 多语言脚本示例
**模块:** scripts
需要提供最小可运行的 bash / Python / Node.js 示例脚本，用于演示 workflow 调用方式与日志输出。

#### 场景: 运行并输出摘要
- 脚本可独立运行
- 输出包含关键参数与执行结果
- 失败时返回非 0

## 依赖
- workflows

## 变更历史
- [202601210110_actions_repo_bootstrap](../../history/2026-01/202601210110_actions_repo_bootstrap/) - 初始化脚本示例（bash/Python/Node）
