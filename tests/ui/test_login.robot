***Settings***
Library    SeleniumLibrary
Library    OperatingSystem

*** Variables ***
${LOGIN URL}    https://the-internet.herokuapp.com/login

*** Test Cases ***
Valid Login Test
    Open Browser    ${LOGIN URL}    chrome
    Input Text    id=username    tomsmit
    Input Text    id=password    SuperSecretPassword!
    Click Button    class=radius
    Page Should Contain Element    id=flash
    Wait Until Removed
    Close Browser 