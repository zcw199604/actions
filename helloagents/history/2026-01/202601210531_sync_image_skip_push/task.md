# 任务清单: 镜像同步跳过重复推送

目录: `helloagents/history/2026-01/202601210531_sync_image_skip_push/`

---

## 1. workflows
- [√] 1.1 更新 `.github/workflows/sync-tiktok-downloader.yml`：对比源镜像与目标镜像 digest/ID，相同则跳过 push

## 2. 文档更新
- [√] 2.1 更新 `helloagents/wiki/modules/workflows.md`：补充“相同 digest 跳过推送”说明
- [√] 2.2 更新 `helloagents/CHANGELOG.md`：记录该优化

## 3. 校验
- [√] 3.1 YAML 解析校验（PyYAML）

## 4. 发布
- [√] 4.1 提交并推送到 `origin/main`
