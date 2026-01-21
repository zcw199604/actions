# 任务清单: tiktok-downloader Web API 包装镜像

目录: `helloagents/history/2026-01/202601210825_tiktok_downloader_webapi_wrapper/`

---

## 1. 包装镜像
- [√] 1.1 新增 `docker/tiktok-downloader-webapi/Dockerfile`：基于上游镜像并注入入口脚本与元数据标签
- [√] 1.2 新增 `docker/tiktok-downloader-webapi/entrypoint.sh`：启动前自动准备 `Volume/settings.json` 与 `DouK-Downloader.db`

## 2. 同步工作流
- [√] 2.1 更新 `.github/workflows/sync-tiktok-downloader.yml`：在推送到 TCR/ACR 前构建包装镜像，并用（base digest + wrapper sha）判断是否跳过推送

## 3. 文档与知识库
- [√] 3.1 更新 `README.md`：说明 tiktok-downloader 镜像现在默认启动 Web API 以及可配置项
- [√] 3.2 更新 `helloagents/wiki/modules/workflows.md`：同步工作流变更（构建包装层、跳过判定规则）
- [-] 3.3 更新 `helloagents/wiki/arch.md`（如需）：补充包装镜像的设计决策与元数据约定
- [√] 3.4 更新 `helloagents/CHANGELOG.md`：记录该变更

## 4. 校验
- [√] 4.1 本地构建并启动容器，确认能直接进入 Web API 模式
- [√] 4.2 YAML 解析校验（PyYAML）
