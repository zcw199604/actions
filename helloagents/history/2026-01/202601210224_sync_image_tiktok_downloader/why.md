# 变更提案: 镜像同步（joeanamier/tiktok-downloader → TCR/ACR）

## 需求背景
需要将 Docker Hub 上的 `joeanamier/tiktok-downloader:latest`（仅 `linux/amd64`）定时与手动同步到腾讯云 TCR 与阿里云 ACR，用于云函数镜像运行环境，避免跨镜像源拉取不稳定，并统一镜像来源与更新节奏。

## 产品分析

### 目标用户与场景
- **用户群体:** 云函数/容器镜像使用者、仓库维护者
- **使用场景:** 每日自动同步最新镜像；当紧急需要更新时手动触发同步
- **核心痛点:** 上游镜像源拉取不稳定或受限；多云环境需要分别准备镜像

### 价值主张与成功指标
- **价值主张:** 一次配置，自动保持 TCR/ACR 镜像与上游一致，并在失败时自动告警（创建 Issue）
- **成功指标:**
  - 每日北京时间 02:00 自动执行同步
  - 同步成功后，TCR/ACR 中目标镜像的 `latest` 更新为上游最新
  - 同步失败时自动创建（或复用）Issue，包含运行链接便于排查

### 人文关怀
不在仓库中存放明文账号或密钥；镜像同步默认最小权限，仅对 Issue 写入授权。

## 变更内容
1. 新增镜像同步工作流：支持 `workflow_dispatch`（手动）+ `schedule`（定时）
2. 使用 GitHub Secrets 存放 TCR/ACR 鉴权与目标仓库信息，避免敏感信息泄露
3. 失败自动创建 Issue（避免重复创建同标题 Issue）
4. 更新 README，补充同步工作流说明与 Secrets 配置指引

## 影响范围
- **模块:** workflows、docs
- **文件:** `.github/workflows/*`、`README.md`、（可选）脚本文件
- **API:** 无
- **数据:** 无

## 核心场景

### 需求: 手动镜像同步
**模块:** workflows
提供可在 Actions 页面手动触发的镜像同步工作流。

#### 场景: 一键同步 latest
用户手动触发后，完成拉取上游 `latest` 并推送至 TCR 与 ACR（仅 `linux/amd64`）。
- 能在 Actions 页面一键运行
- 输出同步到的目标镜像地址与摘要信息

### 需求: 定时镜像同步
**模块:** workflows
提供每日定时同步，按北京时间 02:00 执行。

#### 场景: 每日自动同步
无需人工介入，定时同步并具备并发控制避免重复运行。
- 每日 02:00（UTC+8）自动触发
- 同一时间不会重叠执行

### 需求: 失败告警
**模块:** workflows
同步失败时自动创建 Issue（或复用同标题开放 Issue 并追加评论）。

#### 场景: 自动创建 Issue
失败后自动创建 Issue，并包含运行链接便于排查与重试。
- Issue 标题固定，避免重复创建
- Body/Comment 包含 run URL 与关键信息

### 需求: 配置说明
**模块:** docs
README 提供 Secrets 配置与目标镜像命名规则说明。

#### 场景: 按文档配置并跑通
维护者按 README 配置 secrets 后即可跑通镜像同步。
- 清晰列出 secrets 名称与示例格式
- 说明 cron 的 UTC 换算

## 风险评估
- **风险:** Secrets 泄露或日志输出敏感信息
- **缓解:** 使用 `docker/login-action`；避免打印敏感值；仅授予 `issues: write` 与 `contents: read`

