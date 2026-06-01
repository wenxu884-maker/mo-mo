$ErrorActionPreference = "Stop"

$git = "C:\Users\32760\.workbuddy\vendor\PortableGit\mingw64\bin\git.exe"
$zip = "$env:USERPROFILE\Desktop\momo新数据.zip"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "============================================"
Write-Host "  momo-site 一键更新"
Write-Host "============================================"
Write-Host ""

if (-not (Test-Path $zip)) {
    Write-Host "没找到 momo新数据.zip，请把文件放在桌面上" -ForegroundColor Red
    exit 1
}

Write-Host "找到: momo新数据.zip" -ForegroundColor Green
Write-Host ""

Set-Location $scriptDir

if (Test-Path "data") {
    Write-Host "删除旧数据..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force "data"
}

Write-Host "解压中..." -ForegroundColor Yellow
Expand-Archive -LiteralPath $zip -DestinationPath "data" -Force

if (-not (Test-Path "data\manifest.json")) {
    Write-Host "解压失败，manifest.json 没找到" -ForegroundColor Red
    exit 1
}

Write-Host "解压完成" -ForegroundColor Green
Write-Host ""
Write-Host "推送到 GitHub..." -ForegroundColor Cyan

$date = Get-Date -Format "yyyy-MM-dd"
& $git add data/
& $git commit -m "data: update $date"
& $git push origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "============================================"
    Write-Host "  更新完成！" -ForegroundColor Green
    Write-Host "  等 1-2 分钟，刷新网站:"
    Write-Host "  https://wenxu884-maker.github.io/mo-mo/"
    Write-Host "============================================"
} else {
    Write-Host ""
    Write-Host "推送失败，把上面报错发给我" -ForegroundColor Red
}
