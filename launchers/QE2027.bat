@echo off
rem QE2027 for Windows: double-click this file.
rem Shows a menu, or takes the choice directly:  QE2027.bat start ^| stop ^| update ^| reset ^| shell
rem Each computer keeps its own copy of the system: Stop pauses it, Start resumes it, so apps a
rem student installs stay. Update and Reset replace the copy; dft_work and saved keys are always kept.
setlocal EnableDelayedExpansion

set "IMAGE=ghcr.io/sairajdream/qe2027:latest"
set "NAME=qe2027"
set "PORT=6080"
set "WORK=%USERPROFILE%\dft_work"
set "HERE=%~dp0"
set "URL=http://localhost:%PORT%"

set "ARCH=amd64"
if /i "%PROCESSOR_ARCHITECTURE%"=="ARM64" set "ARCH=arm64"
if /i "%PROCESSOR_ARCHITEW6432%"=="ARM64" set "ARCH=arm64"
rem Optional offline install: qe2027-<arch>.tar.gz next to this file is used instead of downloading
set "TARBALL=%HERE%qe2027-%ARCH%.tar.gz"

rem A fresh Docker Desktop install may not be on PATH until the next sign-in
set "PATH=%PATH%;C:\Program Files\Docker\Docker\resources\bin"

set "CHOICE=%~1"
if "%CHOICE%"=="" (
    echo QE2027
    echo   1^) Start
    echo   2^) Stop
    echo   3^) Update to the latest version
    echo   4^) Reset ^(fresh system, your dft_work files are kept^)
    set "N=1"
    set /p "N=Type a number and press Enter [1]: "
    if "!N!"=="1" set "CHOICE=start"
    if "!N!"=="2" set "CHOICE=stop"
    if "!N!"=="3" set "CHOICE=update"
    if "!N!"=="4" set "CHOICE=reset"
    if "!CHOICE!"=="" (echo Please type 1, 2, 3 or 4.& goto :end)
)

call :ensure_docker || goto :end
if /i "%CHOICE%"=="start"  call :do_start
if /i "%CHOICE%"=="stop"   call :do_stop
if /i "%CHOICE%"=="update" call :do_update
if /i "%CHOICE%"=="reset"  call :do_reset
if /i "%CHOICE%"=="shell" (
    call :do_start >nul
    docker exec -it %NAME% bash -l
)
goto :end

:ensure_docker
where docker >nul 2>&1
if errorlevel 1 (
    echo Docker is not installed. See Step 1: https://github.com/sairajdream/qe2027
    exit /b 1
)
docker info >nul 2>&1 && exit /b 0
echo Starting Docker ^(this can take a minute^)...
if exist "C:\Program Files\Docker\Docker\Docker Desktop.exe" start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
for /l %%i in (1,1,60) do (
    docker info >nul 2>&1 && exit /b 0
    timeout /t 2 /nobreak >nul
)
echo Docker didn't start. Open Docker Desktop, wait until it says "Engine running", then try again.
exit /b 1

:get_image
if exist "%TARBALL%" (
    echo Installing QE2027 from %TARBALL% ^(1-3 minutes^)...
    docker load -i "%TARBALL%"
) else (
    echo Downloading QE2027 ^(about 1.6 GB, one time only^)...
    docker pull %IMAGE%
)
if errorlevel 1 (
    echo Download failed. Check your internet connection and try again.
    exit /b 1
)
exit /b 0

:create
if not exist "%WORK%" mkdir "%WORK%"
docker run -d --init --name %NAME% --hostname qe2027 --shm-size=512m -p 127.0.0.1:%PORT%:6080 -v "%WORK%:/home/student/work" -v qe2027-persist:/home/student/.persist %IMAGE% >nul
if errorlevel 1 (
    echo QE2027 couldn't start. Is something else using port %PORT%?
    exit /b 1
)
exit /b 0

:open_desktop
for /l %%i in (1,1,30) do (
    curl -sf %URL%/vnc.html >nul 2>&1 && goto :opened
    timeout /t 1 /nobreak >nul
)
:opened
echo.
echo QE2027 is running: %URL%
echo Your files: %WORK%
start "" %URL%
exit /b 0

:confirm
set "A="
set /p "A=%~1 Continue? [y/N] "
if /i "!A!"=="y" exit /b 0
if /i "!A!"=="yes" exit /b 0
echo Cancelled. Nothing was changed.
exit /b 1

:do_start
docker image inspect %IMAGE% >nul 2>&1 || (call :get_image || exit /b 1)
docker container inspect %NAME% >nul 2>&1
if errorlevel 1 (
    call :create || exit /b 1
) else (
    docker start %NAME% >nul
    if errorlevel 1 (echo QE2027 couldn't start. Try Reset.& exit /b 1)
)
call :open_desktop
exit /b 0

:do_stop
docker stop -t 5 %NAME% >nul 2>&1
if errorlevel 1 (echo QE2027 is not running.) else (echo Stopped. Everything is kept for next time. Your files are in %WORK%)
exit /b 0

:do_update
if exist "%TARBALL%" (echo This is an offline copy. Ask the instructor for the new version.& exit /b 1)
set "OLD="
for /f "delims=" %%s in ('docker image inspect -f "{{.Id}}" %IMAGE% 2^>nul') do set "OLD=%%s"
echo Checking for a new version...
docker pull %IMAGE%
if errorlevel 1 (echo Download failed. Check your internet connection and try again.& exit /b 1)
set "NEW="
for /f "delims=" %%s in ('docker image inspect -f "{{.Id}}" %IMAGE%') do set "NEW=%%s"
set "CUR="
for /f "delims=" %%s in ('docker container inspect -f "{{.Image}}" %NAME% 2^>nul') do set "CUR=%%s"
if "!CUR!"=="!NEW!" (echo You already have the latest version.& exit /b 0)
if not "!CUR!"=="" (
    call :confirm "Updating gives you a fresh new system. Your dft_work files, GitHub login and keys are kept. Apps you installed yourself must be installed again." || exit /b 1
    docker rm -f %NAME% >nul
)
if not "!OLD!"=="" if not "!OLD!"=="!NEW!" docker rmi !OLD! >nul 2>&1
call :create || exit /b 1
call :open_desktop
exit /b 0

:do_reset
call :confirm "Reset gives you a fresh system, like the first day. Your dft_work files, GitHub login and keys are kept. Apps you installed and changes outside dft_work are removed." || exit /b 1
docker rm -f %NAME% >nul 2>&1
docker image inspect %IMAGE% >nul 2>&1 || (call :get_image || exit /b 1)
call :create || exit /b 1
call :open_desktop
exit /b 0

:end
echo.
if "%~1"=="" pause
