@echo off
REM Attendance & Proxy Management System - Launcher
REM This script builds and runs the JavaFX application

setlocal enabledelayedexpansion

REM Set Maven home (adjust if Maven is installed elsewhere)
if defined MAVEN_HOME (
    set "MVN_CMD=!MAVEN_HOME!\bin\mvn.cmd"
) else if exist "C:\Apache\Maven\apache-maven-3.9.6" (
    set "MVN_CMD=C:\Apache\Maven\apache-maven-3.9.6\bin\mvn.cmd"
) else (
    REM Try to find mvn in PATH
    for /f "delims=" %%A in ('where mvn.cmd 2^>nul') do set "MVN_CMD=%%A"
)

if not defined MVN_CMD (
    echo.
    echo ERROR: Maven not found!
    echo Please install Maven or set MAVEN_HOME environment variable
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo   Attendance ^& Proxy Management System
echo   Starting application...
echo ============================================================
echo.

REM Change to script directory
cd /d "%~dp0"

REM Run Maven with JavaFX plugin
"%MVN_CMD%" clean javafx:run

if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: Application failed to start
    echo.
    pause
)

endlocal
