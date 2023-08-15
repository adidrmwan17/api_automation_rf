*** Settings ***
Documentation   Keywords for Get Acc Trade BTC
Resource        ${EXECDIR}/common/keyword/common_keyword.robot
Variables       ${EXECDIR}/data/user/yaml/user.yaml

*** Keywords ***
User Compare Result For Get Acc Trade BTC
    [Arguments]         ${response}
    Run Keyword And Continue On Failure         Should Not Be Empty         ${response.json()}