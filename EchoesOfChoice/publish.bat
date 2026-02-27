@echo off
echo Echoes of Choice - Publishing for all platforms
echo ================================================
echo.

set PROJECT="Echoes of Choice\Echoes of Choice.csproj"
set CONFIG=Release

echo [1/2] Windows (x64)...
dotnet publish %PROJECT% -c %CONFIG% -r win-x64 -o "publish\windows"
if %errorlevel% neq 0 goto error

echo.
echo [2/2] macOS (works on both Intel and M1/M2/M3 via Rosetta)...
dotnet publish %PROJECT% -c %CONFIG% -r osx-x64 -o "publish\mac"
if %errorlevel% neq 0 goto error

echo.
echo ================================================
echo All builds complete! Check the 'publish' folder:
echo   publish\windows\  - send to Windows friends
echo   publish\mac\      - send to Mac friends (Intel or Apple Silicon)
echo.
echo NOTE for Mac friends: After receiving the file they need to
echo run this once in Terminal to allow it to execute:
echo   chmod +x "Echoes of Choice"
echo Then right-click in Finder and choose Open the first time
echo (to allow it past macOS security since it is not signed).
echo ================================================
pause
exit /b 0

:error
echo.
echo ================================================
echo Build FAILED. See errors above.
echo ================================================
pause
exit /b 1
