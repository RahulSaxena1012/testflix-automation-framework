*** Settings ***
Library    SeleniumLibrary
Resource    ../../keywords/ui_keywords.robot
Variables    ../../variables.py

*** Variables ***
${URL}    https://automationexercise.com

*** Test Cases ***
Test Signup Flow
    [Documentation]    This test verifies the user registration process with valid credentials
    [Tags]    signup    regression    ui
    ${random}=    Generate Random String    5
    ${email}=     Set Variable    test_user_${random}@mail.com
    Open Website
    Handle Cookie Consent
    Click Signup/Login
    Enter Signup Credentials    test_user    test_user_${random}@gmail.com
    Submit Signup
