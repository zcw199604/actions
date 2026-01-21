# 任务清单: 镜像同步（joeanamier/tiktok-downloader → TCR/ACR）

目录: `helloagents/history/2026-01/202601210224_sync_image_tiktok_downloader/`

---

## 1. workflows
- [√] 1.1 新增 `.github/workflows/sync-tiktok-downloader.yml`：支持手动+定时触发，拉取 `joeanamier/tiktok-downloader:latest`（`linux/amd64`）并推送至 TCR 与 ACR（验证 why.md#需求-手动镜像同步、why.md#需求-定时镜像同步）
- [√] 1.2 在 workflow 中实现失败创建/复用 Issue（验证 why.md#需求-失败告警-场景-自动创建-issue）

## 2. docs
- [√] 2.1 更新 `README.md`：补充镜像同步工作流说明、Secrets 清单与示例、定时 cron（UTC 换算）（验证 why.md#需求-配置说明-场景-按文档配置并跑通）

## 3. 安全检查
- [√] 3.1 执行安全检查（按G9：最小权限、敏感信息不落盘、第三方 action 版本）

## 4. 文档与知识库同步
- [√] 4.1 更新 `helloagents/wiki/modules/workflows.md`：补充镜像同步工作流能力与约定
- [√] 4.2 更新 `helloagents/wiki/modules/docs.md`：补充 Secrets 配置说明入口
- [√] 4.3 更新 `helloagents/CHANGELOG.md`：记录新增镜像同步工作流

## 5. 本地校验
- [√] 5.1 运行 `yamllint`（如未配置则跳过）或至少做 YAML 基本检查（结构与缩进）
- [?] 5.2 检查 `git status` 干净，README 链接与说明可读
  > 备注: 变更尚未提交，因此 `git status` 非干净；如需我生成 commit 并推送，可继续执行。
