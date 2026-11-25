param(
    [Parameter(Mandatory = $true)]
    [string]$Username
)

$root = $PSScriptRoot
$files = @(
    (Join-Path $root 'hugo.toml'),
    (Join-Path $root 'content\about.md')
)

$total = 0
foreach ($f in $files) {
    if (-not (Test-Path $f)) { continue }
    $text = Get-Content $f -Raw -Encoding UTF8
    $count = ([regex]::Matches($text, 'YOURUSERNAME')).Count
    if ($count -gt 0) {
        $text = $text -replace 'YOURUSERNAME', $Username
        Set-Content -Path $f -Value $text -Encoding UTF8 -NoNewline
        $total += $count
        "更新 {0}：替换 {1} 处" -f (Split-Path $f -Leaf), $count
    }
}

if ($total -eq 0) {
    "没有找到 YOURUSERNAME 占位符，可能已经替换过了。"
} else {
    "完成。共替换 $total 处。"
    "接下来：.\serve.ps1 本地预览；确认无误后 git push 上线。"
}
