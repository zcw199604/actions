# tiktok-downloader

## 目的
沉淀与 `tiktok-downloader` / `TikTokDownloader` 相关的使用笔记与常见问题处理流程，便于在本仓库（镜像同步/包装镜像）之外快速查阅。

## 模块概述
- **职责:** 汇总浏览器 Cookie 自动提取方案（免手动复制）、环境准备、常见故障排查与安全建议（基于外部文章整理）
- **状态:** ✅稳定
- **最后更新:** 2026-01-22

## 知识条目: 从浏览器自动提取 Cookie（TikTokDownloader）

> 本条目整理自 CSDN 文章（见“参考”），未对 TikTokDownloader 源码/版本进行二次校验；以项目实际行为与官方文档为准。

### 背景与目标
传统方式通常需要在浏览器开发者工具中手动复制 `document.cookie`，易出现格式错误、过期快、操作繁琐等问题。文章介绍的方案通过读取浏览器本地 Cookie 数据库，实现“一键提取”并写入 TikTokDownloader 配置。

### 原理摘要（文章要点）
- 使用 `rookiepy` 直接访问浏览器本地 Cookie 数据库（按浏览器内核/存储位置适配）。
- 将 Cookie 提取过程尽量控制在内存中，减少明文暴露风险。

### 支持范围（文章信息）
文章提及 v2.3+ 通过 `rookiepy` 支持“12 款主流浏览器”，示例表格明确列出：
- Chrome / Edge / Brave / Opera / Vivaldi（Chromium）
- Firefox / LibreWolf（Gecko）
- Safari（仅 macOS，WebKit）

> 其余浏览器以工具实际输出的可选列表为准。

### 环境准备（按文章示例）
- 依赖安装：
  - `pip install "rookiepy>=0.2.15" "pyperclip>=1.8.2"`
  - Windows 额外：`pip install "pywin32>=306"`
- Linux（Debian/Ubuntu）额外依赖（文章示例）：`libsecret-1-dev`

### 3 种提取方式（按文章示例）

#### 方式 1：终端交互模式（更适合手动操作）
1. 启动 TikTokDownloader
2. 进入“Cookie 管理”
3. 选择“从浏览器自动提取”，再选择浏览器

#### 方式 2：命令行参数模式（更适合脚本/自动化）
```bash
# 默认平台（文章示例）
python main.py --cookie-browser Chrome

# TikTok 平台（文章示例）
python main.py --cookie-browser Firefox --platform tiktok
```

#### 方式 3：代码调用模式（更适合二次开发集成）
文章给出了通过项目内 Cookie/Browser 相关模块封装调用的思路；也可以直接用 `rookiepy` 获取指定域名 Cookie（示例）：
```python
from rookiepy import chrome

cookies = chrome(domains=["tiktok.com"])
```

### 常见问题排查（文章摘要）
1. Windows 权限不足：以管理员权限运行终端/程序后再提取。
2. 浏览器未完全关闭：退出浏览器及后台进程后重试。
3. Cookie DB 锁定：按浏览器/系统定位锁文件并处理后重试（注意数据风险）。
4. 版本不兼容：升级 `rookiepy` 后重试。
5. 多用户配置冲突：指定浏览器 profile 再提取。
6. 安全软件拦截：将 Python 进程加入白名单或临时关闭实时防护。
7. 系统时间不同步：同步系统时间后再验证。

### 安全与隐私建议（文章摘要）
- Cookie 属于登录凭证，避免写入日志/公开分享；尽量限制本地配置文件的可读权限。
- 使用专用浏览器 Profile 访问 TikTok/抖音，减少与日常环境的账号/配置混用。
- 定期清理/更换敏感 Cookie（文章示例提及 `s_v_web_id`、`ttwid` 等）。

## 本仓库：Web API 包装镜像（不自动获取 Cookie）

本仓库对 `joeanamier/tiktok-downloader:latest` 构建了额外的 Web API 包装镜像（见 `.github/workflows/sync-tiktok-downloader.yml` 与 `docker/tiktok-downloader-webapi/`）。

该包装镜像会在启动时自动准备 `Volume/settings.json` 与 `DouK-Downloader.db`，并将 Web API 绑定地址调整为 `0.0.0.0` 以便容器/云函数对外暴露端口。

为避免镜像体积膨胀（Chromium/Playwright 依赖过大），包装镜像不再在启动时自动获取抖音 Cookie；如需 Cookie 请自行在 `Volume/settings.json` 配置。

此外，包装镜像在构建阶段会为 Web API 注入单页分页接口 `/douyin/account/page`（见 `docker/tiktok-downloader-webapi/patch_main_server.py`），便于远程 UI 做游标分页。

## 依赖
- workflows（本仓库包含 `tiktok-downloader` 镜像同步与包装镜像相关工作流）

## 变更历史
- [202601221316_tiktokdownloader_cookie_auto_extract](../../history/2026-01/202601221316_tiktokdownloader_cookie_auto_extract/) - 新增“浏览器自动提取 Cookie”知识条目
- [202601221404_tiktok_downloader_auto_douyin_cookie](../../history/2026-01/202601221404_tiktok_downloader_auto_douyin_cookie/) - 包装镜像启动时自动获取抖音 Cookie（headless Chromium + TTL；后续为降低镜像体积已移除）

## 参考
- CSDN: https://blog.csdn.net/gitblog_00173/article/details/151244563
- GitHub: https://github.com/JoeanAmier/TikTokDownloader
- GitCode（文章引用）: https://gitcode.com/GitHub_Trending/ti/TikTokDownloader
