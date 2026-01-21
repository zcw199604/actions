# actions

用于集中管理并执行 GitHub Actions 工作流（手动触发 / 定时任务），并提供可直接复制的模板与 bash / Python / Node.js 脚本示例。

## 快速开始

### 1) 手动触发（workflow_dispatch）

1. 进入仓库的 Actions 页面
2. 选择 `手动示例 - 调用脚本`
3. 点击 `Run workflow`，按需填写输入参数并执行

可用输入参数：
- `name`：传递给脚本的名称（默认 `world`）
- `runtime`：选择运行 `bash/python/node/all`
- `force_failure`：强制失败（用于演示失败场景）

### 2) 定时触发（schedule）

`定时示例 - 每日运行` 使用 `cron` 定时触发（**UTC 时区**）。如需调整频率，修改 `.github/workflows/scheduled.yml` 中的 `cron`。

## 目录结构

```text
.
├── .github/
│   ├── dependabot.yml
│   └── workflows/
│       ├── manual.yml
│       └── scheduled.yml
├── scripts/
│   ├── hello.js
│   ├── hello.py
│   └── hello.sh
└── helloagents/                 # 项目知识库（SSOT）
    ├── CHANGELOG.md
    ├── project.md
    ├── wiki/
    ├── plan/
    └── history/
```

## 脚本示例（本地运行）

```bash
bash scripts/hello.sh --name world
python scripts/hello.py --name world
node scripts/hello.js --name world
```

强制失败（用于验证失败路径）：

```bash
bash scripts/hello.sh --name world --fail
python scripts/hello.py --name world --fail
node scripts/hello.js --name world --fail
```

## 如何新增一个 workflow（推荐流程）

1. 在 `.github/workflows/` 下复制现有示例（`manual.yml` 或 `scheduled.yml`）
2. 调整触发方式：
   - 手动触发：`on.workflow_dispatch`
   - 定时触发：`on.schedule`（cron 为 UTC）
3. 明确权限（最小权限原则）：
   - 默认建议 `permissions: { contents: read }`
   - 仅在需要写入仓库/PR/Issue 等时再提升权限，并写清原因
4. 按需引入运行时：
   - Python：`actions/setup-python`
   - Node.js：`actions/setup-node`
5. 复用脚本与第三方 action：
   - 复用脚本：放入 `scripts/`，避免 YAML 里堆积复杂逻辑
   - 第三方 action：优先选维护活跃项目，建议固定到主版本（或更严格地固定到 commit SHA）

## Secrets 与安全建议

- 禁止将密钥/令牌明文提交到仓库；使用 GitHub Secrets（`Settings → Secrets and variables → Actions`）
- 避免在日志中输出敏感信息（包括 `echo ${{ secrets.X }}`）
- 定时任务建议设置 `concurrency`，避免任务重叠执行
- 已启用 dependabot（`.github/dependabot.yml`）用于提醒 GitHub Actions 依赖更新

## 镜像同步（云函数镜像）

工作流：`.github/workflows/sync-tiktok-downloader.yml`

- **源镜像:** `joeanamier/tiktok-downloader:latest`
- **平台:** `linux/amd64`
- **目标:** 同步并推送到腾讯云 TCR 与阿里云 ACR（均推送 `:latest`）

### 需要配置的 Secrets

在仓库 `Settings → Secrets and variables → Actions` 中新增以下 secrets：

至少配置 **腾讯云 TCR** 或 **阿里云 ACR** 其中一套（两套都配也可以）。未配置的一方会自动跳过推送。

腾讯云 TCR（可选启用）：
- `TCR_REGISTRY`：例如 `ccr.ccs.tencentyun.com`
- `TCR_USERNAME`
- `TCR_PASSWORD`
- `TCR_REPOSITORY`：例如 `namespace/tiktok-downloader`

阿里云 ACR（可选启用）：
- `ACR_REGISTRY`：例如 `registry.cn-hangzhou.aliyuncs.com`
- `ACR_USERNAME`
- `ACR_PASSWORD`
- `ACR_REPOSITORY`：例如 `namespace/tiktok-downloader`

最终推送目标为：
- `TCR_REGISTRY/TCR_REPOSITORY:latest`
- `ACR_REGISTRY/ACR_REPOSITORY:latest`

### 触发方式

- **手动触发:** Actions → `同步镜像 - tiktok-downloader`
- **定时触发:** 每天北京时间 02:00（GitHub cron 使用 UTC，对应 `0 18 * * *`）

### 失败告警

同步失败会自动创建/更新 Issue（标题固定）：`镜像同步失败: tiktok-downloader`，并附带运行链接用于排查。

## 版本更新监控（GitHub Releases）

工作流：`.github/workflows/watch-github-releases.yml`

用于监控多个 `owner/repo` 是否发布了新的 GitHub Release，并将结果汇总到一个固定 Issue（标题：`版本更新监控`）。该 Issue 的 body 同时保存“上次已知版本”状态，用于去重提醒。

### 配置方式（推荐使用 Variables）

在仓库 `Settings → Secrets and variables → Actions → Variables` 中新增：

- `RELEASE_WATCH_REPOS`：逗号或换行分隔的 `owner/repo` 列表  
  例如：`cli/cli,hashicorp/terraform`

### 触发方式

- **手动触发:** Actions → `版本更新监控 - GitHub Releases`（可在输入框覆盖 repos；留空则使用 `RELEASE_WATCH_REPOS`）
- **定时触发:** 每天北京时间 02:00（GitHub cron 使用 UTC，对应 `0 18 * * *`）

### 输出与状态

- 会创建/更新一个固定 Issue：`版本更新监控`
- Issue 内的状态区块标记为 `RELEASE_WATCH_STATE_START/END`，请勿手动编辑（损坏会自动重建）

## License

当前仓库尚未添加许可证文件。如需对外开源使用，建议补充 `LICENSE` 并在 README 中声明。
