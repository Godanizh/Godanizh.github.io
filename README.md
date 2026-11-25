# 个人博客（Hugo + FixIt + GitHub Pages）

纯静态、零成本、自带 HTTPS。仓库名必须是 `你的用户名.github.io`，上线地址即 `https://你的用户名.github.io`。

主题：[FixIt](https://github.com/hugo-fixit/FixIt) v1（已裁剪后内置在 `themes/FixIt`，不是 submodule，不需要 `--recurse-submodules`）。

## 目录结构

```
个人博客/
├─ hugo.toml                     站点配置（用户名、导航、评论都在这里）
├─ content/posts/                文章（Markdown）
├─ content/about.md              关于页
├─ themes/FixIt/                 主题（内置，已删掉主题自带的文档内容）
├─ .github/workflows/deploy.yml  推送后自动构建发布
├─ serve.ps1                     本地预览（自动带上 Hugo 和 Dart Sass）
├─ setup.ps1                     一键替换 YOURUSERNAME
└─ .tools/                       本地用的 hugo.exe / dart-sass（已 gitignore，不入库）
```

## 第一次上手（3 步）

### 1. 填用户名

```powershell
cd "E:\GIthub 个人博客"
.\setup.ps1 -Username 你的GitHub用户名
```

### 2. 本地预览

```powershell
.\serve.ps1
```

打开 http://localhost:1313 ，`Ctrl+C` 停止。改文件会自动刷新。

### 3. 推到 GitHub

先在 GitHub 网页新建**公开**空仓库（不要勾 README/.gitignore/license），名为 `你的用户名.github.io`，然后：

```powershell
git add .
git commit -m "init blog"
git branch -M main
git remote add origin https://github.com/你的用户名/你的用户名.github.io.git
git push -u origin main
```

推完去仓库 **Settings → Pages → Source** 选 **GitHub Actions**，再回 **Actions** 看构建（约 1–2 分钟）。
⚠️ 第一次必须先在 Settings 里选 GitHub Actions，否则报 `Get Pages site failed`。

## 日常写作

```powershell
hugo new content posts/新文章.md    # 或用 .tools\hugo\hugo.exe new content ...
```

把 front matter 里的 `draft: true` 改成 `false`，写完：

```powershell
git add . ; git commit -m "post: 新文章" ; git push
```

front matter 常用字段：

```yaml
---
title: "标题"
date: 2026-11-25
draft: false
tags: ["随笔"]
categories: ["技术"]
summary: "列表页显示的摘要"
---
```

## 可选：开启 giscus 评论

1. 仓库 Settings → General → Features 勾选 **Discussions**
2. 打开 https://giscus.app/zh-CN ，填仓库名、选 Discussion 分类，复制 `data-repo-id` 和 `data-category-id`
3. 编辑 `hugo.toml` 的 `[params.comment]` 段：

```toml
[params.comment]
  enable = true
  [params.comment.giscus]
    enable = true
    repo = "你的用户名/你的用户名.github.io"
    repo_id = "上一步复制的 repo_id"
    category = "Announcements"
    category_id = "上一步复制的 category_id"
```

## 可选：绑定自己的域名

1. DNS 添加 `CNAME` 记录指向 `你的用户名.github.io`
2. 新建 `static/CNAME`，内容只写一行域名，如 `blog.example.com`
3. `hugo.toml` 的 `baseURL` 改成 `https://blog.example.com/`
4. 仓库 Settings → Pages → Custom domain 填域名，勾选 **Enforce HTTPS**

## 常见问题

| 现象 | 原因与处理 |
|---|---|
| 构建报 `TOCSS-DART ... need to install Dart Sass` | FixIt 用 SCSS，Hugo 0.157+ 不再内置 libsass。线上由 workflow 自动装；本地用 `serve.ps1` 会带上 `.tools/dart-sass` |
| 本地 `hugo server` 反复重建、CPU 跑满 | 缓存目录被放进了项目内。`serve.ps1` 已把 `HUGO_CACHEDIR` 指到 `%LOCALAPPDATA%\hugo-blog-cache` |
| 本地预览看不到评论区 | 正常，Hugo 开发环境会关闭评论/PWA/统计，只有生产构建才启用 |
| 页面没样式、纯文本 | `baseURL` 还是 `YOURUSERNAME`，跑 `.\setup.ps1` |
| Actions 报 `Get Pages site failed` | 没在 Settings → Pages 里把 Source 选成 GitHub Actions |
| `github.io` 国内访问不稳 | 是线路问题，不是配置问题；介意就绑自有域名 |

## 注意

- 主题是内置的，不是 submodule，替换主题只需换 `themes/` 目录 + 改 `hugo.toml` 的 `theme`
- 图片压成 WebP 再传，仓库控制在 1GB 内
- 无法备案，别指望国内 CDN
