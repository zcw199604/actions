# workflows

## 目的
定义与维护仓库的 GitHub Actions 工作流入口，覆盖手动触发与定时执行两类场景，并提供可复用模板。

## 模块概述
- **职责:** 组织 `.github/workflows/` 文件；规范权限、触发方式、输入参数、并发策略与日志输出
- **状态:** ✅稳定
- **最后更新:** 2026-01-21

## 规范

### 需求: 手动触发与定时触发
**模块:** workflows
需要提供 `workflow_dispatch` 与 `schedule` 的示例工作流，并包含 bash / Python / Node.js 的执行示例。

#### 场景: 手动触发
需支持输入参数（可选），并能在 Actions 页面一键运行与查看结果。
- 能在 Actions 页面选择 workflow 并执行
- Job 运行成功/失败清晰可见

#### 场景: 定时触发
需支持 cron 配置，并能在固定时间自动执行。
- 按 cron 定时运行
- 出错时便于定位与重试

### 需求: 镜像同步（上游 → TCR/ACR）
**模块:** workflows
需要提供镜像同步工作流，用于将上游镜像同步到腾讯云 TCR 与阿里云 ACR，供云函数镜像运行使用。

#### 场景: 同步 `tiktok-downloader` latest（linux/amd64）
- 拉取 `joeanamier/tiktok-downloader:latest`（仅 `linux/amd64`）
- 基于 `docker/tiktok-downloader-webapi/` 构建一层“Web API 包装镜像”（启动自动准备 Volume 配置并进入 Web API，默认绑定 `0.0.0.0`）
- 推送到 `TCR_REGISTRY/TCR_REPOSITORY_TIKTOK_DOWNLOADER:latest`（兼容旧的 `TCR_REPOSITORY`）
- 推送到 `ACR_REGISTRY/ACR_REPOSITORY_TIKTOK_DOWNLOADER:latest`（兼容旧的 `ACR_REPOSITORY`）
- 若目标仓库 `:latest` 的 `org.opencontainers.image.base.digest` 与源镜像 digest 一致，且 `com.helloagents.wrapper.sha` 与当前包装层一致，则跳过对应 push（避免重复推送）
- 目标仓库支持仅启用 TCR 或仅启用 ACR（未配置的一方自动跳过）

#### 场景: 同步 `face-masker` latest（linux/amd64）
- 拉取 `a7413498/face-masker:latest`（仅 `linux/amd64`）
- 推送到 `TCR_REGISTRY/TCR_REPOSITORY_FACE_MASKER:latest`
- 推送到 `ACR_REGISTRY/ACR_REPOSITORY_FACE_MASKER:latest`
- 若目标仓库 `:latest` 与源镜像 digest/ID 一致，则跳过对应 push（避免重复推送）
- 目标仓库支持仅启用 TCR 或仅启用 ACR（未配置的一方自动跳过）

#### 场景: 失败自动告警
- 同步失败自动创建/更新 Issue，并附带 run 链接
- 默认最小权限，仅授予 `issues: write`

### 需求: 版本更新监控（GitHub Releases）
**模块:** workflows
需要提供版本监控工作流，用于检查多个 GitHub 仓库是否发布了新的 Release，并将结果汇总到一个固定 Issue。

#### 场景: 通过变量配置监控列表
- 使用 `RELEASE_WATCH_REPOS`（仓库 Variables）配置多个 `owner/repo`
- 支持逗号/换行分隔，自动去重与忽略空项

#### 场景: 固定 Issue 汇总与去重
- 固定 Issue 标题：`版本更新监控`
- Issue body 内保存状态 JSON，用于避免重复提醒

## 依赖
- scripts

## 变更历史
- [202601210110_actions_repo_bootstrap](../../history/2026-01/202601210110_actions_repo_bootstrap/) - 初始化标准模板（手动/定时 workflow 示例）
- [202601210224_sync_image_tiktok_downloader](../../history/2026-01/202601210224_sync_image_tiktok_downloader/) - 新增镜像同步工作流（TCR/ACR）
- [202601210531_sync_image_skip_push](../../history/2026-01/202601210531_sync_image_skip_push/) - 镜像同步：相同 digest/ID 跳过重复 push
- [202601210553_sync_image_optional_registry](../../history/2026-01/202601210553_sync_image_optional_registry/) - 镜像同步：支持仅配置单一仓库目标（TCR/ACR）
- [202601210625_sync_image_face_masker](../../history/2026-01/202601210625_sync_image_face_masker/) - 新增镜像同步工作流（face-masker → TCR/ACR）
- [202601210411_watch_github_releases](../../history/2026-01/202601210411_watch_github_releases/) - 新增多仓库 Release 版本监控工作流
- [202601210825_tiktok_downloader_webapi_wrapper](../../history/2026-01/202601210825_tiktok_downloader_webapi_wrapper/) - tiktok-downloader：推送前构建 Web API 包装镜像（免挂载启动）
