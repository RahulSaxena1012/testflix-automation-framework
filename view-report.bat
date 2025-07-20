@echo off
echo 🚀 Opening Allure Report...

if not exist "allure-results" (
    echo ❌ No allure-results found. Run tests first with --listener allure_robotframework
    pause
    exit /b 1
)

echo ✅ Found allure-results directory

REM Try to use allure serve first
allure --version >nul 2>&1
if %ERRORLEVEL% == 0 (
    echo ✅ Allure CLI is installed
    echo 📊 Starting Allure server...
    echo Press Ctrl+C to stop the server when done viewing
    allure serve allure-results
) else (
    echo ❌ Allure CLI not found
    echo Alternative: Opening static report...
    
    if exist "allure-report\index.html" (
        echo 📂 Opening existing static report...
        start allure-report\index.html
    ) else (
        echo ❌ No static report found. Generating one now...
        echo You can install Allure CLI for better experience
        echo For now, opening the static HTML report from Robot Framework
        if exist "results\log.html" (
            start results\log.html
        ) else (
            echo ❌ No reports found. Please run tests first.
        )
    )
)
pause
