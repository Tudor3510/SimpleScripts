@echo off
cd "C:\Program Files (x86)\Microsoft\Edge\Application\"
set /P variable=Enter website URL: 
start msedge.exe --new-window --app="%variable%"