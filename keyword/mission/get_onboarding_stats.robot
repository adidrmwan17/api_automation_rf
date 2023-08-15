*** Settings ***
Documentation   Keywords for Get Mission Onboarding Stats
Resource        ${EXECDIR}/common/keyword/common_keyword.robot
Resource        ${EXECDIR}/variable/mission/uri.robot
Variables       ${EXECDIR}/data/user/yaml/user.yaml

*** Keywords ***
User Compare Result For Get Mission Onboarding Stats
    [Arguments]         ${response}
    Run Keyword And Continue On Failure         Should Be Equal As Strings          success          ${response.json()['message']}
    Run Keyword And Continue On Failure         Should Not Be Empty                 ${response.json()['data']}