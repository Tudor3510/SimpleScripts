@echo off
setlocal

wt ^
  new-tab --title "dumpcap delayed" cmd /k "timeout /t 10 /nobreak && \"%USERPROFILE%\Software\Scripts\dumpcap_capture_ethernet.bat\"" ^
  ; new-tab --title "WSL code-server" wsl -d Ubuntu -- bash -lc "code-server" ^
  ; new-tab --title "CoreDNS" cmd /k "cd /d \"%USERPROFILE%\Software\CoreDNS\" && coredns.exe -conf Corefile" ^
  ; new-tab --title "nginx" powershell -NoExit -EncodedCommand UwBlAHQALQBMAG8AYwBhAHQAaQBvAG4AIAAiACQAZQBuAHYAOgBVAFMARQBSAFAAUgBPAEYASQBMAEUAXABTAG8AZgB0AHcAYQByAGUAXABuAGcAaQBuAHgAXABuAGcAaQBuAHgALQAxAC4AMwAwAC4AMAAiADsAIABTAHQAYQByAHQALQBQAHIAbwBjAGUAcwBzACAALgBcAG4AZwBpAG4AeAAuAGUAeABlADsAIABXAHIAaQB0AGUALQBIAG8AcwB0ACAAJwBuAGcAaQBuAHgAIABzAHQAYQByAHQAZQBkAC4AJwA=

endlocal