@echo off
chcp 65001 >nul
:: ========================================
:: install_store_and_more_app.bat
:: ========================================

:: ===== 1. Install App Installer =====
echo.
echo [1/7] Installing App Installer...
winget install --id Microsoft.DesktopAppInstaller --source winget --accept-package-agreements --accept-source-agreements --silent --force

:: ===== 2. Install Windows Terminal =====
echo.
echo [2/7] Installing Windows Terminal...
winget install --id 9N0DX20HK701 --source msstore --accept-package-agreements --accept-source-agreements --silent --force

:: ===== 3. Install PowerShell 7.x =====
echo.
echo [3/7] Installing PowerShell 7.x...
winget install --id Microsoft.PowerShell --source winget --accept-package-agreements --accept-source-agreements --silent --force

:: ===== 4. Install Xbox App =====
echo.
echo [4/7] Installing Xbox App...
winget install --id 9MV0B5HZVK9Z --source msstore --accept-package-agreements --accept-source-agreements --silent --force

:: ===== 5. Install Windows Notepad =====
echo.
echo [5/7] Installing Windows Notepad...
winget install --id 9MSMLRH6LZF3 --source msstore --accept-package-agreements --accept-source-agreements --silent --force

:: ===== 6. Setup PowerShell & CMD Profiles =====
echo.
echo [6/7] Setting up PowerShell and CMD profiles...
set "PS7_PROFILE=%SystemDrive%\Users\Default\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
if not exist "%SystemDrive%\Users\Default\Documents\PowerShell" mkdir "%SystemDrive%\Users\Default\Documents\PowerShell"
echo Set-ExecutionPolicy Unrestricted -Force > "%PS7_PROFILE%"
set "USER_PS=%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
if not exist "%USERPROFILE%\Documents\PowerShell" mkdir "%USERPROFILE%\Documents\PowerShell"
copy "%PS7_PROFILE%" "%USER_PS%" >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d "cls" /f >nul

:: ===== 7. Update Snipping Tool =====
echo.
echo [7/7] Updating Snipping Tool...
powershell -Command "Get-AppxPackage *Snipping* -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -like '*Snipping*'} | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue"
winget install --id 9MZ95KL8MR0L --source msstore --accept-package-agreements --accept-source-agreements --silent --force

:: ===== Complete =====
echo.
echo [COMPLETE] All setup finished!
exit /b 0
