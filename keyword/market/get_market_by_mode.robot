*** Settings ***
Documentation   Keywords for Get Market All Status
Resource        ${EXECDIR}/common/keyword/common_keyword.robot
Variables       ${EXECDIR}/data/user/yaml/user.yaml

*** Keywords ***
User Generate Valid Data For Get Market By Mode
    ${mode}=            Set Variable        ${1}
    ${result}=          Create Dictionary       mode=${mode}

    [Return]            ${result}

User Define Query Parameters For Get Market By Mode
    [Arguments]     ${data_dict}     ${valid_data}
    ${mode}=        Run Keyword If  '${data_dict.mode}'=='valid'    Set Variable    ${valid_data.mode}
    ...             ELSE    Set Variable     ${data_dict.mode}
    
    Set To Dictionary   ${data_dict}    mode                 ${mode}

    &{param}=   Create Dictionary
    Run Keyword If      '${mode}'!='none'                Set To Dictionary   ${param}    mode                 ${mode}
    [Return]    ${param}

User Compare Result For Get Market By Mode
    [Arguments]         ${response}
    Run Keyword And Continue On Failure         Should Not Be Empty         ${response.json()}