*** Settings ***
Library    SeleniumLibrary
Suite Setup    Setup Chrome Options
Resource    ../../keywords/ui_keywords.robot
Variables    ../../variables.py

*** Keywords ***
Setup Chrome Options
    ${random_dir}=    Generate Random String    8
    ${user_data_dir}=    Set Variable    /tmp/chrome-user-data-${random_dir}
    ${user_data_arg}=    Set Variable    --user-data-dir=${user_data_dir}
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${options}    add_argument    --headless
    Call Method    ${options}    add_argument    --no-sandbox
    Call Method    ${options}    add_argument    --disable-dev-shm-usage
    Call Method    ${options}    add_argument    ${user_data_arg}
    Create WebDriver    Chrome    options=${options}

*** Variables ***
${URL}    https://automationexercise.com

*** Test Cases ***
Test Signup Flow
    [Documentation]    This test verifies the user registration process with valid credentials
    [Tags]    signup    regression    ui
    ${random}=    Generate Random String    5
    ${email}=     Set Variable    test_user_${random}@mail.com
    Setup Chrome Options
    Go To    ${URL}
    Handle Cookie Consent
    Click Signup/Login
    Enter Signup Credentials    test_user    test_user_${random}@gmail.com
    Submit Signup
