@echo off
REM ================================
REM Windows System Cleanup Script
REM ================================
REM This script deletes temporary files, clears the recycle bin, prefetch, and other junk.
REM RUN THIS SCRIPT AS ADMINISTRATOR!
REM A log file will be created: %USERPROFILE%\windows-cleanup.log

setlocal enabledelayedexpansion
set LOGFILE=%USERPROFILE%\windows-cleanup.log

echo =============================== > "%LOGFILE%"
echo Windows Cleanup Log - %DATE% %TIME% >> "%LOGFILE%"
echo =============================== >> "%LOGFILE%"

echo.
echo [CAUTION] This script will permanently delete temporary files, prefetch, Recycle Bin, and more.
echo Make sure you have saved all work and closed applications.
pause

REM Clean Windows Temp
echo Cleaning Windows Temp directory...
echo Cleaning Windows Temp directory... >> "%LOGFILE%"
del /s /f /q C:\Windows\Temp\*.* >> "%LOGFILE%" 2>&1
rd /s /q C:\Windows\Temp >> "%LOGFILE%" 2>&1
md C:\Windows\Temp

REM Clean User Temp
echo Cleaning User Temp directory...
echo Cleaning User Temp directory... >> "%LOGFILE%"
del /s /f /q "%temp%\*.*" >> "%LOGFILE%" 2>&1
rd /s /q "%temp%" >> "%LOGFILE%" 2>&1
md "%temp%"

REM Clean Prefetch
echo Cleaning Prefetch...
echo Cleaning Prefetch... >> "%LOGFILE%"
del /s /f /q C:\Windows\Prefetch\*.* >> "%LOGFILE%" 2>&1

REM Clean Recent Files
echo Cleaning Recent Files...
echo Cleaning Recent Files... >> "%LOGFILE%"
del /s /f /q "%APPDATA%\Microsoft\Windows\Recent\*.*" >> "%LOGFILE%" 2>&1

REM Clean Recycle Bin
echo Emptying Recycle Bin...
echo Emptying Recycle Bin... >> "%LOGFILE%"
powershell.exe -NoProfile -Command "Clear-RecycleBin -Force" >> "%LOGFILE%" 2>&1

REM Clean Spool Printers
echo Cleaning Spool Printers...
echo Cleaning Spool Printers... >> "%LOGFILE%"
del /s /f /q C:\Windows\System32\spool\PRINTERS\*.* >> "%LOGFILE%" 2>&1

REM Clean Thumbnail Cache
echo Cleaning Thumbnail Cache...
echo Cleaning Thumbnail Cache... >> "%LOGFILE%"
del /s /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" >> "%LOGFILE%" 2>&1

REM Optional: Clean event logs (Uncomment next lines to enable)
REM echo Cleaning Event Logs... >> "%LOGFILE%"
REM wevtutil el | ForEach-Object {wevtutil cl "$_"} >> "%LOGFILE%" 2>&1

REM Show disk usage after cleanup
echo Disk usage after cleanup: >> "%LOGFILE%"
wmic logicaldisk get size,freespace,caption >> "%LOGFILE%" 2>&1

echo =============================== >> "%LOGFILE%"
echo Cleanup completed at %DATE% %TIME% >> "%LOGFILE%"
echo =============================== >> "%LOGFILE%"

echo.
echo Cleanup complete! Log file: %LOGFILE%
pause