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

## License

当前仓库尚未添加许可证文件。如需对外开源使用，建议补充 `LICENSE` 并在 README 中声明。
