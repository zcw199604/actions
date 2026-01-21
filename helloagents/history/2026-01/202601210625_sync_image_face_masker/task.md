# 任务清单: 镜像同步（a7413498/face-masker → TCR/ACR）

目录: `helloagents/history/2026-01/202601210625_sync_image_face_masker/`

---

## 1. workflows
- [√] 1.1 新增 `.github/workflows/sync-face-masker.yml`：支持手动+定时触发，同步 `a7413498/face-masker:latest`（`linux/amd64`）到 TCR/ACR，并在失败时创建/更新 Issue
- [√] 1.2 更新 `.github/workflows/sync-tiktok-downloader.yml`：支持使用镜像专用的仓库 Secrets（避免多镜像同步时仓库名冲突）

## 2. 文档更新
- [√] 2.1 更新 `README.md`：补充 face-masker 同步工作流说明与 Secrets 配置
- [√] 2.2 更新 `helloagents/wiki/modules/workflows.md`：补充 face-masker 同步场景与 Secrets 约定
- [√] 2.3 更新 `helloagents/CHANGELOG.md`：记录新增与调整

## 3. 校验
- [√] 3.1 YAML 解析校验（PyYAML）

## 4. 发布
- [-] 4.1 如需发布：提交并推送到 `origin/main`（本仓库默认不自动执行）
  > 备注: 按默认约定不自动提交/推送；如需要我可以补充建议的提交信息与命令。
