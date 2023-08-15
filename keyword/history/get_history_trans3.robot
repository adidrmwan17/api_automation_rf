*** Settings ***
Documentation   Keywords for Get History Trans3
Resource        ${EXECDIR}/common/keyword/common_keyword.robot
Variables       ${EXECDIR}/data/user/yaml/user.yaml

*** Keywords ***
User Compare Result For Get History Trans3
    [Arguments]         ${response}
    Run Keyword And Continue On Failure         Should Not Be Empty         ${response.json()}