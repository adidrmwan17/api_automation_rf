*** Settings ***
Documentation   Keywords for Get Status Auth
Resource        ${EXECDIR}/common/keyword/common_keyword.robot
Resource        ${EXECDIR}/variable/user/uri.robot
Variables       ${EXECDIR}/data/user/yaml/user.yaml

*** Keywords ***
User Compare Result For Get Status Auth
    [Arguments]         ${response}
    Run Keyword And Continue On Failure         Should Be Equal As Strings          success get user authtype and phone number          ${response.json()['message']}