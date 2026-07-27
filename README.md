# Reading Archive · Between the Spines

> 基于书架实拍图片与视频，识别整理的中文图书清单，并复刻「Between the Spines」交互式图书展示页面。

本仓库收录了一次完整 AI 协助任务的**全部对话产物与原始资产**：用户上传的书架照片、设计参考视频、AI 识别的书籍元数据、以及据此构建的网页展示作品。

---

## 目录结构

```
reading-archive-between-the-spines/
├── README.md                       # 本文件（含完整任务记录）
├── push.sh                         # 沙箱内一键推送脚本（重新授权后由 AI 执行）
├── push-with-token.sh              # 接受环境变量 PAT 的推送脚本（用户提供有效 token 时使用）
├── site/
│   ├── bookshelf.html              # 图书展示网站（核心作品）
│   └── books.js                    # 网站数据（33 本书）
├── docs/
│   ├── books_list.md               # 详细书籍清单（表格 + 单本介绍）
│   ├── books_data.json             # 结构化 JSON 数据
│   └── ima_upload_guide.md         # 上传至 ima 知识库的指南
└── assets/
    ├── images/
    │   ├── shelf-01.jpg ~ 04.jpg   # 用户上传的书架实拍图（4 张）
    ├── videos/
    │   ├── bookshelf-source-1.mp4  # 设计参考视频 1（CHAPTER 4 / UPCOMING RELEASES）
    │   └── bookshelf-source-2.mp4  # 设计参考视频 2（Between the Spines 演示）
    └── frames/                     # 视频 2 的关键帧（23 张，设计分析用）
```

---

## 一、任务对话记录

### 阶段 1 · 识别与搜索
- 用户提供 **4 张书架实拍图 + 1 段设计参考视频**，要求识别每本书、网络检索详情、整理成清单。
- 通过 Read 工具查看图片，逐本读取书脊/封面文字；用 ffmpeg 提取视频帧分析设计风格。
- 对每一本能确认书名的书，调用 `WebSearch` 检索豆瓣等来源，获取：书名、作者、译者、出版社、出版年、ISBN、页数、装帧、封面图、简介。
- 用 Python + requests/BeautifulSoup 抓取豆瓣页面，批量提取结构化字段并下载封面 URL。

### 阶段 2 · 清单整理
- 共识别 **33 个条目**：24 本单书 + 2 个系列（《知日》《问学》）+ 1 本暂定（金刚经）+ 6 本因书脊模糊未能完全识别（标注为「待确认」）。
- 输出 `books_list.md`（Markdown 表格 + 详细介绍）与 `books_data.json`（程序可用数据）。
- 已确认的书籍均附豆瓣封面链接与来源位置（图1/2/3/4）。

### 阶段 3 · ima 知识库
- 生成 `ima_upload_guide.md`，说明如何将清单导入用户「图书知识库」。因沙盒无法登录用户 ima 账号，采用手动上传方案。

### 阶段 4 · 网站初版（CHAPTER 4 风格）
- 依据视频 1 设计：浅米色背景、`UPCOMING RELEASES` 大标题、3D 书脊朝前书架、自动平移 + 拖拽交互。
- 文件名：`bookshelf.html` + `books.js`。

### 阶段 5 · 网站重构（Between the Spines 风格）
- 用户补充视频 2，展示更精致的个人读书记录页面。据此**完全重构**：
  - 浅灰蓝渐变背景，`Personal Collection` + `Between the Spines` 衬线标题；
  - 左上 `READING ARCHIVE`、右上 `N Books` 角标、底部 `HOVER TO OPEN`；
  - 书脊朝前竖立成排，**悬停时从左侧翻开露出真实封面**；
  - 全部 33 本（含待确认占位）纳入展示。

### 阶段 6 · 资产归档与 GitHub 发布
- 收集全部图片、视频、文档、网站到本目录结构。
- 初始化本地 git 仓库并提交（36 个文件，commit `58993ad` 与 `7b7f97a`）。
- ✅ **已发布（2026-07-27）**：借助用户提供的具备 `repo` 全权限的 classic PAT，已成功创建公开仓库并推送 `main` 分支（共 4 个提交、38 个文件）。仓库地址：https://github.com/Linqiyu-0921/reading-archive-between-the-spines

---

## 二、识别到的书籍（摘要）

> 完整信息见 `docs/books_list.md` 与 `docs/books_data.json`。

| # | 书名 | 作者 / 编者 | 出版社 | 年份 |
|---|------|------------|--------|------|
| 1 | 寒门子弟上大学 | [美] 安东尼·亚伯拉罕·杰克 / 田雷、孙竞超 译 | 三联书店 | 2021 |
| 2 | 性本恶 | [美] 托马斯·品钦 / 但汉松 译 | 上海译文 | 2020 |
| 8 | 叶雨书衣 | 范用 | 三联书店 | 2007 |
| 9 | 一本杂志和一个时代的体温 | 《新周刊》杂志社 | 漓江出版社 | 2007 |
| 11 | 我们这种叛徒 | [英] 约翰·勒卡雷 / 杨懿晶 译 | 上海译文 | 2015 |
| 12 | 金陵汉诗 | 邓攀 | 南京出版社 | 2019 |
| 13 | 一个中国家庭的餐桌 | [法] 张有敏 / 管非凡 译 | 天津人民 | 2019 |
| 14 | 江村经济 | 费孝通 | 中信 | 2018 |
| 15 | 中国文明与山水世界 | 渠敬东、孙向晨 主编 | 三联书店 | 2021 |
| 16 | 夏志清夏济安书信集 | 王洞 主编 / 季进 编 | 浙江人民 | 2021 |
| 17 | 帕斯卡尔：心灵与理性 | [法] 让-马克·夏特朗 / 丁若汀 译 | 三联书店 | 2021 |
| 19 | 美国山川风物四记 | [美] 艾温·威·蒂尔 | 译林 | 2019 |
| 20 | 正义联盟：世界上最伟大英雄的 12 个故事 | [英] 马克·米勒 等 | 民主与建设 | 2017 |
| 21 | 中国转向内在 | [美] 刘子健 / 赵冬梅 译 | 江苏人民 | 2023 |
| 22 | 克里斯托弗和他的同类 | [美] 克里斯托弗·伊舍伍德 / 陶凌寅 译 | 上海译文 | 2020 |
| 23 | 沙盘游戏疗法 | 申荷永、高岚 | 中国人民大学 | 2011 |
| 24 | 金字塔 | [阿尔巴尼亚] 伊斯梅尔·卡达莱 / 余中先 译 | 浙江文艺 | 2021 |
| 26 | 神明考古学 | 徐颂赞 | 南京大学 | 2021 |
| 27 | 金刚经说什么（暂定） | 南怀瑾 | 东方 | 2022 |
| 28 | 蛮族世界的拼图 | [波] 彼得·柏伽基 / 朱鸿飞 译 | 中国社科 | 2021 |
| 29 | 电影剧作观念选编 | 刘纯羽 | 北京联合 | 2018 |
| 31 | 葡萄酒与雪茄 | [法] 让-皮埃尔·阿罗克斯 / 晋阳 译 | 东方 | 2014 |
| 32 | 与民国相遇 | 唐小兵 | 三联书店 | 2017 |
| 33 | 社会性动物 | [美] 埃利奥特·阿伦森 / 邢占军 译 | 华东师大 | 2007 |
| 4 | 知日（系列） | 苏静 等 | 中信等 | 2011 起 |
| 5 | 问学——思勉青年学术集刊 | 华东师大思勉高研院 编 | 三联书店 | 2015 起 |
| — | ❓ 待确认 ×6 | （图1/2/3/4 中模糊书脊） | — | — |

---

## 三、本地预览

```bash
cd site
python3 -m http.server 8000
# 浏览器打开 http://localhost:8000/bookshelf.html
```

---

## 四、发布到 GitHub（推送说明）

### 已发布 ✅
- 公开仓库：https://github.com/Linqiyu-0921/reading-archive-between-the-spines
- 本地 `main` 分支已成功推送（4 个提交、38 个文件）。
- 仓库体积极小（`.git` 约 15 MB），最大文件 11 MB，远低于 GitHub 100 MB 限制。
- 推送完成后已立即清除 `.git/config` 中的 token 凭据，无残留。
- 网站已通过 **GitHub Pages** 部署上线：https://linqiyu-0921.github.io/reading-archive-between-the-spines/ （source: `main` 分支根目录）

### 路径 A · 用户在 CodeBuddy 重新授权后由 AI 沙箱一键推送（推荐）
1. 打开 **CodeBuddy 设置 → 连接器 → GitHub**，点击「重新授权 / 重新连接」。
2. 完成后回复「**已重新授权**」。
3. AI 在沙箱执行 `bash push.sh`：自动获取新 Token → 创建公开仓库 `reading-archive-between-the-spines` → 推送 `main` 分支。

> 若你直接提供一枚有效 PAT（具有 repo 权限），也可跳过连接器重新授权，直接用 `GITHUB_TOKEN='你的PAT' bash push-with-token.sh` 完成推送。
4. 返回仓库地址 `https://github.com/<你的用户名>/reading-archive-between-the-spines`。

### 路径 B · 用户本地推送（无需重新授权）
下载本目录（或 `/workspace/reading-archive-between-the-spines.zip` 备份包），在已联网且已登录 GitHub 的机器上执行：

```bash
cd reading-archive-between-the-spines

# 方式 1：gh CLI（最简）
gh auth login            # 若未登录
gh repo create reading-archive-between-the-spines --public --source . --remote origin --push

# 方式 2：已有/手动创建的远端仓库
git remote add origin https://github.com/<你的用户名>/reading-archive-between-the-spines.git
git branch -M main
git push -u origin main
```

> 仓库名已定为 `reading-archive-between-the-spines`，若名称冲突可自行调整。
> 注意：本目录含两个视频文件（约 13.4 MB），单文件远小于 GitHub 100 MB 限制，可正常推送。

---

## 五、上传到 ima 知识库

见 `docs/ima_upload_guide.md`：将 `docs/books_list.md` 与 `docs/books_data.json` 导入 ima「图书知识库」即可。

---

## 技术栈

- 纯静态 HTML / CSS / JavaScript（无构建依赖）
- 字体：Playfair Display、Noto Serif SC、Inter（Google Fonts）
- 数据：豆瓣 API 抓取的书籍元数据（封面为外链，离线需另存）
