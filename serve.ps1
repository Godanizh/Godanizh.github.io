# 本地预览（双击或在终端运行）
# 用法：.\serve.ps1            预览，含草稿
#       .\serve.ps1 -NoDrafts  不显示草稿
param(
    [switch]$NoDrafts,
    [int]$Port = 1313
)

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot

$hugo = Join-Path $root '.tools\hugo\hugo.exe'
if (-not (Test-Path $hugo)) {
    $cmd = Get-Command hugo -ErrorAction SilentlyContinue
    if ($cmd) { $hugo = $cmd.Source } else { throw '找不到 hugo.exe：请把它放到 .tools\hugo\，或安装 Hugo 到 PATH。' }
}

# FixIt 需要 Dart Sass 才能编译 SCSS
$sassDir = Join-Path $root '.tools\dart-sass\dart-sass'
$sassExe = Join-Path $sassDir 'sass.bat'
if (Test-Path $sassExe) {
    $env:PATH = "$sassDir;$env:PATH"
    Write-Host "Dart Sass: $(& $sassExe --version)"
} else {
    Write-Warning '未找到 Dart Sass，构建可能因 SCSS 编译失败。请把 dart-sass 解压到 .tools\dart-sass\'
}

# 缓存目录必须放在项目外，否则 hugo server 会监听自己的缓存文件导致反复重建
$cacheRoot = if ($env:LOCALAPPDATA) { $env:LOCALAPPDATA } else { [System.IO.Path]::GetTempPath() }
$env:HUGO_CACHEDIR = Join-Path $cacheRoot 'hugo-blog-cache'
New-Item -ItemType Directory -Force -Path $env:HUGO_CACHEDIR | Out-Null

$args = @('server', '--port', $Port, '--bind', '127.0.0.1', '--noBuildLock')
if (-not $NoDrafts) { $args += '-D' }

Write-Host "Hugo: $(& $hugo version)"
Write-Host "预览地址：http://127.0.0.1:$Port    （Ctrl+C 停止）"
& $hugo @args
