*** Settings ***
Library    SeleniumLibrary
Resource   ../../keywords/ui_keywords.robot
Variables    ../../variables.py

*** Variables ***
${URL}    https://automationexercise.com

*** Test Cases ***
Test Product Search
    Open Website
    Handle Cookie Consent
    Search For Product    Tshirt
    Verify Product Results Visible
