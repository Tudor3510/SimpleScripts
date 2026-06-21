@echo off
setlocal EnableDelayedExpansion

:: Path to dumpcap (change if needed)
set DUMPCAP=dumpcap

:: Capture folder
set CAPTURE_DIR=%USERPROFILE%\WiresharkCaptures

:: Create capture folder if it doesn't exist
if not exist "%CAPTURE_DIR%" mkdir "%CAPTURE_DIR%"

:: Find a physical Ethernet interface
set IFACE_NUM=

for /f "tokens=1 delims=." %%A in ('
    %DUMPCAP% -D ^| findstr /I "Ethernet" ^| findstr /I /V "vEthernet Hyper-V"
') do (
    set IFACE_NUM=%%A
    goto :found
)

:found
if not defined IFACE_NUM (
    echo ERROR: No suitable Ethernet interface found.
    exit /b 1
)

echo Using interface %IFACE_NUM%
echo Saving captures to %CAPTURE_DIR%
echo.

pushd "%CAPTURE_DIR%"

%DUMPCAP% -i %IFACE_NUM% ^
-f "tcp and dst host 192.168.100.197 and (dst port 8978 or dst port 8993 or dst port 8994 or dst port 8997)" ^
-P ^
-b filesize:400000 ^
-b files:10 ^
-w capture.pcap

popd