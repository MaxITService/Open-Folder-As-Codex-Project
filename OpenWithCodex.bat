@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "LOG_FILE=%SCRIPT_DIR%open-with-codex.log"
set "MENU_KEY=HKCU\Software\Classes\Directory\shell\OpenProjectInCodex"

set "ACTION="
reg query "%MENU_KEY%" >nul 2>&1
if "%ERRORLEVEL%"=="0" (
  echo Open project in Codex is already installed.
  echo.
  echo Y = uninstall it now
  echo R = reinstall/update it
  echo N = cancel
  echo.
  set /p "CHOICE=What do you want to do? [Y/R/N] "

  if /I "%CHOICE%"=="Y" set "ACTION=-Uninstall"
  if /I "%CHOICE%"=="R" set "ACTION="
  if /I "%CHOICE%"=="N" goto cancelled
  if not defined ACTION if /I not "%CHOICE%"=="R" goto cancelled
)

if "%ACTION%"=="-Uninstall" (
  echo Removing classic Codex context menu entries...
) else (
  echo Installing classic Codex context menu entries...
)
echo Log: %LOG_FILE%
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& { param([string]$ScriptPath, [string]$LogPath, [string]$Action, [Parameter(ValueFromRemainingArguments=$true)][string[]]$Rest) try { if ($Action -eq '-Uninstall') { & $ScriptPath -Uninstall @Rest 2>&1 | Tee-Object -FilePath $LogPath } else { & $ScriptPath @Rest 2>&1 | Tee-Object -FilePath $LogPath }; if ($LASTEXITCODE -is [int]) { exit $LASTEXITCODE }; exit 0 } catch { $_ | Out-String | Tee-Object -FilePath $LogPath -Append; exit 1 } }" "%SCRIPT_DIR%Install-OpenWithCodex.ps1" "%LOG_FILE%" "%ACTION%" %*
set "EXITCODE=%ERRORLEVEL%"

echo.
if "%EXITCODE%"=="0" (
  if "%ACTION%"=="-Uninstall" (
    echo Uninstall completed successfully.
  ) else (
    echo Install completed successfully.
  )
) else (
  echo Failed with exit code %EXITCODE%.
)
echo Log: %LOG_FILE%
echo.
pause

exit /b %EXITCODE%

:cancelled
echo Cancelled. Nothing changed.
echo.
pause
exit /b 0
