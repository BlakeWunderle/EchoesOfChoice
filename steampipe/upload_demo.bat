@echo off
echo === Parting Shadows Demo SteamPipe Upload ===
echo.

if not exist "%~dp0..\build\windows-demo\PartingShadowsDemo.exe" (
    echo ERROR: Demo build not found at build\windows-demo\
    echo Run the Godot export for all three demo presets first.
    pause
    exit /b 1
)

REM Prepare macOS demo build: unzip and rename .app to remove spaces
if exist "%~dp0..\build\macos-demo\PartingShadowsDemo.zip" (
    echo Preparing macOS demo build...
    if exist "%~dp0..\build\macos-demo\PartingShadowsDemo.app" rmdir /s /q "%~dp0..\build\macos-demo\PartingShadowsDemo.app"
    powershell -Command "Expand-Archive -Path '%~dp0..\build\macos-demo\PartingShadowsDemo.zip' -DestinationPath '%~dp0..\build\macos-demo' -Force"
    if exist "%~dp0..\build\macos-demo\Parting Shadows Demo.app" (
        ren "%~dp0..\build\macos-demo\Parting Shadows Demo.app" "PartingShadowsDemo.app"
        echo   Renamed .app bundle to PartingShadowsDemo.app
    )
)

echo.
set /p USERNAME=Enter Steam username:
C:\steamcmd\steamcmd.exe +login %USERNAME% +run_app_build "%~dp0app_build_4829010.vdf" +quit

echo.
echo Upload complete. Check build status in Steamworks.
pause
