# Changelog

本文件记录项目所有重要变更。
格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/),
版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

### 新增
- 初始化知识库结构（`helloagents/`）
- 新增示例工作流（手动触发/定时触发）
- 新增镜像同步工作流（`joeanamier/tiktok-downloader:latest` → TCR/ACR）
- 新增镜像同步工作流（`a7413498/face-masker:latest` → TCR/ACR）
- 新增 GitHub Releases 多仓库版本监控工作流（固定 Issue 去重）
- 新增 bash / Python / Node.js 脚本示例（`scripts/`）
- 新增仓库基础配置（`.editorconfig`、`.gitignore`、`.gitattributes`、dependabot）
- 完善 README（中文）
- 新增 `tiktok-downloader` 知识库条目：TikTokDownloader 从浏览器自动提取 Cookie（免手动复制）

### 变更
- 镜像同步工作流增加 digest/ID 对比，相同则跳过 push
- 镜像同步工作流支持仅配置 TCR 或 ACR（未配置的一方自动跳过）
- 镜像同步工作流支持按镜像拆分仓库 Secrets（避免多镜像同步时仓库名冲突）
- tiktok-downloader 镜像同步在推送前增加 Web API 包装层（启动自动准备 Volume 配置并跳过免责声明交互）
- tiktok-downloader Web API 包装镜像支持通过 `PORT` 环境变量设置监听端口
- tiktok-downloader Web API 包装镜像启动时自动获取抖音 Cookie（headless Chromium + TTL）
  - ⚠️ EHRB: 敏感信息（Cookie）落盘 - 用户已确认风险
- tiktok-downloader Web API 包装镜像将 `/douyin/account/page` 补丁改为 COPY + RUN 脚本方式，避免未启用 buildx/BuildKit 时补丁静默失效
