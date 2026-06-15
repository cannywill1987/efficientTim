@echo off
setlocal
set "ISS="
for %%F in ("%~dp0inno*.iss") do if not defined ISS set "ISS=%%~fF"
if not defined ISS (
  echo [ERROR] No inno*.iss file found under %~dp0
  exit /b 2
)
set "ISCC="
if defined INNO_SETUP_EXE if exist "%INNO_SETUP_EXE%" set "ISCC=%INNO_SETUP_EXE%"
if not defined ISCC if exist "%ProgramFiles(x86)%\Inno Setup 6\iscc.exe" set "ISCC=%ProgramFiles(x86)%\Inno Setup 6\iscc.exe"
if not defined ISCC if exist "%ProgramFiles%\Inno Setup 6\iscc.exe" set "ISCC=%ProgramFiles%\Inno Setup 6\iscc.exe"
if not defined ISCC if exist "%LocalAppData%\Programs\Inno Setup 6\iscc.exe" set "ISCC=%LocalAppData%\Programs\Inno Setup 6\iscc.exe"
if not defined ISCC (
  echo [ERROR] Inno Setup 6 not found.
  echo [INFO] Install it first: https://jrsoftware.org/isinfo.php
  echo [INFO] Or set INNO_SETUP_EXE to the full path of iscc.exe.
  exit /b 1
)
if not exist "%ISS%" (
  echo [ERROR] Missing script: %ISS%
  exit /b 3
)
"%ISCC%" "%ISS%"
exit /b %errorlevel%
