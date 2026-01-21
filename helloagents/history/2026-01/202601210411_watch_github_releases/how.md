# 技术设计: GitHub Release 版本监控（多仓库）

## 技术方案

### 核心技术
- GitHub Actions（`workflow_dispatch` + `schedule`）
- GitHub REST API（获取仓库最新 Release）
- `actions/github-script`（统一实现：读取配置、查询 Release、创建/更新 Issue、维护状态）

### 实现要点
- 配置读取：
  - 通过环境变量 `RELEASE_WATCH_REPOS` 读取监控列表（逗号/换行分隔）
  - 手动触发可选支持输入覆盖（为空则使用环境变量）
- Release 获取：以 GitHub Releases 为准（默认忽略 prerelease/draft）
  - 优先使用 `repos.getLatestRelease`
  - 若 404 或异常，则回退到 `repos.listReleases` 并筛选首个非 prerelease/draft
- Issue 作为 SSOT（运行态）：
  - 固定标题：`版本更新监控`
  - body 里维护状态 JSON（仓库 → 上次 tag/id/published_at）
  - 运行结束更新表格与状态区块
- 并发控制：使用 `concurrency` 避免同一工作流重叠运行
- 定时策略：北京时间 02:00（UTC 表达为 `0 18 * * *`）

## 架构决策 ADR

<a id="adr-003"></a>
### ADR-003: 使用固定 Issue 的 body 存储监控状态
**上下文:** 需要跨运行保存“上次已知版本”，且不希望写入仓库文件（避免 `contents: write` 与自动 commit）。
**决策:** 使用一个固定 Issue 的 body 作为状态存储（JSON 区块），同时作为展示面板。
**理由:** 权限最小化（仅 `issues: write`）；状态可审计、可读；无需写入仓库与引入额外存储。
**替代方案:** 在仓库中保存 `state.json` 并自动提交 → 拒绝原因: 需要 `contents: write`，会产生额外 commit 与潜在冲突。
**影响:** 若 Issue 被误编辑导致状态损坏，需具备自动恢复逻辑。

## 安全与性能
- **安全:**
  - workflow 显式声明最小权限：`contents: read`、`issues: write`
  - 不依赖 Secrets；监控配置使用仓库变量/环境变量
- **性能:**
  - 仓库数量通常较小；使用分页与必要的 API 调用

## 测试与部署
- **测试:** 通过 `workflow_dispatch` 手动运行；可先配置少量仓库验证
- **部署:** 无（仅新增工作流与文档）
