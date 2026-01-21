# 任务清单: 镜像同步支持单仓库推送

目录: `helloagents/history/2026-01/202601210553_sync_image_optional_registry/`

---

## 1. workflows
- [√] 1.1 更新 `.github/workflows/sync-tiktok-downloader.yml`：允许仅配置 TCR 或仅配置 ACR；未配置的一方跳过登录与推送

## 2. 文档更新
- [√] 2.1 更新 `README.md`：说明 TCR/ACR 可选启用与 Secrets 配置
- [√] 2.2 更新 `helloagents/wiki/modules/workflows.md`：补充可选目标仓库说明
- [√] 2.3 更新 `helloagents/CHANGELOG.md`：记录该优化

## 3. 校验
- [√] 3.1 YAML 解析校验（PyYAML）

## 4. 发布
- [√] 4.1 提交并推送到 `origin/main`
