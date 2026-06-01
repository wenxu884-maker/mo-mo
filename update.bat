@echo off
chcp 65001 >nul
echo ============================================
echo   momo-site 一键更新
echo ============================================
echo.

:: 找桌面上最新的 momo-backup zip
set "LATEST="
for /f "delims=" %%f in ('dir /b /o-d "%USERPROFILE%\Desktop\momo-backup-*.zip" 2^>nul') do (
    set "LATEST=%USERPROFILE%\Desktop\%%f"
    goto :found
)

:found
if "%LATEST%"=="" (
    echo ❌ 桌面上没找到 momo-backup-*.zip
    echo 请先在网站上导出数据！
    pause
    exit /b 1
)

echo 📦 找到文件：%LATEST%
echo.

:: 进入项目目录
cd /d "%~dp0"

:: 删除旧 data/
if exist "data\" (
    echo 🗑️  删除旧数据...
    rmdir /s /q "data"
)

:: 解压
echo 📂 解压中...
powershell -Command "Expand-Archive -Path '%LATEST%' -DestinationPath 'data' -Force"

if not exist "data\manifest.json" (
    echo ❌ 解压失败，没找到 manifest.json
    pause
    exit /b 1
)

echo ✅ 解压完成

:: git 操作
echo.
echo 📤 推送到 GitHub...
git add data/
git commit -m "data: update %date%"
git push origin main

if %errorlevel% equ 0 (
    echo.
    echo ============================================
    echo   ✅ 更新完成！
    echo   1-2 分钟后刷新网站即可看到新内容
    echo   https://wenxu884-maker.github.io/mo-mo/
    echo ============================================
) else (
    echo.
    echo ❌ 推送失败，请检查网络或联系我
)

pause
