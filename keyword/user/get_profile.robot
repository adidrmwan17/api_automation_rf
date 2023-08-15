*** Settings ***
Documentation   Keywords for Get Profile
Resource        ${EXECDIR}/common/keyword/common_keyword.robot
Variables       ${EXECDIR}/data/user/yaml/user.yaml

*** Keywords ***
User Compare Result For Get Profile
    [Arguments]         ${response}
    Run Keyword And Continue On Failure         Should Be Equal As Strings          success         ${response.json()['message']}
    Run Keyword And Continue On Failure         Should Not Be Empty                 ${response.json()['result']}