*** Settings ***
Library    SeleniumLibrary
Library    String

*** Variables ***
${URL}    https://automationexercise.com
${SIGNUP_NAME}    //*[@data-qa='signup-name']
${SIGNUP_EMAIL}    //*[@data-qa='signup-email']
${SIGNUP_BUTTON}    //*[@data-qa='signup-button']

*** Keywords ***
Open Website
    Open Browser    ${URL}    chrome
    Maximize Browser Window

Click Signup/Login
    Click Element    xpath://a[contains(text(), ' Signup / Login')]

Enter Signup Credentials
    [Arguments]    ${name}    ${email}
    Input Text    xpath:${SIGNUP_NAME}    ${name}
    Input Text    xpath:${SIGNUP_EMAIL}   ${email}

Submit Signup
    Click Button    xpath:${SIGNUP_BUTTON}
    Close Browser

*** Variables ***
${PRODUCT_LINK_PAGE}    //a[@href="/products"]
${SEARCH_INPUT}    //*[@id='search_product']
${SEARCH_BUTTON}   //*[@id='submit_search']
${RESULT_DIV}      //div[@class='features_items']

*** Keywords ***
Search For Product
    [Arguments]    ${product}
    Click Element    xpath:${PRODUCT_LINK_PAGE}
    Input Text    xpath:${SEARCH_INPUT}    ${product}
    Click Button  xpath:${SEARCH_BUTTON}

Verify Product Results Visible
    Wait Until Element Is Visible    xpath:${RESULT_DIV}    timeout=10s
    Element Should Be Visible        xpath:${RESULT_DIV}


*** Keywords ***
Handle Cookie Consent
    Wait Until Element Is Visible    xpath=//*[contains(@class, "fc-button-label") and contains(text(), "Consent")]    timeout=10s
    Click Element                    xpath=//*[contains(@class, "fc-button-label") and contains(text(), "Consent")]
