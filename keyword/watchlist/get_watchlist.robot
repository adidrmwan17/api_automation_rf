*** Settings ***
Documentation   Keywords for Get Watchlist
Resource        ${EXECDIR}/common/keyword/common_keyword.robot
Variables       ${EXECDIR}/data/user/yaml/user.yaml

*** Keywords ***
User Compare Result For Get Watchlist
    [Arguments]         ${response}
    Run Keyword And Continue On Failure         Should Not Be Empty              ${response.json()}