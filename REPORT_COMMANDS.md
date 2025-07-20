# 📊 Quick Commands to Open Allure Reports

## **Method 1: Interactive Server (Recommended)**
```powershell
allure serve allure-results
```
- Opens in browser automatically
- Interactive and real-time
- Press Ctrl+C to stop

## **Method 2: Static HTML Report**
```powershell
# Generate report
allure generate allure-results --clean -o allure-report

# Open in browser
Invoke-Item allure-report\index.html
```

## **Method 3: One-liner for Static Report**
```powershell
allure generate allure-results --clean -o allure-report; Invoke-Item allure-report\index.html
```

## **Method 4: From CI/CD Artifacts**
1. Go to GitHub Actions → Latest workflow run
2. Download `allure-html-report` artifact
3. Extract and open `index.html`

## **What You'll See in Reports:**
- ✅ Test execution overview with pass/fail stats
- 📈 Trend graphs and test stability metrics  
- 🏷️ Test categories by tags (smoke, regression, ui)
- 📝 Detailed test steps with timestamps
- 🖼️ Screenshots on failures (if available)
- ⏱️ Execution time analysis
- 📊 Beautiful interactive charts

## **Troubleshooting:**
- If `allure` command not found: `pip install allure-robotframework`
- If no `allure-results`: Run tests with `--listener allure_robotframework`
- If static report doesn't open: Check Windows file associations for .html files

## **Quick Test + Report Workflow:**
```powershell
# Run test with Allure reporting (correct syntax)
robot --listener "allure_robotframework:./allure-results" -d results tests/ui

# Open report immediately  
allure serve allure-results
```

## **Fixed Commands:**
```powershell
# Clean previous results
Remove-Item allure-results -Recurse -Force -ErrorAction SilentlyContinue

# Run with proper Allure listener
robot --listener "allure_robotframework:./allure-results" -d results tests/ui

# View report
allure serve allure-results
```
