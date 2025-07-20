# Simple PowerShell script to open Allure reports
# Usage: .\view-report.ps1

Write-Host "🚀 Opening Allure Report..." -ForegroundColor Green

# Check if allure-results exists
if (-not (Test-Path "allure-results")) {
    Write-Host "❌ No allure-results found. Run tests first with --listener allure_robotframework" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Found allure-results directory" -ForegroundColor Green

# Check if allure command exists
$allureExists = $false
try {
    Get-Command allure -ErrorAction Stop | Out-Null
    $allureExists = $true
} catch {
    $allureExists = $false
}

if ($allureExists) {
    Write-Host "✅ Allure CLI is installed" -ForegroundColor Green
    Write-Host "📊 Starting Allure server..." -ForegroundColor Blue
    Write-Host "Press Ctrl+C to stop the server when done viewing" -ForegroundColor Yellow
    allure serve allure-results
} else {
    Write-Host "❌ Allure CLI not found." -ForegroundColor Red
    Write-Host "Alternative: Opening static report..." -ForegroundColor Yellow
    
    if (Test-Path "allure-report") {
        Write-Host "📂 Opening existing static report..." -ForegroundColor Blue
        Start-Process "allure-report\index.html"
    } else {
        Write-Host "❌ No static report found. Run tests first with --listener allure_robotframework" -ForegroundColor Red
    }
}
