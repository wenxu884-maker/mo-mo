$ErrorActionPreference = "Stop"

$git  = "C:\Users\32760\.workbuddy\vendor\PortableGit\mingw64\bin\git.exe"
$zip  = "$env:USERPROFILE\Desktop\momo新数据.zip"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "============================================"
Write-Host "  momo-site update"
Write-Host "============================================"
Write-Host ""

if (-not (Test-Path $zip)) {
    Write-Host "[ERROR] momo新数据.zip not found on Desktop" -ForegroundColor Red
    Write-Host "Please export data from website first, then put the zip on Desktop."
    exit 1
}

Write-Host "[OK] Found: momo新数据.zip" -ForegroundColor Green
Write-Host ""

Set-Location $root

if (Test-Path "data") {
    Write-Host "[...] Removing old data..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force "data"
}

Write-Host "[...] Extracting..." -ForegroundColor Yellow
Expand-Archive -LiteralPath $zip -DestinationPath "data" -Force

if (-not (Test-Path "data\manifest.json")) {
    Write-Host "[ERROR] Extract failed: manifest.json not found" -ForegroundColor Red
    Write-Host "Make sure the zip was created with the Export button on the website."
    exit 1
}

Write-Host "[OK] Extract done" -ForegroundColor Green
Write-Host ""
Write-Host "[...] Pushing to GitHub..." -ForegroundColor Cyan

$date = Get-Date -Format "yyyy-MM-dd"
& $git add data/
& $git commit -m "data: update $date"
& $git push origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "============================================"
    Write-Host "  [OK] Update complete!" -ForegroundColor Green
    Write-Host "  Wait 1-2 min, then refresh:"
    Write-Host "  https://wenxu884-maker.github.io/mo-mo/"
    Write-Host "============================================"
} else {
    Write-Host ""
    Write-Host "[ERROR] Push failed. Send the error above to me." -ForegroundColor Red
}
