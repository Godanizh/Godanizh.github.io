---
title: "第一篇文章"
date: 2026-11-25
draft: false
tags: ["随笔"]
summary: "这是博客的第一篇文章，用来验证整条发布链路是否通畅。"
---

如果你能看到这一页，说明 **写 Markdown → push → Actions 构建 → Pages 上线** 这条链路已经跑通了。

## 怎么写下一篇

在项目根目录执行：

```powershell
hugo new content posts/my-second-post.md
```

把 `draft: true` 改成 `false`，写完正文，然后：

```powershell
git add .
git commit -m "post: my second post"
git push
```

等 Actions 跑完（约 1 分钟），刷新页面即可看到。

## 代码块效果

```python
def greet(name: str) -> str:
    return f"你好，{name}"
```

## 列表与引用

- 支持标签、目录、阅读时长
- 支持深色/浅色主题自动切换

> 一篇文章写清楚一个问题，比写十篇空话有用。
