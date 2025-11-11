@echo off
net session >nul 2>&1 || (
    powershell "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
chcp 65001 >nul
echo [START] %date% %time%
echo.

:: =====================================================
:: 1. Install Microsoft Store
:: =====================================================
echo.
echo [1/8] Installing Microsoft Store...
powershell -NoProfile -Command ^
"$id='9wzdncrfjbmp'; ^
$uri='https://store.rg-adguard.net/api/GetFiles'; ^
$body=@{type='ProductId';search=$id}; ^
$resp=Invoke-RestMethod -Uri $uri -Method Post -Body $body -ErrorAction SilentlyContinue; ^
$msix=$resp | Where-Object {$_.EndsWith('.msixbundle')} | Select-Object -First 1; ^
if($msix){ ^
    $out='C:\Temp\Store.msixbundle'; ^
    New-Item -ItemType Directory -Path 'C:\Temp' -Force | Out-Null; ^
    Invoke-WebRequest -Uri $msix -OutFile $out -ErrorAction SilentlyContinue; ^
    Add-AppxPackage -Path $out -ForceApplicationShutdown ^
} else { echo 'Download Failed - Check Network' }"

:: =====================================================
:: 2. Install App Installer
:: =====================================================
echo.
echo [2/8] Installing App Installer...
winget install --id Microsoft.DesktopAppInstaller --source winget --accept-package-agreements --accept-source-agreements --silent --force

:: =====================================================
:: 3. Install Windows Terminal
:: =====================================================
echo [3/8] Installing Windows Terminal...
winget install --id 9N0DX20HK701 --source msstore --accept-package-agreements --accept-source-agreements --silent --force


:: =====================================================
:: 4. Installing PowerShell 7.x
:: =====================================================
echo.
echo [4/8] Installing PowerShell 7.x...
winget install --id Microsoft.PowerShell --source winget --accept-package-agreements --accept-source-agreements --silent --force

:: =====================================================
:: 5. Install the Xbox app
:: =====================================================
echo.
echo [5/8] Installing Xbox app...
winget install --id 9MV0B5HZVK9Z --source msstore --accept-package-agreements --accept-source-agreements --silent --force

:: =====================================================
:: 6. Install Windows Notepad
:: =====================================================
echo.
echo [6/8] Installing Windows Notepad...
winget install --id 9MSMLRH6LZF3 --source msstore --accept-package-agreements --accept-source-agreements --silent --force

:: =====================================================
:: 7. Setting up PowerShell & CMD profiles
:: =====================================================
echo.
echo [7/8] Setting up PowerShell & CMD profiles...
set "PS7_PROFILE=%SystemDrive%\Users\Default\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
mkdir "%SystemDrive%\Users\Default\Documents\PowerShell" 2>nul
(
echo Set-ExecutionPolicy Unrestricted -Force
) > "%PS7_PROFILE%"
set "USER_PS=%USERPROFILE%\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
mkdir "%USERPROFILE%\Documents\PowerShell" 2>nul
copy "%PS7_PROFILE%" "%USER_PS%" >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d "cls" /f >nul

:: =====================================================
:: 8. Delete the existing capture tool > Install the new version
:: =====================================================
echo.
echo [8/8] Updating capture tool...
powershell -Command "Get-AppxPackage *Snipping* -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue"
powershell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -like '*Snipping*'} | Remove-AppxProvisionedPackage -Online"
winget install --id 9MZ95KL8MR0L --source msstore --accept-package-agreements --accept-source-agreements --silent --force

:: =====================================================
:: 9. complete
:: =====================================================
echo.
echo [COMPLETE] All installation and setup is complete!

exit /b 0
