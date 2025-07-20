*** Settings ***
Library    SeleniumLibrary
Resource   ../../keywords/ui_keywords.robot
Variables    ../../variables.py

*** Variables ***
${URL}    https://automationexercise.com

*** Test Cases ***
Test Product Search
    [Documentation]    This test verifies that users can search for products on the website
    [Tags]    smoke    search    ui
    Open Website
    Handle Cookie Consent
    Search For Product    Tshirt
    Verify Product Results Visible
