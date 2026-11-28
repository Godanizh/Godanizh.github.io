# godanizh 的网络安全博客

基于 [Fuwari](https://github.com/saicaca/fuwari)（Astro + Svelte + Tailwind）的个人博客，托管在 GitHub Pages。

- 线上地址：https://godanizh.github.io
- 主题许可：MIT（见 `LICENSE`）
- 构建产物是纯静态文件，`dist/` 直接可托管

## 常用命令

```powershell
pnpm install        # 首次或依赖变更后
pnpm dev            # 开发模式，http://localhost:4321
pnpm build          # 构建到 dist/（同时生成 Pagefind 搜索索引）
pnpm preview        # 预览构建结果
pnpm new-post 标题   # 新建文章，自动生成 front matter
```

> 本机现在用 `pnpm`（不是 npm）。`package.json` 里锁了 `pnpm@9.14.4`，`preinstall` 会拒绝 npm/yarn。

## 改配置（都在一个文件里）

`src/config.ts`：

| 想改什么 | 改哪个字段 |
|---|---|
| 站点标题/副标题/语言 | `siteConfig.title`、`subtitle`、`lang` |
| 背景大图 | `siteConfig.banner`（`enable`、`src`、`position`） |
| 全站主色 | `siteConfig.themeColor.hue`（0–360） |
| 访客能否自己调色 | `themeColor.fixed`（`false` = 显示调色盘） |
| 头像/昵称/简介/社交 | `profileConfig` |
| 顶部导航 | `navBarConfig.links` |
| 文章许可协议 | `licenseConfig` |

**图片放哪**：`src/assets/images/`（配置里写 `assets/images/xxx.png`）或 `public/`（写 `/xxx.png`）。

更细的样式：`src/styles/main.css`、`src/styles/variables.styl`、`tailwind.config.cjs`。

## 写文章

文章放在 `src/content/posts/`，front matter 字段（由 `src/content/config.ts` 的 schema 校验）：

```yaml
---
title: "标题"
published: 2026-11-26        # 必填
updated: 2026-11-27          # 可选
draft: false
description: "列表页摘要"
image: ""                    # 封面图，留空则纯色卡片
tags: ["电子取证", "手机取证"]
category: "电子取证"
lang: ""
---
```

- **图片**：放进 `public/images/...`，正文里写 `![](/images/.../x.png)`，构建时原样拷贝
- **代码块**：Expressive Code，支持行号、折叠、文件名
- **数学公式**：`$...$` / `$$...$$`（KaTeX）

## 从语雀导入

语雀导出的 Markdown 直接放进来，需要做两件事：

1. 补 front matter（上面那套字段）
2. 把 `cdn.nlark.com` 的外链图片下载到 `public/images/`，正文改成 `/images/...`

原来的 `tools/import-yuque.ps1` 是为 Hugo 写的，迁移后已移除；需要的话按上面的规则手工处理，或让我重新写一个 Astro 版。

## 部署

推送到 `main` 即自动上线：

```
push → GitHub Actions（pnpm install + pnpm build）→ 上传 dist/ → GitHub Pages
```

工作流文件：`.github/workflows/deploy.yml`

首次部署前必须在仓库 **Settings → Pages → Source** 选择 **GitHub Actions**。

## 已知限制

| 事项 | 说明 |
|---|---|
| 分类/标签没有独立列表页 | Fuwari 只生成 `categories/index.xml`、`tags/index.xml`（RSS），**没有 HTML 归档页**。想按「CTF / 电子取证」分栏浏览，需要自己加页面 |
| 评论 | 未接入。要加需自己写 giscus 组件（Fuwari 不内置） |
| 代码块配色 | 只支持深色主题，浅色模式下代码块仍是深底 |
| 搜索 | Pagefind，**只在 `pnpm build` 之后可用**，`pnpm dev` 下搜索无结果 |
| 中文分词 | Pagefind 对 zh-cn 不支持词干化，只能整词匹配 |
| 图片体积 | `public/images/yuque/` 目前 4.4MB（17 张 PNG），建议后续压成 WebP |
