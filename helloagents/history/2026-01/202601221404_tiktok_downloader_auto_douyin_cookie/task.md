# 任务清单: tiktok-downloader 包装镜像启动自动获取抖音 Cookie

目录: `helloagents/history/2026-01/202601221404_tiktok_downloader_auto_douyin_cookie/`

---

## 1. 包装镜像
- [√] 1.1 更新 `docker/tiktok-downloader-webapi/Dockerfile`：安装 headless Chromium 与 Playwright（用于启动时访问抖音获取 Cookie）
- [√] 1.2 更新 `docker/tiktok-downloader-webapi/entrypoint.sh`：增加 Cookie 自动获取与 TTL（默认 6 小时，可通过 `DOUYIN_COOKIE_TTL_HOURS` 调整）

## 2. 文档与知识库
- [√] 2.1 更新 `README.md`：补充包装镜像自动获取 Cookie 与 `DOUYIN_COOKIE_TTL_HOURS` 说明
- [√] 2.2 更新 `helloagents/wiki/modules/workflows.md`：补充包装镜像启动时的 Cookie 获取行为
- [√] 2.3 更新 `helloagents/wiki/modules/tiktok-downloader.md`：补充本仓库包装镜像行为说明
- [√] 2.4 更新 `helloagents/CHANGELOG.md`：记录该变更
- [√] 2.5 更新 `helloagents/history/index.md`：追加索引

