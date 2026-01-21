# workflows

## 目的
定义与维护仓库的 GitHub Actions 工作流入口，覆盖手动触发与定时执行两类场景，并提供可复用模板。

## 模块概述
- **职责:** 组织 `.github/workflows/` 文件；规范权限、触发方式、输入参数、并发策略与日志输出
- **状态:** ✅稳定
- **最后更新:** 2026-01-21

## 规范

### 需求: 手动触发与定时触发
**模块:** workflows
需要提供 `workflow_dispatch` 与 `schedule` 的示例工作流，并包含 bash / Python / Node.js 的执行示例。

#### 场景: 手动触发
需支持输入参数（可选），并能在 Actions 页面一键运行与查看结果。
- 能在 Actions 页面选择 workflow 并执行
- Job 运行成功/失败清晰可见

#### 场景: 定时触发
需支持 cron 配置，并能在固定时间自动执行。
- 按 cron 定时运行
- 出错时便于定位与重试

## 依赖
- scripts

## 变更历史
- [202601210110_actions_repo_bootstrap](../../history/2026-01/202601210110_actions_repo_bootstrap/) - 初始化标准模板（手动/定时 workflow 示例）
