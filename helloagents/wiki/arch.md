# 架构设计

## 总体架构

```mermaid
flowchart TD
    A[GitHub 事件触发] --> B[Workflow]
    B --> C[第三方 Actions]
    B --> D[脚本：bash / Python / Node.js]
    D --> E[产出：日志 / 产物 / Issue / PR / Release（按需）]
```

## 技术栈
- **自动化:** GitHub Actions（YAML）
- **脚本:** bash / Python / Node.js

## 核心流程

```mermaid
sequenceDiagram
    participant U as 用户/计划任务
    participant GH as GitHub Actions
    participant WF as Workflow
    U->>GH: 触发 workflow_dispatch / schedule
    GH->>WF: 分配 Runner 并执行 Job
    WF->>WF: Checkout / Setup Runtime
    WF->>WF: 运行脚本或第三方 action
    WF-->>GH: 输出日志与结果
```

## 重大架构决策
完整的ADR存储在各变更的how.md中，本章节提供索引。

| adr_id | title | date | status | affected_modules | details |
|--------|-------|------|--------|------------------|---------|
| ADR-001 | 以“workflow 模板 + scripts 示例”作为仓库核心 | 2026-01-21 | ✅已采纳 | workflows, scripts, docs | [链接](../history/2026-01/202601210110_actions_repo_bootstrap/how.md#adr-001) |
