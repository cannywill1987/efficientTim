@echo off
setlocal
set APP_EXE=%~dp0\timerbell windows\timehello.exe
if not exist "%APP_EXE%" set APP_EXE=C:\Users\Admin\Desktop\?????windows\timerbell windows\timehello.exe
if not exist "%APP_EXE%" (
  echo [ERROR] Not found packaged app: %~dp0\timerbell windows\timehello.exe
  exit /b 1
)
start "" "%APP_EXE%"
exit /b 0
