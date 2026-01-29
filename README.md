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

工作流：
- `.github/workflows/sync-tiktok-downloader.yml`
- `.github/workflows/sync-face-masker.yml`

- **平台:** `linux/amd64`
- **目标:** 同步并推送到腾讯云 TCR 与阿里云 ACR（均推送 `:latest`）

### 源镜像
- `joeanamier/tiktok-downloader:latest`（tiktok-downloader：同步时会额外构建一层“Web API 包装镜像”）
- `a7413498/face-masker:latest`

### tiktok-downloader（Web API 包装镜像）说明

为适配云函数“免挂载即启动”的场景，`tiktok-downloader` 在推送到 TCR/ACR 前会基于上游镜像增加一层包装：
- 启动时自动准备 `/app/Volume/settings.json`（默认 `run_command=7`，自动进入 Web API）
- 启动时自动准备 `/app/Volume/DouK-Downloader.db`（写入 `Disclaimer=1`，跳过首次免责声明交互）
- 启动时自动尝试访问抖音主页并获取 Cookie（headless Chromium），写入 `/app/Volume/settings.json` 的 `cookie` 字段
  - 仅在 `cookie` 为空或“自动获取 Cookie 的时间戳”超过有效期时执行（避免每次启动都访问）
  - 时间戳文件：`/app/Volume/douyin_cookie_saved_at.txt`
- 默认将 Web API 绑定地址调整为 `0.0.0.0`（便于容器/云函数对外暴露端口，默认端口 `5555`）

可选环境变量：
- `RUN_COMMAND`：菜单编号（默认 `7`；若上游版本 Web API 变为 `8`，可改为 `8`）
- `VOLUME_DIR`：配置目录（默认 `/app/Volume`，一般无需修改）
- `PORT`：Web API 监听端口（默认 `5555`；云函数/平台要求监听 `$PORT` 时可设置该变量）
- `DOUYIN_COOKIE_TTL_HOURS`：自动获取的抖音 Cookie 有效期（小时，默认 `6`；到期会再次访问抖音刷新）

### 需要配置的 Secrets

在仓库 `Settings → Secrets and variables → Actions` 中新增以下 secrets：

至少配置 **腾讯云 TCR** 或 **阿里云 ACR** 其中一套（两套都配也可以）。未配置的一方会自动跳过推送。

公共 Secrets（两套 workflow 共用）：
腾讯云 TCR（可选启用）：
- `TCR_REGISTRY`：例如 `ccr.ccs.tencentyun.com`
- `TCR_USERNAME`
- `TCR_PASSWORD`

阿里云 ACR（可选启用）：
- `ACR_REGISTRY`：例如 `registry.cn-hangzhou.aliyuncs.com`
- `ACR_USERNAME`
- `ACR_PASSWORD`

镜像仓库 Secrets（建议按镜像拆分，避免多镜像同步时仓库名冲突）：

tiktok-downloader：
- `TCR_REPOSITORY_TIKTOK_DOWNLOADER`：例如 `namespace/tiktok-downloader`（兼容旧的 `TCR_REPOSITORY`）
- `ACR_REPOSITORY_TIKTOK_DOWNLOADER`：例如 `namespace/tiktok-downloader`（兼容旧的 `ACR_REPOSITORY`）

face-masker：
- `TCR_REPOSITORY_FACE_MASKER`：例如 `namespace/face-masker`
- `ACR_REPOSITORY_FACE_MASKER`：例如 `namespace/face-masker`

最终推送目标为：
- tiktok-downloader:
  - `TCR_REGISTRY/TCR_REPOSITORY_TIKTOK_DOWNLOADER:latest`
  - `ACR_REGISTRY/ACR_REPOSITORY_TIKTOK_DOWNLOADER:latest`
- face-masker:
  - `TCR_REGISTRY/TCR_REPOSITORY_FACE_MASKER:latest`
  - `ACR_REGISTRY/ACR_REPOSITORY_FACE_MASKER:latest`

### 触发方式

- **手动触发:** Actions → `同步镜像 - tiktok-downloader` / `同步镜像 - face-masker`
- **定时触发:** 每天北京时间 02:00（GitHub cron 使用 UTC，对应 `0 18 * * *`）

### 失败告警

同步失败会自动创建/更新 Issue（标题固定），并附带运行链接用于排查：
- `镜像同步失败: tiktok-downloader`
- `镜像同步失败: face-masker`

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
