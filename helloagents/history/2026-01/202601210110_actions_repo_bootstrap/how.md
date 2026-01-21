# 技术设计: GitHub Actions 仓库初始化（标准模板）

## 技术方案

### 核心技术
- GitHub Actions 工作流（YAML）
- 第三方 actions：`actions/checkout`、`actions/setup-python`、`actions/setup-node`
- bash / Python / Node.js 脚本（无额外依赖的最小示例）

### 实现要点
- 采用清晰的目录结构：工作流放在 `.github/workflows/`，脚本放在 `scripts/`
- 为手动触发与定时触发各提供一个示例 workflow，内容尽量可复制复用
- 默认最小权限：workflow 内显式声明 `permissions`，仅在需要写入时再提升
- 定时任务增加并发控制（`concurrency`）避免同一任务重叠执行
- 脚本统一约定：输出摘要信息；失败返回非 0；避免输出敏感信息

## 架构决策 ADR

<a id="adr-001"></a>
### ADR-001: 以“workflow 模板 + scripts 示例”作为仓库核心
**上下文:** 该仓库用于执行多种自动化任务，新增 workflow 的频率可能较高，需要可复制的模板与统一规范。
**决策:** 提供两类 workflow 模板（手动/定时）+ 三种脚本示例（bash/Python/Node），作为最小可用的起点；暂不引入复杂的可复用 composite action 结构。
**理由:** 模板更直观、维护成本低；脚本示例可本地调试；符合“先落地，再演进”的节奏。
**替代方案:** 直接建设 `.github/actions/` composite actions → 拒绝原因: 初期会增加结构复杂度与维护门槛。
**影响:** 后续如出现大量重复步骤，可在不破坏现有结构的前提下逐步引入 composite actions。

## 安全与性能
- **安全:**
  - workflow 采用最小权限；避免使用不必要的写权限
  - 禁止在仓库中存放明文密钥；敏感信息使用 GitHub Secrets
  - 第三方 actions 使用稳定版本，并通过 dependabot 进行更新提醒
- **性能:**
  - 仅安装必要运行时；脚本示例不引入依赖
  - 定时任务使用并发控制，避免重复消耗 Runner

## 测试与部署
- **测试:**
  - 本地：可运行 bash/Python/Node 脚本进行基本校验
  - 在线：在 GitHub Actions 中手动触发示例 workflow 进行端到端验证
- **部署:** 无（仓库仅提供工作流与脚本模板）
