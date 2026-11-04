@echo off
rem QE2027 launcher for Windows. Used by "Start QE2027.bat" and "Stop QE2027.bat".
rem   start_qe2027.bat          browser desktop (normal use)
rem   start_qe2027.bat shell    plain terminal in the same environment
rem   start_qe2027.bat stop     stop the environment
setlocal EnableDelayedExpansion

set "IMAGE=qe2027:1.0"
set "NAME=qe2027"
set "PORT=6080"
set "WORK=%USERPROFILE%\dft_work"
set "HERE=%~dp0"
set "URL=http://localhost:%PORT%"

set "ARCH=amd64"
if /i "%PROCESSOR_ARCHITECTURE%"=="ARM64" set "ARCH=arm64"
if /i "%PROCESSOR_ARCHITEW6432%"=="ARM64" set "ARCH=arm64"
set "TARBALL=%HERE%qe2027-%ARCH%.tar.gz"

rem A fresh Docker Desktop install may not be on PATH until the next sign-in
set "PATH=%PATH%;C:\Program Files\Docker\Docker\resources\bin"

where docker >nul 2>&1
if errorlevel 1 (
    echo Docker Desktop is not installed. See the instructions: https://github.com/sairajdream/qe2027
    exit /b 1
)
docker info >nul 2>&1
if errorlevel 1 (
    echo Docker isn't running yet; starting Docker Desktop ^(this can take a minute^)...
    if exist "C:\Program Files\Docker\Docker\Docker Desktop.exe" start "" "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    for /l %%i in (1,1,60) do (
        docker info >nul 2>&1 && goto :docker_ok
        timeout /t 2 /nobreak >nul
    )
    echo Docker didn't start. Open Docker Desktop, wait until it says "Engine running", then try again.
    exit /b 1
)
:docker_ok

if /i "%~1"=="stop" (
    docker rm -f %NAME% >nul 2>&1
    if errorlevel 1 (echo Not running.) else (echo Stopped. Your files are still in %WORK%)
    exit /b 0
)

rem Load the image once (from the file shared with you)
docker image inspect %IMAGE% >nul 2>&1
if errorlevel 1 (
    if not exist "%TARBALL%" (
        if exist "%HERE%qe2027-*.tar.gz" (
            echo This is the wrong download for your computer. Check the instructions for which zip you need.
        ) else (
            echo Can't find %TARBALL% ^(keep it in the same folder as this file^).
        )
        exit /b 1
    )
    echo Loading QE2027 ^(one time only, takes 1-3 minutes^)...
    docker load -i "%TARBALL%"
    if errorlevel 1 exit /b 1
)

if not exist "%WORK%" mkdir "%WORK%"

rem Start the container unless it's already running this version (an older version gets replaced)
set "STATE="
for /f "delims=" %%s in ('docker inspect -f "{{.State.Running}} {{.Config.Image}}" %NAME% 2^>nul') do set "STATE=%%s"
if not "!STATE!"=="true %IMAGE%" (
    docker rm -f %NAME% >nul 2>&1
    docker run -d --init --name %NAME% --hostname qe2027 --shm-size=512m -p 127.0.0.1:%PORT%:6080 -v "%WORK%:/home/student/work" -v qe2027-persist:/home/student/.persist %IMAGE% >nul
    if errorlevel 1 exit /b 1
    for /l %%i in (1,1,30) do (
        curl -sf %URL%/vnc.html >nul 2>&1 && goto :started
        timeout /t 1 /nobreak >nul
    )
)
:started

if /i "%~1"=="shell" (
    docker exec -it %NAME% bash -l
    exit /b 0
)

echo QE2027 is running: %URL%
echo Your files: %WORK%
start "" %URL%
