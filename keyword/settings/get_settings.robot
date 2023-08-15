*** Settings ***
Documentation   Keywords for Get Settings
Resource        ${EXECDIR}/common/keyword/common_keyword.robot
Variables       ${EXECDIR}/data/user/yaml/user.yaml

*** Keywords ***
User Compare Result For Get Settings
    [Arguments]         ${response}
    Run Keyword And Continue On Failure         Should Be True              ${response.json()['min_withdraw']}>0
    Run Keyword And Continue On Failure         Should Be True              ${response.json()['min_withdraw_fee']}>0
    Run Keyword And Continue On Failure         Should Be True              ${response.json()['min_deposit']}>0
    Run Keyword And Continue On Failure         Should Be True              ${response.json()['minprice']}>0
    Run Keyword And Continue On Failure         Should Be True              ${response.json()['smsfee']}>0