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


:: ===== Restore desktop responsiveness =====
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 400 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 20000 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d 5000 /f >nul 2>&1
reg add "HKCU\Control Panel\Keyboard" /v KeyboardDelay /t REG_DWORD /d 1 /f >nul 2>&1

:: ===== Restore Search & Recommendation =====
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /t REG_DWORD /d 1 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /f >nul 2>&1

:: ===== Restore Game DVR / FSO / Game Bar =====
reg add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehavior /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_EFSEFeatureFlags /t REG_DWORD /d 1 /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v ShowStartupPanel /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v GamePanelStartupTipIndex /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v UseNexusForGameBarEnabled /t REG_DWORD /d 1 /f >nul 2>&1

:: ===== Restore Services =====
sc config HomeGroupListener start= manual >nul 2>&1
sc config HomeGroupProvider start= manual >nul 2>&1

:: ===== Restore Power saving management =====
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Power" /v HibernateEnabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /v ShowHibernateOption /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v HibernateEnabledDefault /t REG_DWORD /d 1 /f >nul 2>&1
powercfg.exe /hibernate on >nul 2>&1

:: ===== Restore Location & Maps =====
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v Value /t REG_SZ /d Allow /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v SensorPermissionState /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" /v Status /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\Maps" /v AutoUpdateEnabled /t REG_DWORD /d 1 /f >nul 2>&1

:: ===== Restore SMB1 & Network =====
powershell -Command "Enable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart" >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v SMB1 /t REG_DWORD /d 1 /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v DirectoryCacheLifetime /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v FileNotFoundCacheLifetime /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v DormantFileLimit /f >nul 2>&1

:: ===== Restore WPBT & Scheduler =====
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v DisableWpbtExecution /f >nul 2>&1
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
    schtasks /Change /TN "%%t" /Enable >nul 2>&1
)

:: ===== Restore input device =====
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d 1 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d 6 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d 10 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DoubleClickHeight /t REG_SZ /d 4 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DoubleClickSpeed /t REG_SZ /d 500 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DoubleClickWidth /t REG_SZ /d 4 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v SmoothMouseXCurve /t REG_BINARY /d 0000000000000000C0CC0C0000000000809919000000000040662600000000000000300000000000 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v SmoothMouseYCurve /t REG_BINARY /d 0000000000000000000038000000000000007000000000000000A800000000000000E00000000000 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v ActiveWindowTracking /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetMouseDragOutWidth /t REG_SZ /d 20 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetMouseSideMoveWidth /t REG_SZ /d 50 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetMouseWidth /t REG_SZ /d 1 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetPenDragOutWidth /t REG_SZ /d 30 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetPenSideMoveWidth /t REG_SZ /d 50 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetPenWidth /t REG_SZ /d 30 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v SnapToDefaultButton /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKU\.DEFAULT\Control Panel\Mouse" /v SwapMouseButtons /t REG_SZ /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v KeyboardDataQueueSize /t REG_DWORD /d 100 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v MouseDataQueueSize /t REG_DWORD /d 100 /f >nul 2>&1

:: ===== Restore SMB Server & Low Latency =====
reg add "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v autodisconnect /t REG_DWORD /d 15 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v IRPStackSize /t REG_DWORD /d 15 /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v SharingViolationDelay /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v SharingViolationRetries /f >nul 2>&1

for %%t in (Low Latency DisplayPostProcessing Audio "Pro Audio" Games "Window Manager") do (
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\%%~t" /v "Latency Sensitive" /t REG_SZ /d False /f >nul 2>&1
)

:: ===== Restore Power & CPU =====
powercfg -attributes SUB_PROCESSOR -ATTRIB_HID >nul 2>&1
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 0 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 0 >nul 2>&1
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1

:: ===== Restore network advanced =====
netsh int tcp set supplemental internet congestionprovider=default >nul 2>&1
powershell "Set-NetTCPSetting -SettingName internet -AutoTuningLevelLocal experimental; Set-NetOffloadGlobalSetting -ReceiveSideScaling enabled; Set-NetTCPSetting -SettingName internet -EcnCapability enabled; Set-NetOffloadGlobalSetting -Chimney automatic; Set-NetTCPSetting -SettingName internet -Timestamps enabled; Set-NetTCPSetting -SettingName internet -MaxSynRetransmissions 3; Set-NetTCPSetting -SettingName internet -NonSackRttResiliency enabled; Set-NetTCPSetting -SettingName internet -InitialRto 3000; Set-NetTCPSetting -SettingName internet -MinRto 300" >nul 2>&1

:: ===== Restore other systems =====
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 5000 /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 0 /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v MaintenanceDisabled /f >nul 2>&1
reg delete "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop" /v ScreenSaveActive /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 2 /f >nul 2>&1
powershell "Remove-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings' -Name TaskbarEndTask -Force" >nul 2>&1

:: ===== Restore driver priority =====
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\usbxhci\Parameters" /v ThreadPriority /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\USBHUB3\Parameters" /v ThreadPriority /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters" /v ThreadPriority /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters" /v ThreadPriority /f >nul 2>&1

exit /b 0






