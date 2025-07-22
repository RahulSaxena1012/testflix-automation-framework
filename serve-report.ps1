# PowerShell script to serve downloaded Allure reports
# Usage: .\serve-report.ps1 [path-to-extracted-report]

param(
    [string]$ReportPath = "."
)

Write-Host "🚀 Starting HTTP server for Allure report..." -ForegroundColor Green

# Check if path exists and has index.html
if (-not (Test-Path "$ReportPath\index.html")) {
    Write-Host "❌ No index.html found in $ReportPath" -ForegroundColor Red
    Write-Host "Please extract the allure-html-report.zip and run this script from that folder" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Found Allure report in: $ReportPath" -ForegroundColor Green

# Start Python HTTP server
try {
    Write-Host "📊 Starting server at http://localhost:8000" -ForegroundColor Blue
    Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
    Write-Host "Opening browser..." -ForegroundColor Green
    
    # Open browser after short delay
    Start-Process "http://localhost:8000"
    
    # Start HTTP server (Python 3)
    python -m http.server 8000 --directory $ReportPath
} catch {
    Write-Host "❌ Python not found. Trying alternative..." -ForegroundColor Red
    
    # Try PHP if available
    try {
        php -S localhost:8000 -t $ReportPath
    } catch {
        Write-Host "❌ Neither Python nor PHP found." -ForegroundColor Red
        Write-Host "Please install Python or use the allure serve command instead" -ForegroundColor Yellow
    }
}
