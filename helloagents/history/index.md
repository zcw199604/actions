# 变更历史索引

本文件记录所有已完成变更的索引，便于追溯和查询。

---

## 索引

| 时间戳 | 功能名称 | 类型 | 状态 | 方案包路径 |
|--------|----------|------|------|------------|
| 202601210110 | actions_repo_bootstrap | 功能 | ✅已完成 | [链接](2026-01/202601210110_actions_repo_bootstrap/) |
| 202601210224 | sync_image_tiktok_downloader | 功能 | ✅已完成 | [链接](2026-01/202601210224_sync_image_tiktok_downloader/) |
| 202601210411 | watch_github_releases | 功能 | ✅已完成 | [链接](2026-01/202601210411_watch_github_releases/) |
| 202601210531 | sync_image_skip_push | 优化 | ✅已完成 | [链接](2026-01/202601210531_sync_image_skip_push/) |
| 202601210553 | sync_image_optional_registry | 优化 | ✅已完成 | [链接](2026-01/202601210553_sync_image_optional_registry/) |
| 202601210625 | sync_image_face_masker | 功能 | ✅已完成 | [链接](2026-01/202601210625_sync_image_face_masker/) |
| 202601210825 | tiktok_downloader_webapi_wrapper | 优化 | ✅已完成 | [链接](2026-01/202601210825_tiktok_downloader_webapi_wrapper/) |
| 202601210937 | tiktok_downloader_port_env | 优化 | ✅已完成 | [链接](2026-01/202601210937_tiktok_downloader_port_env/) |

---

## 按月归档

### 2026-01

- [202601210110_actions_repo_bootstrap](2026-01/202601210110_actions_repo_bootstrap/) - 初始化 GitHub Actions 仓库模板（README + workflows + scripts）
- [202601210224_sync_image_tiktok_downloader](2026-01/202601210224_sync_image_tiktok_downloader/) - 同步镜像 joeanamier/tiktok-downloader 到 TCR/ACR
- [202601210411_watch_github_releases](2026-01/202601210411_watch_github_releases/) - 多仓库 GitHub Releases 版本监控（固定 Issue 汇总）
- [202601210531_sync_image_skip_push](2026-01/202601210531_sync_image_skip_push/) - 镜像同步：相同 digest/ID 跳过重复推送
- [202601210553_sync_image_optional_registry](2026-01/202601210553_sync_image_optional_registry/) - 镜像同步：支持仅配置单一仓库目标（TCR/ACR）
- [202601210625_sync_image_face_masker](2026-01/202601210625_sync_image_face_masker/) - 同步镜像 a7413498/face-masker 到 TCR/ACR
- [202601210825_tiktok_downloader_webapi_wrapper](2026-01/202601210825_tiktok_downloader_webapi_wrapper/) - tiktok-downloader：推送前构建 Web API 包装镜像（免挂载启动）
- [202601210937_tiktok_downloader_port_env](2026-01/202601210937_tiktok_downloader_port_env/) - tiktok-downloader：支持通过 PORT 环境变量指定监听端口
