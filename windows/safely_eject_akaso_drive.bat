@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "SOURCE_DRIVE="

for /f "usebackq" %%D in (`powershell -NoProfile -Command "(Get-Volume ^| Where-Object { $_.FileSystemLabel -ieq 'akaso' }).DriveLetter"`) do set "SOURCE_DRIVE=%%D"

if not defined SOURCE_DRIVE (
	echo Drive labeled "akaso" was not found.
	exit /b 1
)

echo Ejecting drive !SOURCE_DRIVE!:
powershell -NoProfile -Command "(New-Object -ComObject Shell.Application).Namespace(17).ParseName('!SOURCE_DRIVE!:').InvokeVerb('Eject')"

endlocal
