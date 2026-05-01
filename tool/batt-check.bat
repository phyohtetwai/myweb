@echo off
title PC Hardware Check Toolkit
color 0A
setlocal enabledelayedexpansion

:menu
cls
echo ==================================================
echo              PC HARDWARE CHECK TOOLKIT
echo ==================================================
echo.
echo 1. Check Camera
echo 2. Check Microphone
echo 3. Check Speaker
echo 4. Generate Battery Report
echo 5. Show Battery Health
echo 6. Show Battery Cycle Count
echo 7. Full Battery Check
echo 8. Open Sound Settings
echo 9. Open Camera Privacy Settings
echo 10. Exit
echo.
echo ==================================================
set /p choice=Select option: 

if "%choice%"=="1" goto camera
if "%choice%"=="2" goto microphone
if "%choice%"=="3" goto speaker
if "%choice%"=="4" goto battery_report
if "%choice%"=="5" goto battery_health
if "%choice%"=="6" goto cycle_count
if "%choice%"=="7" goto full_battery
if "%choice%"=="8" goto sound_settings
if "%choice%"=="9" goto camera_settings
if "%choice%"=="10" exit

echo Invalid option.
pause
goto menu

:camera
cls
echo Opening Windows Camera app...
echo If camera preview appears, camera is working.
start microsoft.windows.camera:
pause
goto menu

:microphone
cls
echo Opening Microphone test page in Windows Settings...
echo Speak and check if input level moves.
start ms-settings:sound
pause
goto menu

:speaker
cls
echo Testing speaker with beep sound...
powershell -NoProfile -Command "[console]::beep(800,500); Start-Sleep -Milliseconds 200; [console]::beep(1000,500)"
echo If you heard beep sound, speaker is working.
pause
goto menu

:battery_report
cls
echo Generating battery report...
powercfg /batteryreport /output "%USERPROFILE%\Desktop\battery-report.html"
echo Battery report saved to Desktop as battery-report.html
pause
goto menu

:battery_health
cls
echo Checking battery health...
echo.

powershell -NoProfile -Command ^
"$b=Get-CimInstance -Namespace root\wmi -ClassName BatteryFullChargedCapacity -ErrorAction SilentlyContinue; ^
$d=Get-CimInstance -Namespace root\wmi -ClassName BatteryStaticData -ErrorAction SilentlyContinue; ^
if($b -and $d){ ^
$full=$b.FullChargedCapacity; ^
$design=$d.DesignedCapacity; ^
if($design -gt 0){$health=[math]::Round(($full/$design)*100,2)}else{$health='Unknown'}; ^
Write-Host 'Design Capacity     :' $design 'mWh'; ^
Write-Host 'Full Charge Capacity:' $full 'mWh'; ^
Write-Host 'Battery Health      :' $health '%'; ^
}else{Write-Host 'Battery health data not available on this device.'}"

pause
goto menu

:cycle_count
cls
echo Checking battery cycle count...
echo.

powershell -NoProfile -Command ^
"$c=Get-CimInstance -Namespace root\wmi -ClassName BatteryCycleCount -ErrorAction SilentlyContinue; ^
if($c){Write-Host 'Battery Cycle Count:' $c.CycleCount}else{Write-Host 'Cycle count not available on this device.'}"

pause
goto menu

:full_battery
cls
echo Generating full battery report...
echo.

powercfg /batteryreport /output "%USERPROFILE%\Desktop\battery-report.html"

echo.
echo Battery Health:
powershell -NoProfile -Command ^
"$b=Get-CimInstance -Namespace root\wmi -ClassName BatteryFullChargedCapacity -ErrorAction SilentlyContinue; ^
$d=Get-CimInstance -Namespace root\wmi -ClassName BatteryStaticData -ErrorAction SilentlyContinue; ^
if($b -and $d){ ^
$full=$b.FullChargedCapacity; ^
$design=$d.DesignedCapacity; ^
if($design -gt 0){$health=[math]::Round(($full/$design)*100,2)}else{$health='Unknown'}; ^
Write-Host 'Design Capacity     :' $design 'mWh'; ^
Write-Host 'Full Charge Capacity:' $full 'mWh'; ^
Write-Host 'Battery Health      :' $health '%'; ^
}else{Write-Host 'Battery health data not available.'}"

echo.
echo Battery Cycle Count:
powershell -NoProfile -Command ^
"$c=Get-CimInstance -Namespace root\wmi -ClassName BatteryCycleCount -ErrorAction SilentlyContinue; ^
if($c){Write-Host 'Cycle Count:' $c.CycleCount}else{Write-Host 'Cycle count not available.'}"

echo.
echo Battery report saved to Desktop.
pause
goto menu

:sound_settings
start ms-settings:sound
goto menu

:camera_settings
start ms-settings:privacy-webcam
goto menu