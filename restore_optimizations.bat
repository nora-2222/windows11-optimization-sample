@echo off
chcp 65001 >nul
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
:: ========================================
:: Windows 11 Optimization Restoration Script
:: ========================================

echo.
echo ========================================
echo  Windows 11 Optimization Restoration Script
echo ========================================
echo.

set "OK=echo   [  OK  ]"
set "FAIL=echo   [FAILED]"

:: ===== Restore desktop responsiveness =====
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 1 /f >nul 2>&1 && %OK% HideFileExt = OK || %FAIL% HideFileExt = FAIL
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d 2 /f >nul 2>&1 && %OK% Hidden = OK || %FAIL% Hidden = FAIL
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 400 /f >nul 2>&1 && %OK% MenuShowDelay = OK || %FAIL% MenuShowDelay = FAIL
reg add "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 20000 /f >nul 2>&1 && %OK% WaitToKillAppTimeout = OK || %FAIL% WaitToKillAppTimeout = FAIL
reg add "HKCU\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d 10000 /f >nul 2>&1 && %OK% HungAppTimeout = OK || %FAIL% HungAppTimeout = FAIL
reg add "HKCU\Control Panel\Keyboard" /v KeyboardDelay /t REG_DWORD /d 1 /f >nul 2>&1 && %OK% KeyboardDelay = OK || %FAIL% KeyboardDelay = FAIL

:: ===== Restore Search & Recommendation =====
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 1 /f >nul 2>&1 && %OK% BingSearchEnabled = OK || %FAIL% BingSearchEnabled = FAIL
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /f >nul 2>&1 && %OK% DisableWindowsConsumerFeatures = OK || %FAIL% DisableWindowsConsumerFeatures = FAIL

:: ===== Restore Game DVR / FSO / Game Bar =====
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 1 /f >nul 2>&1 && %OK% GameDVR_Enabled = OK || %FAIL% GameDVR_Enabled = FAIL
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehavior /t REG_DWORD /d 0 /f >nul 2>&1 && %OK% GameDVR_FSEBehavior = OK || %FAIL% GameDVR_FSEBehavior = FAIL
reg add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 0 /f >nul 2>&1 && %OK% GameDVR_HonorUserFSEBehaviorMode = OK || %FAIL% GameDVR_HonorUserFSEBehaviorMode = FAIL
reg add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 0 /f >nul 2>&1 && %OK% GameDVR_DXGIHonorFSEWindowsCompatible = OK || %FAIL% GameDVR_DXGIHonorFSEWindowsCompatible = FAIL
reg add "HKCU\System\GameConfigStore" /v GameDVR_EFSEFeatureFlags /t REG_DWORD /d 0 /f >nul 2>&1 && %OK% GameDVR_EFSEFeatureFlags = OK || %FAIL% GameDVR_EFSEFeatureFlags = FAIL
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /f >nul 2>&1 && %OK% AllowGameDVR = OK || %FAIL% AllowGameDVR = FAIL
reg add "HKCU\Software\Microsoft\GameBar" /v ShowStartupPanel /t REG_DWORD /d 1 /f >nul 2>&1 && %OK% ShowStartupPanel = OK || %FAIL% ShowStartupPanel = FAIL
reg add "HKCU\Software\Microsoft\GameBar" /v GamePanelStartupTipIndex /t REG_DWORD /d 0 /f >nul 2>&1 && %OK% GamePanelStartupTipIndex = OK || %FAIL% GamePanelStartupTipIndex = FAIL
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul 2>&1 && %OK% AllowAutoGameMode = OK || %FAIL% AllowAutoGameMode = FAIL
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul 2>&1 && %OK% AutoGameModeEnabled = OK || %FAIL% AutoGameModeEnabled = FAIL
reg add "HKCU\Software\Microsoft\GameBar" /v UseNexusForGameBarEnabled /t REG_DWORD /d 1 /f >nul 2>&1 && %OK% UseNexusForGameBarEnabled = OK || %FAIL% UseNexusForGameBarEnabled = FAIL

echo.
echo ========================================
echo  Complete
echo ========================================
exit /b 0

















