@echo off
setlocal
set "HOST=%~dp0build\Release\SmoothMotionHost.exe"
if not exist "%HOST%" (
  echo SmoothMotionHost has not been built yet.
  echo Run build_vs2022.cmd first.
  pause
  exit /b 1
)
"%HOST%"
pause
