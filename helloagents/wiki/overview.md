# actions

> 本文件包含项目级别的核心信息。详细的模块文档见 `modules/` 目录。

---

## 1. 项目概述

### 目标与背景
该仓库用于集中管理与执行多种 GitHub Actions 工作流，支持手动触发与定时任务，并可在工作流中组合第三方 action 与自定义脚本（bash / Python / Node.js）。

### 范围
- **范围内:** 常用工作流模板、可复用脚本、执行说明与约定、最小权限与安全基线
- **范围外:** 生产系统直接运维（需另行授权与审计）、在仓库中存放明文密钥

### 干系人
- **负责人:** 仓库维护者

---

## 2. 模块索引

| 模块名称 | 职责 | 状态 | 文档 |
|---------|------|------|------|
| workflows | 管理 `.github/workflows/` 下的工作流入口与约定 | ✅稳定 | [链接](modules/workflows.md) |
| scripts | 存放工作流调用的 bash/Python/Node.js 脚本 | ✅稳定 | [链接](modules/scripts.md) |
| docs | 仓库级文档（README、使用与贡献说明） | ✅稳定 | [链接](modules/docs.md) |

---

## 3. 快速链接
- [技术约定](../project.md)
- [架构设计](arch.md)
- [API 手册](api.md)
- [数据模型](data.md)
- [变更历史](../history/index.md)
