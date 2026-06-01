$ErrorActionPreference = "Stop"

$git  = "C:\Users\32760\.workbuddy\vendor\PortableGit\mingw64\bin\git.exe"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "============================================"
Write-Host "  momo-site update"
Write-Host "============================================"
Write-Host ""

$desktop = [Environment]::GetFolderPath("Desktop")
$zips = Get-ChildItem -Path $desktop -Filter "*.zip" -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending

if ($zips.Count -eq 0) {
    Write-Host "[ERROR] No zip file found on Desktop" -ForegroundColor Red
    Write-Host "Export data from website first, then put the zip on Desktop."
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit 1
}

$zip = $zips[0].FullName
$zipName = $zips[0].Name
Write-Host "[OK] Using: $zipName" -ForegroundColor Green
Write-Host ""

Set-Location $root

if (Test-Path "data") {
    Write-Host "[...] Removing old data..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force "data"
}

Write-Host "[...] Extracting..." -ForegroundColor Yellow
Expand-Archive -LiteralPath $zip -DestinationPath "data" -Force

if (-not (Test-Path "data\manifest.json")) {
    Write-Host "[ERROR] Not a valid momo backup zip" -ForegroundColor Red
    Write-Host "Use the Export button on the website to create the zip."
    Read-Host "Press Enter to exit"
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
    Write-Host "[ERROR] Push failed" -ForegroundColor Red
    Write-Host "Copy the error above and send it to me."
}

Write-Host ""
Read-Host "Press Enter to exit"
