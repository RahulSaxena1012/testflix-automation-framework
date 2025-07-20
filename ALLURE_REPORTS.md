# Allure Reporting

This project is configured to generate beautiful Allure reports for test results.

## Features

- **Interactive HTML reports** with test results, screenshots, and logs
- **Test history trends** showing pass/fail rates over time
- **Test categorization** by tags (smoke, regression, ui, etc.)
- **Detailed test documentation** and steps
- **GitHub Pages deployment** for easy access to reports

## Local Usage

### Generate Allure Results
```bash
# Run tests with Allure listener
robot --listener allure_robotframework -d results tests/ui

# Run specific test with headless mode
robot --variable HEADLESS:true --listener allure_robotframework -d results tests/ui/test_search.robot
```

### View Allure Reports Locally
You need to install Allure command line tool:

```bash
# Install Allure (requires Java)
# On Windows with Chocolatey:
choco install allure

# On Mac with Homebrew:
brew install allure

# On Linux:
wget https://github.com/allure-framework/allure2/releases/download/2.24.0/allure-2.24.0.tgz
tar -zxf allure-2.24.0.tgz
sudo mv allure-2.24.0 /opt/allure
sudo ln -s /opt/allure/bin/allure /usr/bin/allure
```

Generate and serve the report:
```bash
# Generate report from results
allure generate allure-results --clean -o allure-report

# Serve report locally
allure serve allure-results
```

## CI/CD Integration

The GitHub Actions workflow automatically:
1. Runs tests with Allure listener
2. Generates Allure reports
3. Publishes reports to GitHub Pages
4. Uploads raw results as artifacts

## Accessing Reports

- **GitHub Pages**: `https://rahulsaxena1012.github.io/testflix-automation-framework/`
- **Artifacts**: Download from GitHub Actions runs
- **Local**: Use `allure serve allure-results` command

## Test Annotations

Tests include metadata for better reporting:
- `[Documentation]`: Test description
- `[Tags]`: Test categories (smoke, regression, ui, etc.)
- Screenshots on failure (automatic)
- Step-by-step execution details
