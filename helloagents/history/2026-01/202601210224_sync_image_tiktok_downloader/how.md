# 技术设计: 镜像同步（joeanamier/tiktok-downloader → TCR/ACR）

## 技术方案

### 核心技术
- GitHub Actions（`workflow_dispatch` + `schedule`）
- Docker CLI（`pull/tag/push`）
- `docker/login-action`（安全登录）
- `actions/github-script`（失败创建/复用 Issue）

### 实现要点
- 仅同步 `linux/amd64`：使用 `docker pull --platform linux/amd64`
- 镜像命名通过 Secrets 配置：
  - `TCR_REGISTRY` + `TCR_REPOSITORY`
  - `ACR_REGISTRY` + `ACR_REPOSITORY`
- 定时策略：北京时间 02:00（GitHub cron 使用 UTC，因此表达式为 `0 18 * * *`）
- 并发控制：使用 `concurrency` 避免同一工作流重叠运行
- 失败告警：
  - 以固定标题查找开放 Issue，存在则追加评论
  - 不存在则创建新 Issue

## 架构决策 ADR

<a id="adr-002"></a>
### ADR-002: 使用 Docker CLI 同步镜像
**上下文:** 需要从 Docker Hub 拉取镜像并推送到多个镜像仓库，且仅需 `linux/amd64`。
**决策:** 使用 GitHub Runner 自带 Docker，通过 `docker pull/tag/push` 完成镜像同步；使用 `docker/login-action` 安全登录。
**理由:** 依赖少、可读性强、易维护；满足单架构同步需求。
**替代方案:** `skopeo copy` / `crane copy` → 拒绝原因: 需要额外安装工具或引入更多依赖，不利于仓库初期保持简单。
**影响:** 如后续需要多架构同步，可再引入 buildx 或 skopeo 扩展。

## 安全与性能
- **安全:**
  - 不在命令中输出敏感信息
  - workflow 明确声明 `permissions`，仅对 Issues 写入授权
  - 依赖 actions 使用稳定版本，并由 dependabot 提醒更新
- **性能:**
  - 仅拉取单架构镜像，减少下载与推送体积

## 测试与部署
- **测试:** 通过 `workflow_dispatch` 手动触发验证；可用 `force_failure`（可选）验证失败告警路径
- **部署:** 无（该仓库仅提供工作流与脚本）
