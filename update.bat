@echo off
chcp 65001 >nul

:: git 的精确路径（WorkBuddy 自带）
set "GIT=C:\Users\32760\.workbuddy\vendor\PortableGit\mingw64\bin\git.exe"

:: 目标文件：桌面上的 momo新数据.zip
set "ZIP=%USERPROFILE%\Desktop\momo新数据.zip"

echo ============================================
echo   momo-site 一键更新
echo ============================================
echo.

if not exist "%ZIP%" (
    echo ❌ 没找到文件
    echo 请确保桌面上有 "momo新数据.zip"
    echo 先在网站上点「导出数据」，把 zip 放桌面
    echo.
    pause
    exit /b 1
)

echo 📦 找到：momo新数据.zip
echo.

cd /d "%~dp0"

if exist "data\" (
    echo 🗑️  删除旧数据...
    rmdir /s /q "data"
)

echo 📂 解压中...
powershell -Command "Expand-Archive -LiteralPath '%ZIP%' -DestinationPath 'data' -Force"

if not exist "data\manifest.json" (
    echo ❌ 解压失败，manifest.json 没找到
    echo 确认 zip 是用网站「导出数据」生成的
    pause
    exit /b 1
)

echo ✅ 解压完成
echo.
echo 📤 推送到 GitHub...

"%GIT%" add data/
"%GIT%" commit -m "data: update %date%"
"%GIT%" push origin main

if %errorlevel% equ 0 (
    echo.
    echo ============================================
    echo   ✅ 更新完成！
    echo   等 1-2 分钟，刷新网站看效果
    echo   https://wenxu884-maker.github.io/mo-mo/
    echo ============================================
) else (
    echo.
    echo ❌ 推送失败，把上面报错发给我
)

echo.
pause
