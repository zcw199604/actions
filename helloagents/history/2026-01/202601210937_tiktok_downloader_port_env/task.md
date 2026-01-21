# 任务清单: tiktok-downloader 支持 PORT 环境变量端口

目录: `helloagents/history/2026-01/202601210937_tiktok_downloader_port_env/`

---

## 1. 包装镜像
- [√] 1.1 更新 `docker/tiktok-downloader-webapi/entrypoint.sh`：读取 `PORT`，启动前写入 `SERVER_PORT`

## 2. 文档与知识库
- [√] 2.1 更新 `README.md`：补充 `PORT` 环境变量说明
- [√] 2.2 更新 `helloagents/CHANGELOG.md`：记录该变更

## 3. 校验
- [√] 3.1 本地启动容器（`PORT=xxxx`），确认 `/docs` 可访问
