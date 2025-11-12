@echo off
chcp 65001 >nul
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell "Start-Process '%~f0' -Verb RunAs"
    exit /b
)
:: ========================================
:: Windows 11 Optimization Script
:: ========================================

:: ===== Disable Start Menu Recommended and more =====
reg add "HKU\.DEFAULT\Software\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsSpotlightFeatures /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v LockedStartLayout /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v NoChangeStartMenu /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v HideTaskViewButton /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v HideRecommendedSection /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v HideRecommendedSection /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Education" /v IsEducationEnvironment /t REG_DWORD /d 1 /f >nul 2>&1

:: ===== Improved desktop responsiveness =====
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAl /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Hidden /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 10000 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d 4000 /f >nul 2>&1
reg add "HKCU\Control Panel\Keyboard" /v KeyboardDelay /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarMn /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /t REG_DWORD /d 0 /f >nul 2>&1

:: ===== Search & Recommendation Block =====
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f >nul 2>&1

:: ===== Game DVR / FSO / Game Bar =====
reg add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehavior /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_EFSEFeatureFlags /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v ShowStartupPanel /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v GamePanelStartupTipIndex /t REG_DWORD /d 3 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v UseNexusForGameBarEnabled /t REG_DWORD /d 0 /f >nul 2>&1

:: ===== Service =====
sc config HomeGroupListener start= demand >nul 2>&1
sc config HomeGroupProvider start= Manual >nul 2>&1

:: ===== Location & Maps =====
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v Value /t REG_SZ /d Deny /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v SensorPermissionState /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" /v Status /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\Maps" /v AutoUpdateEnabled /t REG_DWORD /d 0 /f >nul 2>&1

:: ===== SMB1 & Network =====
powershell -Command "Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart" >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v SMB1 /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v DirectoryCacheLifetime /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v FileNotFoundCacheLifetime /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v DormantFileLimit /t REG_DWORD /d 0 /f >nul 2>&1

:: ===== WPBT & Scheduler =====
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v DisableWpbtExecution /t REG_DWORD /d 1 /f >nul 2>&1
for %%t in (
    "Microsoft\Windows\Maintenance\WinSAT"
    "Microsoft\Windows\Defrag\ScheduledDefrag"
    "Microsoft\Windows\UpdateOrchestrator\Reboot"
    "Microsoft\Windows\UpdateOrchestrator\USO_UxBroker_ReadyToReboot"
    "Microsoft\Windows\UpdateOrchestrator\USO_UxBroker_Update"
    "Microsoft\Windows\Autochk\Proxy"
    "Microsoft\Windows\DiskFootprint\Diagnostics"
    "Microsoft\Windows\Superfetch\SysMain"
    "Microsoft\Windows\TabletPC\TabletPCEventFilter"
    "Microsoft\Windows\Diagnosis\OnlineCrashDump"
    "Microsoft\Windows\Windows Compatibility\AblibLogger"
    "Microsoft\Windows\Windows Error Reporting\ErrorReporting"
    "Microsoft\Windows\Diagnostics\Scheduled"
    "Microsoft\Windows\Search\GatherUserDiaries"
) do (
    schtasks /End /TN "%%t" >nul 2>&1
    schtasks /Change /TN "%%t" /Disable >nul 2>&1
)

:: ===== input device =====
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DoubleClickHeight /t REG_SZ /d 4 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DoubleClickSpeed /t REG_SZ /d 500 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DoubleClickWidth /t REG_SZ /d 4 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v SmoothMouseXCurve /t REG_BINARY /d 0000000000000000156E00000000000000400100000000000029DC0300000000000000280000000000 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v SmoothMouseYCurve /t REG_BINARY /d 0000000000000000FD11010000000000002404000000000000FC12000000000000C0BB010000000000 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v ActiveWindowTracking /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetMouseDragOutWidth /t REG_SZ /d 20 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetMouseSideMoveWidth /t REG_SZ /d 50 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetMouseWidth /t REG_SZ /d 1 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetPenDragOutWidth /t REG_SZ /d 30 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetPenSideMoveWidth /t REG_SZ /d 50 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetPenWidth /t REG_SZ /d 30 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v SnapToDefaultButton /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v SwapMouseButtons /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v KeyboardDataQueueSize /t REG_DWORD /d 32 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v MouseDataQueueSize /t REG_DWORD /d 32 /f >nul 2>&1

:: ===== SMB Server & Low Latency =====
reg add "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v autodisconnect /t REG_DWORD /d 0xFFFFFFFF /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v IRPStackSize /t REG_DWORD /d 32 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v SharingViolationDelay /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v SharingViolationRetries /t REG_DWORD /d 0 /f >nul 2>&1

for %%t in (Low Latency DisplayPostProcessing Audio "Pro Audio" Games "Window Manager") do (
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\%%~t" /v "Latency Sensitive" /t REG_SZ /d True /f >nul 2>&1
)

:: ===== Power & CPU =====
powercfg -attributes SUB_PROCESSOR -ATTRIB_HID >nul 2>&1
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 100 >nul 2>&1
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1

:: ===== network advanced =====
netsh int tcp set supplemental internet congestionprovider=ctcp >nul 2>&1
powershell "Set-NetTCPSetting -SettingName internet -AutoTuningLevelLocal normal; Set-NetOffloadGlobalSetting -ReceiveSideScaling enabled; Set-NetTCPSetting -SettingName internet -EcnCapability disabled; Set-NetOffloadGlobalSetting -Chimney disabled; Set-NetTCPSetting -SettingName internet -Timestamps disabled; Set-NetTCPSetting -SettingName internet -MaxSynRetransmissions 2; Set-NetTCPSetting -SettingName internet -NonSackRttResiliency disabled; Set-NetTCPSetting -SettingName internet -InitialRto 2000; Set-NetTCPSetting -SettingName internet -MinRto 300" >nul 2>&1

:: ===== other systems =====
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 2000 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v MaintenanceDisabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop" /v ScreenSaveActive /t REG_SZ /d 0 /f >nul 2>&1
powershell "Set-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings' -Name TaskbarEndTask -Value 1 -Type DWord -Force" >nul 2>&1

:: driver priority
reg add "HKLM\SYSTEM\CurrentControlSet\Services\usbxhci\Parameters" /v ThreadPriority /t REG_DWORD /d 31 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\USBHUB3\Parameters" /v ThreadPriority /t REG_DWORD /d 31 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters" /v ThreadPriority /t REG_DWORD /d 31 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters" /v ThreadPriority /t REG_DWORD /d 31 /f >nul 2>&1

:: ===== Disable Microsoft Edge AI Features & news, sponsored~ =====
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v CopilotCDPPageContext /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v CopilotPageContext /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v HubsSidebarEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v EdgeEntraCopilotPageContext /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v EdgeHistoryAISearchEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v ComposeInlineEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v GenAILocalFoundationalModelSettings /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v NewTabPageBingChatEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v NewTabPageContentEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v NewTabPageHideDefaultTopSites /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v EdgeShoppingAssistantEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v TabServicesEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v AlternateErrorPagesEnabled /t REG_DWORD /d 0 /f >nul 2>&1

:: ===== Disable Bing in search =====
reg add "HKCU\Software\Policies\Microsoft\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f >nul 2>&1

:: ===== Disable Cortana in search =====
reg add "HKCU\Software\Policies\Microsoft\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows Search" /v CortanaConsent /t REG_DWORD /d 0 /f >nul 2>&1

:: ===== Disable Click to Do =====
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsAI" /v DisableClickToDo /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsAI" /v DisableClickToDo /t REG_DWORD /d 1 /f >nul 2>&1

:: ===== Disable Copilot =====
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowCopilotButton /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f >nul 2>&1


exit /b 0











