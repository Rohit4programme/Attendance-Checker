# Attendance & Proxy Management System - Automated Setup & Run (PowerShell)
# This script downloads Maven and launches the application

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Attendance System Setup (PowerShell)" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Define Maven paths
$MAVEN_HOME = "C:\Apache\Maven\apache-maven-3.9.6"
$MAVEN_BIN = "$MAVEN_HOME\bin\mvn.cmd"

# Check if Maven is already in PATH
$mvnExists = $null
try {
    $mvnExists = mvn --version 2>$null
    if ($mvnExists) {
        Write-Host "Maven found in PATH. Skipping download." -ForegroundColor Green
        goto RunApp
    }
} catch { }

# Check if Maven is installed locally
if (Test-Path $MAVEN_BIN) {
    Write-Host "Maven found locally at $MAVEN_HOME" -ForegroundColor Green
    goto RunApp
}

# Maven not found - offer to download
Write-Host "Maven is not installed on this system.`n" -ForegroundColor Yellow
Write-Host "Options:" -ForegroundColor Cyan
Write-Host "  1) Download Apache Maven 3.9.6 from online source (automated)"
Write-Host "  2) Manual install (go to https://maven.apache.org/download.cgi)"
Write-Host "  3) Cancel`n"

$choice = Read-Host "Enter your choice (1-3)"

switch ($choice) {
    "1" { goto DownloadMaven }
    "2" { goto ManualInstall }
    "3" { 
        Write-Host "Setup cancelled." -ForegroundColor Yellow
        exit 0
    }
    default { 
        Write-Host "Invalid choice. Proceeding to run application..." -ForegroundColor Yellow
        goto RunApp
    }
}

:DownloadMaven
Write-Host "`nChecking Internet connection..." -ForegroundColor Cyan
try {
    $testConn = Test-Connection -ComputerName archive.apache.org -Count 1 -ErrorAction Stop
    Write-Host "Connection OK" -ForegroundColor Green
} catch {
    Write-Host "Error: Cannot reach Apache servers. Check your internet connection." -ForegroundColor Red
    goto ManualInstall
}

Write-Host "`nDownloading Maven 3.9.6 (this will take 1-2 minutes)..." -ForegroundColor Cyan
Write-Host "Source: https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/`n" -ForegroundColor Gray

# Create Maven directory
if (-not (Test-Path "C:\Apache\Maven")) {
    New-Item -ItemType Directory -Path "C:\Apache\Maven" -Force | Out-Null
}

# Download Maven using PowerShell
try {
    $progressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri 'https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip' `
        -OutFile 'C:\Apache\Maven\maven.zip' -UseBasicParsing
    Write-Host "Download completed." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Maven download failed!" -ForegroundColor Red
    Write-Host "Error details: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Please download manually from: https://maven.apache.org/download.cgi" -ForegroundColor Yellow
    goto ManualInstall
}

if (-not (Test-Path "C:\Apache\Maven\maven.zip")) {
    Write-Host "ERROR: Maven file not found after download!" -ForegroundColor Red
    goto ManualInstall
}

Write-Host "Extracting Maven..." -ForegroundColor Cyan
try {
    Expand-Archive -Path 'C:\Apache\Maven\maven.zip' -DestinationPath 'C:\Apache\Maven' -Force
    Write-Host "Extraction completed." -ForegroundColor Green
} catch {
    Write-Host "ERROR: Maven extraction failed!" -ForegroundColor Red
    Write-Host "Error details: $($_.Exception.Message)" -ForegroundColor Red
    Remove-Item -Path 'C:\Apache\Maven\maven.zip' -Force -ErrorAction SilentlyContinue
    goto ManualInstall
}

if (-not (Test-Path $MAVEN_BIN)) {
    Write-Host "ERROR: Maven binary not found after extraction!" -ForegroundColor Red
    goto ManualInstall
}

Remove-Item -Path 'C:\Apache\Maven\maven.zip' -Force -ErrorAction SilentlyContinue

Write-Host "Adding Maven to PATH..." -ForegroundColor Cyan
try {
    [Environment]::SetEnvironmentVariable('MAVEN_HOME', $MAVEN_HOME, 'User')
    $currentPath = [Environment]::GetEnvironmentVariable('PATH', 'User')
    if ($currentPath -notlike "*$MAVEN_HOME\bin*") {
        [Environment]::SetEnvironmentVariable('PATH', "$currentPath;$MAVEN_HOME\bin", 'User')
    }
    Write-Host "PATH updated successfully!" -ForegroundColor Green
} catch {
    Write-Host "Warning: Could not update PATH automatically" -ForegroundColor Yellow
}

Write-Host "`nMaven setup complete!" -ForegroundColor Green
Write-Host "Refreshing environment variables..." -ForegroundColor Cyan

# Refresh environment
$env:MAVEN_HOME = $MAVEN_HOME
$env:PATH = "$env:PATH;$MAVEN_HOME\bin"

:RunApp
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Starting Attendance System" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$projectPath = Split-Path -Parent $MyInvocation.MyCommand.Path

try {
    if (Test-Path $MAVEN_BIN) {
        Write-Host "Using Maven at: $MAVEN_HOME" -ForegroundColor Gray
        & $MAVEN_BIN javafx:run -f "$projectPath\pom.xml"
    } else {
        Write-Host "Using system Maven..." -ForegroundColor Gray
        & mvn javafx:run -f "$projectPath\pom.xml"
    }
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n========================================" -ForegroundColor Green
        Write-Host "  Application started successfully!" -ForegroundColor Green
        Write-Host "========================================`n" -ForegroundColor Green
    } else {
        Write-Host "`nERROR: Failed to start application (Exit code: $LASTEXITCODE)" -ForegroundColor Red
        Write-Host "Check the error messages above." -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
} catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

exit 0

:ManualInstall
Write-Host "`nManual Setup Steps:" -ForegroundColor Yellow
Write-Host "
1. Download from: https://maven.apache.org/download.cgi
   (Select 'Apache Maven 3.9.6' Binary zip)

2. Extract to: C:\Apache\Maven\
   Result: C:\Apache\Maven\apache-maven-3.9.6\

3. Add to Windows PATH:
   - Right-click 'This PC' > Properties
   - Click 'Advanced system settings'
   - Click 'Environment Variables'
   - Click 'New' under System variables
   - Variable name: MAVEN_HOME
   - Variable value: C:\Apache\Maven\apache-maven-3.9.6
   - Click OK
   - Find 'Path' variable, click Edit
   - Click 'New' and add: C:\Apache\Maven\apache-maven-3.9.6\bin
   - Click OK on all dialogs

4. Restart PowerShell/Command Prompt (completely close and reopen)

5. Run: mvn javafx:run
   (from project directory: d:\Kratos\WUSHANG CHAN)
" -ForegroundColor Gray

$choice = Read-Host "`nAfter manual install, run this script again? (y/n)"
if ($choice -eq 'y') {
    exit 0
} else {
    exit 0
}
