# Changelog

本文件记录项目所有重要变更。
格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/),
版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

### 新增
- 初始化知识库结构（`helloagents/`）
- 新增示例工作流（手动触发/定时触发）
- 新增镜像同步工作流（`joeanamier/tiktok-downloader:latest` → TCR/ACR）
- 新增 GitHub Releases 多仓库版本监控工作流（固定 Issue 去重）
- 新增 bash / Python / Node.js 脚本示例（`scripts/`）
- 新增仓库基础配置（`.editorconfig`、`.gitignore`、`.gitattributes`、dependabot）
- 完善 README（中文）

### 变更
- 镜像同步工作流增加 digest/ID 对比，相同则跳过 push
