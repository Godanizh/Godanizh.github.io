# 个人博客（Hugo + PaperMod + GitHub Pages）

纯静态、零成本、自带 HTTPS。仓库名必须是 `你的用户名.github.io`，上线地址即 `https://你的用户名.github.io`。

## 目录结构

```
blog/
├─ hugo.toml                     站点配置（唯一需要改用户名的地方之一）
├─ content/posts/                文章（Markdown）
├─ content/about.md              关于页
├─ layouts/partials/comments.html  giscus 评论
├─ themes/PaperMod               主题（git submodule）
└─ .github/workflows/deploy.yml  推送后自动构建发布
```

## 第一次上手（4 步）

### 1. 安装 Hugo Extended

```powershell
winget install --id Hugo.Hugo.Extended -e
```

新开终端验证：`hugo version`，输出里必须带 `extended`。

### 2. 填用户名

```powershell
cd "E:\GIthub 个人博客"
.\setup.ps1 -Username 你的GitHub用户名
```

（也可以手动把 `hugo.toml` 和 `layouts/partials/comments.html` 里的 `YOURUSERNAME` 全部替换掉。）

### 3. 本地预览

```powershell
hugo server -D
```

打开 http://localhost:1313 ，`Ctrl+C` 停止。

### 4. 推到 GitHub

先在 GitHub 网页新建**公开**仓库，名字为 `你的用户名.github.io`，然后：

```powershell
git add .
git commit -m "init blog"
git branch -M main
git remote add origin https://github.com/你的用户名/你的用户名.github.io.git
git push -u origin main
```

推完去仓库 **Settings → Pages → Source** 选 **GitHub Actions**；再回 **Actions** 标签看构建是否成功（约 1 分钟）。
⚠️ 第一次必须先在 Settings 里选 GitHub Actions，否则 workflow 会报 `Get Pages site failed`。

## 日常写作

```powershell
hugo new content posts/新文章.md   # 生成模板，把 draft 改成 false
git add . ; git commit -m "post: 新文章" ; git push
```

## 可选：启用评论

1. 仓库 Settings → Features 勾选 **Discussions**
2. 打开 https://giscus.app/zh-CN ，填仓库名，复制页面给出的 `data-repo-id` 与 `data-category-id`
3. 填进 `layouts/partials/comments.html`

## 可选：绑定自己的域名

1. 域名 DNS 添加 `CNAME` 记录，指向 `你的用户名.github.io`
2. 新建 `static/CNAME`，内容只写一行域名，如 `blog.example.com`
3. `hugo.toml` 里 `baseURL` 改成 `https://blog.example.com/`
4. 仓库 Settings → Pages → Custom domain 填域名，勾选 **Enforce HTTPS**

## 注意事项

- `github.io` 在国内访问不稳定，介意的话先绑自有域名
- 无法备案，别指望国内 CDN
- 图片压成 WebP 再传，仓库控制在 1GB 内
- 主题是 submodule，克隆仓库要带 `--recurse-submodules`
