@echo off
:: ========================================
:: Restore Script
:: ========================================

net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo off
chcp 437 >nul

:: ===== 1. Restoring desktop responsiveness =====
reg delete "HKCU\Control Panel\Desktop" /v MenuShowDelay /f >nul 2>&1
reg delete "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeout /f >nul 2>&1
reg delete "HKCU\Control Panel\Desktop" /v HungAppTimeout /f >nul 2>&1
reg delete "HKCU\Control Panel\Keyboard" /v KeyboardDelay /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarMn /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarDa /f >nul 2>&1

:: ===== 2. Search & Restore Recommendations =====
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v BingSearchEnabled /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /f >nul 2>&1

:: ===== 3. Restore Game DVR / FSO / Game Bar =====
reg delete "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /f >nul 2>&1
reg delete "HKCU\System\GameConfigStore" /v GameDVR_FSEBehavior /f >nul 2>&1
reg delete "HKCU\System\GameConfigStore" /v GameDVR_Enabled /f >nul 2>&1
reg delete "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /f >nul 2>&1
reg delete "HKCU\System\GameConfigStore" /v GameDVR_EFSEFeatureFlags /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\GameBar" /v ShowStartupPanel /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\GameBar" /v GamePanelStartupTipIndex /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\GameBar" /v UseNexusForGameBarEnabled /f >nul 2>&1

:: ===== 4. Service restoration =====
sc config HomeGroupListener start= demand >nul 2>&1
sc config HomeGroupProvider start= auto >nul 2>&1

:: ===== 5. Restoring sleep mode =====
reg delete "HKLM\System\CurrentControlSet\Control\Session Manager\Power" /v HibernateEnabled /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /v ShowHibernateOption /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v HibernateEnabledDefault /f >nul 2>&1
powercfg.exe /hibernate on >nul 2>&1

:: ===== 6. Restore location services =====
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v Value /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v SensorPermissionState /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" /v Status /f >nul 2>&1

:: ===== 7. Windows Maps Restore =====
reg delete "HKLM\SYSTEM\Maps" /v AutoUpdateEnabled /f >nul 2>&1

:: ===== 8. VBS / HVCI / Hypervisor Restore =====
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v Enabled /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v HVCIMATRequired /f >nul 2>&1
bcdedit /deletevalue hypervisorsettings >nul 2>&1
bcdedit /deletevalue hypervisorlaunchtype >nul 2>&1

:: ===== 9. SMB1 Restore (enable function) =====
powershell -Command "Enable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart" >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v SMB1 /f >nul 2>&1

:: ===== 10. Restore Explorer Folder View =====
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoComplete" /v AutoSuggest /f >nul 2>&1
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer" /v ShowRecent /f >nul 2>&1

:: ===== 11. WPBT Restore =====
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager" /v DisableWpbtExecution /f >nul 2>&1

:: ===== 12. Restoring Scheduler Tasks =====
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

:: ===== 13. Graphics Delayed Restoration =====
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v MonitorLatencyTolerance /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\DXGKrnl" /v MonitorRefreshLatencyTolerance /f >nul 2>&1

:: ===== 14. Restore SMB Cache =====
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v DirectoryCacheLifetime /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v FileNotFoundCacheLifetime /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v DormantFileLimit /f >nul 2>&1

:: ===== 15. Restore network throttling =====
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /f >nul 2>&1

:: ===== 16. MMCSS / Priority Restoration =====
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v GPU Priority /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v GPU Priority /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v Priority /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v AlwaysOn /f >nul 2>&1

:: ===== 17. mouse restoration =====
reg delete "HKU\.DEFAULT\Control Panel\Mouse" /v MouseSpeed /f >nul 2>&1
reg delete "HKU\.DEFAULT\Control Panel\Mouse" /v MouseThreshold1 /f >nul 2>&1
reg delete "HKU\.DEFAULT\Control Panel\Mouse" /v MouseThreshold2 /f >nul 2>&1
reg delete "HKU\.DEFAULT\Control Panel\Mouse" /v DoubleClickHeight /f >nul 2>&1
reg delete "HKU\.DEFAULT\Control Panel\Mouse" /v DoubleClickSpeed /f >nul 2>&1
reg delete "HKU\.DEFAULT\Control Panel\Mouse" /v DoubleClickWidth /f >nul 2>&1
reg delete "HKU\.DEFAULT\Control Panel\Mouse" /v MouseSensitivity /f >nul 2>&1
reg delete "HKU\.DEFAULT\Control Panel\Mouse" /v SmoothMouseXCurve /f >nul 2>&1
reg delete "HKU\.DEFAULT\Control Panel\Mouse" /v SmoothMouseYCurve /f >nul 2>&1
reg delete "HKU\.DEFAULT\Control Panel\Mouse" /v ActiveWindowTracking /f >nul 2>&1
reg delete "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetMouseDragOutWidth /f >nul 2>&1
reg delete "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetMouseSideMoveWidth /f >nul 2>&1
reg delete "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetMouseWidth /f >nul 2>&1
reg delete "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetPenDragOutWidth /f >nul 2>&1
reg delete "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetPenSideMoveWidth /f >nul 2>&1
reg delete "HKU\.DEFAULT\Control Panel\Mouse" /v DockTargetPenWidth /f >nul 2>&1
reg delete "HKU\.DEFAULT\Control Panel\Mouse" /v SnapToDefaultButton /f >nul 2>&1
reg delete "HKU\.DEFAULT\Control Panel\Mouse" /v SwapMouseButtons /f >nul 2>&1

:: ===== 18. Restore input queue =====
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" /v KeyboardDataQueueSize /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" /v MouseDataQueueSize /f >nul 2>&1

:: ===== 19. SMB Server Restore =====
reg delete "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v autodisconnect /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v Size /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v EnableOplocks /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v IRPStackSize /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v SharingViolationDelay /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v SharingViolationRetries /f >nul 2>&1

:: ===== 20. Low-latency task restoration =====
for %%t in ("Low Latency" "DisplayPostProcessing" "Audio" "Pro Audio" "Games" "Window Manager") do (
    reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\%%~t" /v "Latency Sensitive" /f >nul 2>&1
)

:: ===== 21. Restore CPU Parking =====
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 0 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR CPMINCORES 0 >nul 2>&1
powercfg /setacvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1
powercfg /setdcvalueindex SCHEME_CURRENT SUB_PROCESSOR PROCTHROTTLEMAX 100 >nul 2>&1

:: ===== 22. NVIDIA DPC Restore =====
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v RmGpsPsEnablePerCpuCoreDpc /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm" /v RmGpsPsEnablePerCpuCoreDpc /f >nul 2>&1

:: ===== 23. Restore Power Settings (Unhide) =====
powercfg -attributes SUB_PROCESSOR CPMINCORES -ATTRIB_HIDE >nul 2>&1

:: ===== 24. network restoration =====
netsh int tcp set supplemental internet congestionprovider=default >nul 2>&1
powershell -Command "Set-NetTCPSetting -SettingName internet -AutoTuningLevelLocal normal; Set-NetOffloadGlobalSetting -ReceiveSideScaling enabled; Set-NetTCPSetting -SettingName internet -EcnCapability enabled; Set-NetOffloadGlobalSetting -Chimney enabled; Set-NetTCPSetting -SettingName internet -Timestamps enabled; Set-NetTCPSetting -SettingName internet -MaxSynRetransmissions 4; Set-NetTCPSetting -SettingName internet -NonSackRttResiliency enabled; Set-NetTCPSetting -SettingName internet -InitialRto 3000; Set-NetTCPSetting -SettingName internet -MinRto 50" >nul 2>&1

:: ===== 25. Other System Restore =====
reg delete "HKLM\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /f >nul 2>&1
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v MaintenanceDisabled /f >nul 2>&1
reg delete "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop" /v ScreenSaveActive /f >nul 2>&1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 2 /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings" /v TaskbarEndTask /f >nul 2>&1

:: ===== 26. Restore driver priorities =====
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\usbxhci\Parameters" /v ThreadPriority /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\USBHUB3\Parameters" /v ThreadPriority /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\NDIS\Parameters" /v ThreadPriority /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\nvlddmkm\Parameters" /v ThreadPriority /f >nul 2>&1

exit /b 0



