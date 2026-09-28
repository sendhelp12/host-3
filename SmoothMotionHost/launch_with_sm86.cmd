@echo off
setlocal

set "SM86=C:\Users\jack\AppData\Local\Programs\SmoothMotionSM86\sm86.exe"
set "HOST=%~dp0build\Release\SmoothMotionHost.exe"
set "HOSTDIR=%~dp0build\Release"

if not exist "%SM86%" (
  echo Could not find SM86:
  echo   %SM86%
  pause
  exit /b 1
)

if not exist "%HOST%" (
  echo SmoothMotionHost has not been built yet.
  echo Run build_vs2022.cmd first.
  pause
  exit /b 1
)

"%SM86%" launch --exe "%HOST%" --game-root "%HOSTDIR%" --cwd "%HOSTDIR%"
pause
