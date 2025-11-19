@echo off
set "steamcss=C:\Program Files (x86)\Steam\steamui\css\chunk~2dcc5aaf7.css"
set "missingcss="
if not exist "%steamcss%.backup" set "missingcss=1"
if not exist "%steamcss%" set "missingcss=1"
if defined missingcss (
  set "missingcss="
  echo The Steam css file or its backup could not be found. 
  echo.
  echo Please run steamcsspatcher.ps1 first to generate the backup file.
  goto exit
)
if not exist "%steamcss%.modded" (
  copy /y /l "%steamcss%" "%steamcss%.modded"
  echo.
  echo Created .modded backup file.
)
ver>nul
fc "%steamcss%" "%steamcss%.modded">nul
if errorlevel 1 (
  ver>nul
  fc "%steamcss%" "%steamcss%.backup">nul
  if errorlevel 1 (
    copy /y /l "%steamcss%" "%steamcss%.modded"
    echo.
    echo Updated .modded backup file.
    copy /y /l "%steamcss%.backup" "%steamcss%"
    echo.
    echo Now using original css.
  ) else (
    copy /y /l "%steamcss%.modded" "%steamcss%"
    echo.
    echo Now using modded css.
  )
) else (
  copy /y /l "%steamcss%.backup" "%steamcss%"
  echo.
  echo Now using original css.
)
goto exit

:exit
timeout 4