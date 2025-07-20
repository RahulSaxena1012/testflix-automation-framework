# PowerShell script to open Allure reports
# Usage: .\open-allure-report.ps1

Write-Host "🚀 Opening Allure Report..." -ForegroundColor Green

if (Test-Path "allure-results") {
    Write-Host "✅ Found allure-results directory" -ForegroundColor Green
    
    # Check if allure command is available
    try {
        $null = Get-Command allure -ErrorAction Stop
        Write-Host "✅ Allure CLI is installed" -ForegroundColor Green
        
        Write-Host "📊 Starting Allure server..." -ForegroundColor Blue
        Write-Host "Press Ctrl+C to stop the server when done viewing" -ForegroundColor Yellow
        allure serve allure-results
    } catch {
        Write-Host "❌ Allure CLI not found." -ForegroundColor Red
        Write-Host "Alternative: Opening static report..." -ForegroundColor Yellow
        
        if (Test-Path "allure-report") {
            Write-Host "📂 Opening existing static report..." -ForegroundColor Blue
            Start-Process "allure-report\index.html"
        } else {
            Write-Host "❌ No static report found. Run tests first with --listener allure_robotframework" -ForegroundColor Red
        }
    }
} else {
    Write-Host "❌ No allure-results found. Run tests first with --listener allure_robotframework" -ForegroundColor Red
}
