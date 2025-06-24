@echo off
REM ===============================================
REM Windows Update Reset Script with Logging & Caution
REM ===============================================
REM This script will reset Windows Update components,
REM stop and restart services, clear update cache, and reregister DLLs.
REM RUN THIS SCRIPT AS ADMINISTRATOR!
REM A log file will be created: %USERPROFILE%\windows-update-reset.log

setlocal enabledelayedexpansion
set LOGFILE=%USERPROFILE%\windows-update-reset.log

echo ============================================== > "%LOGFILE%"
echo Windows Update Reset Log - %DATE% %TIME% >> "%LOGFILE%"
echo ============================================== >> "%LOGFILE%"

echo.
echo [CAUTION] This script will stop Windows Update services, clear update cache, and reset related components.
echo If Windows Update is currently running, please cancel updates before continuing.
echo If you are not comfortable with system maintenance, consult your administrator.
echo.
pause

REM Stop update-related services
set SVC=bits wuauserv appidsvc cryptsvc
for %%S in (%SVC%) do (
    echo Stopping service: %%S...
    echo Stopping service: %%S... >> "%LOGFILE%"
    net stop %%S >> "%LOGFILE%" 2>&1
)

REM Delete update cache files
echo Deleting qmgr*.dat files...
echo Deleting qmgr*.dat files... >> "%LOGFILE%"
del /s /q /f "%ALLUSERSPROFILE%\Microsoft\Network\Downloader\qmgr*.dat" >> "%LOGFILE%" 2>&1

echo Renaming SoftwareDistribution and Catroot2 folders...
echo Renaming SoftwareDistribution and Catroot2 folders... >> "%LOGFILE%"
ren "%SYSTEMROOT%\SoftwareDistribution" SoftwareDistribution.bak >> "%LOGFILE%" 2>&1
ren "%SYSTEMROOT%\System32\catroot2" catroot2.bak >> "%LOGFILE%" 2>&1

REM Reset Windows Update services security descriptors
echo Resetting Update services security descriptors... >> "%LOGFILE%"
sc.exe sdset wuauserv D:(A;;CCLCSWLOCRRC;;;AU)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCDCLCSWRPWPDTLCRSDRCWDWO;;;SO)(A;;CCLCSWRPWPDTLOCRRC;;;SY)S:(AU;FA;CCDCLCSWRPWPDTLOCRSDRCWDWO;;WD) >> "%LOGFILE%" 2>&1
sc.exe sdset bits D:(A;;CCLCSWLOCRRC;;;AU)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCDCLCSWRPWPDTLCRSDRCWDWO;;;SO)(A;;CCLCSWRPWPDTLOCRRC;;;SY)S:(AU;FA;CCDCLCSWRPWPDTLOCRSDRCWDWO;;WD) >> "%LOGFILE%" 2>&1
sc.exe sdset cryptsvc D:(A;;CCLCSWLOCRRC;;;AU)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCDCLCSWRPWPDTLCRSDRCWDWO;;;SO)(A;;CCLCSWRPWPDTLOCRRC;;;SY)S:(AU;FA;CCDCLCSWRPWPDTLOCRSDRCWDWO;;WD) >> "%LOGFILE%" 2>&1

REM (Optional) Reregister update DLLs - only for advanced users, can be skipped on modern Windows
echo Re-registering Windows Update DLLs... >> "%LOGFILE%"
for %%D in (atl.dll urlmon.dll mshtml.dll shdocvw.dll browseui.dll jscript.dll vbscript.dll scrrun.dll msxml.dll msxml3.dll msxml6.dll actxprxy.dll softpub.dll wintrust.dll dssenh.dll rsaenh.dll gpkcsp.dll sccbase.dll slbcsp.dll cryptdlg.dll oleaut32.dll ole32.dll shell32.dll wuapi.dll wuaueng.dll wucltui.dll wups.dll wups2.dll wuweb.dll qmgr.dll qmgrprxy.dll wucltux.dll muweb.dll wuwebv.dll) do (
    regsvr32.exe /s %%D >> "%LOGFILE%" 2>&1
)

REM Reset Winsock
echo Resetting Winsock...
echo Resetting Winsock... >> "%LOGFILE%"
netsh winsock reset >> "%LOGFILE%" 2>&1
netsh winsock reset proxy >> "%LOGFILE%" 2>&1

REM Set services to automatic
echo Configuring services to automatic start... >> "%LOGFILE%"
sc.exe config wuauserv start= auto >> "%LOGFILE%" 2>&1
sc.exe config bits start= delayed-auto >> "%LOGFILE%" 2>&1
sc.exe config cryptsvc start= auto >> "%LOGFILE%" 2>&1

REM Start services
for %%S in (%SVC%) do (
    echo Starting service: %%S...
    echo Starting service: %%S... >> "%LOGFILE%"
    net start %%S >> "%LOGFILE%" 2>&1
)

echo ============================================== >> "%LOGFILE%"
echo Windows Update reset completed at %DATE% %TIME% >> "%LOGFILE%"
echo ============================================== >> "%LOGFILE%"

echo.
echo [DONE] Windows Update reset complete! Log: %LOGFILE%
echo It is recommended to restart your computer before checking for updates.
pause