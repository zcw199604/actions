# docs

## 目的
提供仓库使用说明与规范，降低新增 workflow 的成本，并明确安全与权限约定。

## 模块概述
- **职责:** 维护 README 与相关说明文档；沉淀最佳实践与模板入口
- **状态:** ✅稳定
- **最后更新:** 2026-01-21

## 规范

### 需求: README 作为入口文档
**模块:** docs
需要提供清晰的快速开始、目录结构说明、如何新增 workflow、Secrets 与权限策略说明，并包含可复制的示例。

#### 场景: 新增一个 workflow
- 能根据模板快速复制并修改
- 能明确需要的权限与 secrets
- 能在 Actions 页面快速验证运行结果

## 依赖
- workflows
- scripts

## 变更历史
- [202601210110_actions_repo_bootstrap](../../history/2026-01/202601210110_actions_repo_bootstrap/) - 初始化 README（中文）与新增 workflow 指南
- [202601210224_sync_image_tiktok_downloader](../../history/2026-01/202601210224_sync_image_tiktok_downloader/) - README 补充镜像同步说明与 Secrets 配置
- [202601210411_watch_github_releases](../../history/2026-01/202601210411_watch_github_releases/) - README 补充版本更新监控说明与变量配置
- [202601210825_tiktok_downloader_webapi_wrapper](../../history/2026-01/202601210825_tiktok_downloader_webapi_wrapper/) - README 补充 tiktok-downloader Web API 包装镜像说明
