@echo off

if "%~1"=="" goto noparameter
if "%~1"=="/?" goto noparameter
if "%~1"=="-h" goto noparameter
if "%~1"=="--help" goto noparameter
if NOT EXIST "%~1" goto noparameter

for /F "delims=" %%i in ("%~1") do set "_playlist=%%~ni.lpl"
(
  echo {
  echo   "version": "1.0",
  echo   "items": [
) >"%_playlist%"
set /A "_numroms=0"
for /F "usebackq tokens=*" %%A in ("%~1") do set /A "_numroms+=1"
setlocal EnableDelayedExpansion
set /A "_currentrom=0"
for /F "usebackq tokens=*" %%A in ("%~1") do (
  set /A "_currentrom+=1"
  set rompath=%%A
  set escaped=!rompath:\=\\!
  set romname=
  for /F "delims=" %%i in ("!rompath!") do set romname=%%~ni
  set "line1=    {"
  set "line2=      "path": "!escaped!","
  set "line3=      "label": "!romname!","
  set "line4=      "core_path": "DETECT","
  set "line5=      "core_name": "DETECT","
  set "line6=      "crc32": "DETECT","
  set "line7=      "db_name": "!_playlist!""
  if !_currentrom! LSS %_numroms% (set "line8=    },") else (set "line8=    }")
  (
    echo !line1!
    echo !line2!
    echo !line3!
    echo !line4!
    echo !line5!
    echo !line6!
    echo !line7!
    echo !line8!
  ) >>"%_playlist%"
)
endlocal
(
  echo   ]
  echo }
) >>"%_playlist%"
echo Processed %_numroms% entries and saved to "%_playlist%".
dos2unix "%_playlist%"
set _numroms=
set _playlist=
goto exit

:noparameter
echo.
echo Creates basic RetroArch playlists from text 
echo files containing a list of roms with their 
echo full paths. Uses dos2unix to convert the 
echo output file so that it's compatible with 
echo RetroArch.
echo.
echo Usage: raplaylist [playlistname.txt]
echo.

:exit
