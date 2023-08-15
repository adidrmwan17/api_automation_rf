*** Settings ***
Documentation   Keywords for Get User Mode
Resource        ${EXECDIR}/common/keyword/common_keyword.robot
Variables       ${EXECDIR}/data/user/yaml/user.yaml

*** Keywords ***
User Compare Result For Get User Mode
    [Arguments]         ${response}
    Run Keyword And Continue On Failure         Should Be Equal As Strings          Berhasil mendapatkan mode pengguna         ${response.json()['message']}
    Run Keyword And Continue On Failure         Should Not Be Empty                 ${response.json()['mode']}