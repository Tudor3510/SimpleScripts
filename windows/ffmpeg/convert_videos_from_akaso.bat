@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "DEST=D:\IesitAfara"
set "FFMPEG=C:\Users\tudor\Software\LosslessCut\LosslessCut-win-x64\resources\ffmpeg.exe"
set "SOURCE_DRIVE="

for /f "usebackq" %%D in (`powershell -NoProfile -Command "(Get-Volume | Where-Object { $_.FileSystemLabel -ieq 'akaso' }).DriveLetter"`) do set "SOURCE_DRIVE=%%D"

if not defined SOURCE_DRIVE (
	echo Drive labeled "akaso" was not found.
	exit /b 1
)

set "SOURCE_DIR=%SOURCE_DRIVE%:\VIDEO"

if not exist "%SOURCE_DIR%\" (
	echo Source folder not found: "%SOURCE_DIR%"
	exit /b 1
)

if not exist "%DEST%\" mkdir "%DEST%"

for /r "%SOURCE_DIR%" %%F in (*.MOV) do (
	set "OUTFILE=%DEST%\%%~nF.mkv"
	echo Converting "%%~fF" to "!OUTFILE!"
	"%FFMPEG%" -i "%%~fF" -s 640x360 -r 10 -c:v libsvtav1 -preset 7 -crf 60 -c:a copy "!OUTFILE!"
	if errorlevel 1 echo Failed converting "%%~fF"
)

echo Done.
endlocal
