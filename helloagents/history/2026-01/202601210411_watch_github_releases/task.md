# 任务清单: GitHub Release 版本监控（多仓库）

目录: `helloagents/history/2026-01/202601210411_watch_github_releases/`

---

## 1. workflows
- [√] 1.1 新增 `.github/workflows/watch-github-releases.yml`：支持 `workflow_dispatch` + `schedule`（北京时间 02:00），读取 `RELEASE_WATCH_REPOS` 并检测最新 Release（验证 why.md#需求-多仓库-release-检查）
- [√] 1.2 创建/更新固定 Issue（标题：`版本更新监控`），并在 body 维护状态 JSON 区块（验证 why.md#需求-固定-issue-汇总与状态存储）

## 2. docs
- [√] 2.1 更新 `README.md`：补充工作流说明、`RELEASE_WATCH_REPOS` 配置示例与定时 cron 换算（验证 why.md#需求-定时-手动触发）

## 3. 安全检查
- [√] 3.1 执行安全检查（最小权限、避免敏感信息、API 调用与错误处理）

## 4. 文档与知识库同步
- [√] 4.1 更新 `helloagents/wiki/modules/workflows.md`：补充版本监控工作流
- [√] 4.2 更新 `helloagents/wiki/modules/docs.md`：补充配置说明入口
- [√] 4.3 更新 `helloagents/CHANGELOG.md`：记录新增版本监控工作流

## 5. 本地校验
- [√] 5.1 YAML 基本检查（如无 yamllint 则使用 PyYAML 解析）
- [?] 5.2 检查 `git status` 干净，README 可读
  > 备注: 变更尚未提交，因此 `git status` 非干净；如需我生成 commit 并推送，可继续执行。
