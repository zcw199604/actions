# 任务清单: 镜像同步（logvar/danmu-api → TCR/ACR，默认端口改为9000）

目录: `helloagents/history/2026-02/202602081030_sync_image_danmu_api_wrapper/`

---

## 1. workflows
- [√] 1.1 新增 `.github/workflows/sync-danmu.yml`：支持手动+定时触发，同步 `logvar/danmu-api:latest`（`linux/amd64`）到 TCR/ACR
- [√] 1.2 镜像同步流程改为包装模式：构建 `danmu-api-wrapper` 后再推送
- [√] 1.3 新增 Smoke Test：验证容器通过 `9000` 端口可访问首页

## 2. 包装层
- [√] 2.1 新增 `docker/danmu-api-wrapper/Dockerfile`
- [√] 2.2 新增 `docker/danmu-api-wrapper/patch_server_port.js`，将 `mainServer.listen(9321, ...)` 替换为 `mainServer.listen(9000, ...)`

## 3. 文档更新
- [√] 3.1 更新 `README.md`：补充 danmu-api 同步工作流、Secrets 配置与端口包装说明
- [√] 3.2 更新 `helloagents/wiki/modules/workflows.md`：补充 danmu-api 场景与变更历史
- [√] 3.3 更新 `helloagents/CHANGELOG.md`：记录新增工作流与端口包装变更
- [√] 3.4 更新 `helloagents/history/index.md`：登记本次变更索引

## 4. 校验
- [√] 4.1 通过 `node` 执行端口补丁脚本语法校验
- [√] 4.2 通过 `git diff` 检查改动范围

## 5. 发布
- [-] 5.1 如需发布：提交并推送到 `origin/main`（本仓库默认不自动执行）
  > 备注: 按默认约定不自动提交/推送；如需要我可以补充建议的提交信息与命令。
