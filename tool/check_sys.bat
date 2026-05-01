@echo off
title ULTIMATE PC TOOLKIT
color 0A
setlocal enabledelayedexpansion

:menu
cls
echo ==================================================
echo                 ULTIMATE PC TOOLKIT
echo ==================================================
echo.
echo 1.  Clean Temp Files
echo 2.  Flush DNS
echo 3.  Show IP Info
echo 4.  System Info
echo 5.  Disk Check ^(CHKDSK^)
echo 6.  Repair System Files ^(SFC^)
echo 7.  Restart Explorer
echo 8.  Network Reset
echo 9.  Show Running Tasks
echo 10. Kill Chrome
echo 11. Battery Report
echo 12. Disk Usage
echo 13. Open Control Panel
echo 14. Open Task Manager
echo 15. Open Services
echo 16. Open Device Manager
echo 17. Show Wi-Fi Passwords
echo 18. Restart PC
echo 19. Shutdown PC
echo 20. Exit
echo ==================================================
echo.

set /p choice=Select option: 

if "%choice%"=="1" goto clean_temp
if "%choice%"=="2" goto flush_dns
if "%choice%"=="3" goto ip_info
if "%choice%"=="4" goto sys_info
if "%choice%"=="5" goto disk_check
if "%choice%"=="6" goto sfc_repair
if "%choice%"=="7" goto restart_explorer
if "%choice%"=="8" goto network_reset
if "%choice%"=="9" goto running_tasks
if "%choice%"=="10" goto kill_chrome
if "%choice%"=="11" goto battery_report
if "%choice%"=="12" goto disk_usage
if "%choice%"=="13" goto control_panel
if "%choice%"=="14" goto task_manager
if "%choice%"=="15" goto services
if "%choice%"=="16" goto device_manager
if "%choice%"=="17" goto wifi_passwords
if "%choice%"=="18" goto restart_pc
if "%choice%"=="19" goto shutdown_pc
if "%choice%"=="20" exit

echo Invalid option.
pause
goto menu

:clean_temp
cls
echo Cleaning temporary files...
del /q /f /s "%temp%\*" >nul 2>&1
del /q /f /s "C:\Windows\Temp\*" >nul 2>&1
echo Done.
pause
goto menu

:flush_dns
cls
ipconfig /flushdns
pause
goto menu

:ip_info
cls
ipconfig /all
pause
goto menu

:sys_info
cls
systeminfo
pause
goto menu

:disk_check
cls
chkdsk C:
pause
goto menu

:sfc_repair
cls
sfc /scannow
pause
goto menu

:restart_explorer
cls
taskkill /f /im explorer.exe
start explorer.exe
pause
goto menu

:network_reset
cls
ipconfig /release
ipconfig /renew
ipconfig /flushdns
netsh winsock reset
netsh int ip reset
pause
goto menu

:running_tasks
cls
tasklist
pause
goto menu

:kill_chrome
cls
taskkill /f /im chrome.exe
pause
goto menu

:battery_report
cls
powercfg /batteryreport /output "%USERPROFILE%\Desktop\battery-report.html"
echo Saved on Desktop.
pause
goto menu

:disk_usage
cls
wmic logicaldisk get name,size,freespace
pause
goto menu

:control_panel
control
goto menu

:task_manager
taskmgr
goto menu

:services
services.msc
goto menu

:device_manager
devmgmt.msc
goto menu

:wifi_passwords
cls
echo ======================================
echo       SAVED WIFI PASSWORDS
echo ======================================
for /f "skip=9 tokens=1,2 delims=:" %%A in ('netsh wlan show profiles') do (
    set profile=%%B
    set profile=!profile:~1!
    if not "!profile!"=="" (
        echo.
        echo SSID: !profile!
        for /f "tokens=2 delims=:" %%C in ('netsh wlan show profile name^="!profile!" key^=clear ^| findstr "Key Content"') do (
            set pass=%%C
            set pass=!pass:~1!
            echo Password: !pass!
        )
    )
)
echo.
pause
goto menu

:restart_pc
cls
set /p confirm=Restart PC? (Y/N): 
if /i "%confirm%"=="Y" shutdown /r /t 5
goto menu

:shutdown_pc
cls
set /p confirm=Shutdown PC? (Y/N): 
if /i "%confirm%"=="Y" shutdown /s /t 5
goto menu