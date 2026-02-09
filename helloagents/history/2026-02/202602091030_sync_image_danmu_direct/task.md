# 任务清单: danmu-api 镜像同步移除包装层（改为直接同步上游镜像）

目录: `helloagents/history/2026-02/202602091030_sync_image_danmu_direct/`

---

## 1. workflows
- [√] 1.1 更新 `.github/workflows/sync-danmu.yml`：移除 `danmu-api-wrapper` 构建与 Smoke Test
- [√] 1.2 保留 TCR/ACR 可选启用逻辑，改为直接推送 `logvar/danmu-api:latest`
- [√] 1.3 使用源镜像 ID 与目标镜像 ID 比对，重复时跳过推送

## 2. 包装层清理
- [√] 2.1 删除 `docker/danmu-api-wrapper/Dockerfile`
- [√] 2.2 删除 `docker/danmu-api-wrapper/patch_server_port.js`

## 3. 文档与知识库同步
- [√] 3.1 更新 `README.md`：将 danmu-api 改为“直接同步”说明
- [√] 3.2 更新 `helloagents/wiki/modules/workflows.md`：同步 danmu-api 场景描述与变更历史
- [√] 3.3 更新 `helloagents/CHANGELOG.md`：记录 danmu-api 移除包装层
- [√] 3.4 更新 `helloagents/history/index.md`：登记本次变更索引

## 4. 校验
- [√] 4.1 通过 `git diff` 人工校验改动范围
- [√] 4.2 通过 `rg` 校验当前主流程已不再引用 `docker/danmu-api-wrapper`

## 5. 发布
- [-] 5.1 如需发布：提交并推送到 `origin/main`（本仓库默认不自动执行）
  > 备注: 按默认约定不自动提交/推送；如需要我可以补充建议的提交信息与命令。
