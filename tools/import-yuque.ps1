# 语雀文章导入工具
#
# 用法（在项目根目录执行）：
#   .\tools\import-yuque.ps1 -InputFile "C:\Users\pop\Downloads\某篇文章.md" -Section forensics -Category 电子取证 -Tags 手机取证,盘古石杯
#
# 它会做四件事：
#   1. 把正文里的语雀图床图片下载到 static/images/yuque/<slug>/
#   2. 把图片链接改成本站路径
#   3. 清掉语雀特有的噪音标记（ocr 注释、<font> 标签、<u> 下划线）
#   4. 补上 Hugo front matter 并写入 content/<Section>/<slug>.md
param(
    [Parameter(Mandatory = $true)][string]$InputFile,
    [Parameter(Mandatory = $true)][ValidateSet('ctf', 'forensics', 'posts')][string]$Section,
    [string]$Title,
    [string]$Slug,
    [string]$Date = (Get-Date -Format 'yyyy-MM-dd'),
    [string]$Category = '',
    [string[]]$Tags = @(),
    [string]$Summary = '',
    [string]$ProxyUrl = 'http://127.0.0.1:10808',
    [switch]$NoProxy
)

$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent

if (-not (Test-Path $InputFile)) { throw "找不到文件：$InputFile" }

$raw = Get-Content $InputFile -Raw -Encoding UTF8

# 标题 / slug 兜底：用文件名
$base = [System.IO.Path]::GetFileNameWithoutExtension($InputFile)
if (-not $Title) { $Title = $base }
if (-not $Slug) {
    $ascii = ($base -replace '[^\x20-\x7E]', '' -replace '[^a-zA-Z0-9\-_]', '-').Trim('-')
    if ($ascii.Length -lt 3) { $ascii = 'post-' + (Get-Date -Format 'yyyyMMdd-HHmmss') }
    $Slug = $ascii.ToLower()
}

# 图片下载目录
$imgRel = "/images/yuque/$Slug"
$imgDir = Join-Path $root "static\images\yuque\$Slug"
New-Item -ItemType Directory -Force -Path $imgDir | Out-Null

# 1. 下载并替换图片
$imgMatches = [regex]::Matches($raw, '!\[([^\]]*)\]\((https?://[^)\s]+)\)')
"发现图片 $($imgMatches.Count) 张"
$i = 0
$text = $raw
foreach ($m in $imgMatches) {
    $i++
    $url = $m.Groups[2].Value
    $ext = '.png'
    $u = $url.Split('?')[0]
    foreach ($e in '.png', '.jpg', '.jpeg', '.gif', '.webp', '.svg') { if ($u.ToLower().EndsWith($e)) { $ext = $e } }
    $name = '{0:d3}{1}' -f $i, $ext
    $out = Join-Path $imgDir $name
    $ok = $false
    if (-not $NoProxy) {
        foreach ($px in @($null, $ProxyUrl)) {
            if ($ok) { break }
            try {
                if ($px) { Invoke-WebRequest -Uri $url -OutFile $out -Proxy $px -TimeoutSec 40 -UseBasicParsing }
                else { Invoke-WebRequest -Uri $url -OutFile $out -TimeoutSec 40 -UseBasicParsing }
                if ((Get-Item $out).Length -gt 200) { $ok = $true }
            } catch { }
        }
    } else {
        try { Invoke-WebRequest -Uri $url -OutFile $out -TimeoutSec 40 -UseBasicParsing; $ok = $true } catch { }
    }
    if ($ok) {
        $text = $text.Replace($m.Value, "![]($imgRel/$name)")
    } else {
        Write-Warning "第 $i 张图下载失败，保留原链接：$url"
    }
}
"图片落地成功：$((Get-ChildItem $imgDir -File -ErrorAction SilentlyContinue | Measure-Object).Count) / $($imgMatches.Count)"

# 2. 清理语雀噪音
$text = $text -replace '(?m)^<!--\s*这是一张图片[^>]*?-->\s*\r?\n', ''
$text = $text -replace '<font[^>]*>', '' -replace '</font>', ''
$text = [regex]::Replace($text, '<u>\s*(.*?)\s*</u>', '**$1**', 'Singleline')
$text = $text.Trim()

# 去掉文章自带的一级标题（避免和 front matter 标题重复）
$text = $text -replace '(?m)^#\s+.*\r?\n', ''

# 3. 组装 front matter
$tagLine = if ($Tags.Count -gt 0) { 'tags: [' + (($Tags | ForEach-Object { '"' + $_ + '"' }) -join ', ') + ']' } else { 'tags: []' }
$catLine = if ($Category) { 'categories: ["' + $Category + '"]' } else { 'categories: []' }

$fm = @"
---
title: "$($Title -replace '"', '\"')"
date: $Date
slug: "$Slug"
draft: false
$catLine
$tagLine
summary: "$($Summary -replace '"', '\"')"
---

"@

$outFile = Join-Path $root "content\$Section\$Slug.md"
Set-Content -Path $outFile -Value ($fm + $text) -Encoding UTF8
"已写入：$outFile"
"预览：http://localhost:1313/$Section/$Slug/"
