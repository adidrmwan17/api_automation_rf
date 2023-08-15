*** Settings ***
Documentation   Keywords for Get Market All Status
Resource        ${EXECDIR}/common/keyword/common_keyword.robot
Variables       ${EXECDIR}/data/user/yaml/user.yaml

*** Keywords ***
User Generate Valid Data For Get Market All Status
    ${disable}=         Set Variable        ${1}
    ${enable}=          Set Variable        ${1}        
    ${delisted}=        Set Variable        ${1}
    ${result}=          Create Dictionary       disable=${disable}          enable=${enable}       delisted=${delisted}

    [Return]            ${result}

User Define Query Parameters For Get Market All Status
    [Arguments]     ${data_dict}     ${valid_data}
    ${disable}=     Run Keyword If  '${data_dict.disable}'=='valid'    Set Variable    ${valid_data.disable}
    ...             ELSE    Set Variable     ${data_dict.disable}
    ${enable}=      Run Keyword If  '${data_dict.enable}'=='valid'    Set Variable    ${valid_data.enable}
    ...             ELSE    Set Variable     ${data_dict.enable}
    ${delisted}=    Run Keyword If  '${data_dict.delisted}'=='valid'    Set Variable    ${valid_data.delisted}
    ...             ELSE    Set Variable     ${data_dict.delisted}
    
    Set To Dictionary   ${data_dict}    disable                 ${disable}
    Set To Dictionary   ${data_dict}    enable                  ${enable}
    Set To Dictionary   ${data_dict}    delisted                ${delisted}

    &{param}=   Create Dictionary
    Run Keyword If      '${disable}'!='none'                Set To Dictionary   ${param}    disable                 ${disable}
    Run Keyword If      '${enable}'!='none'                 Set To Dictionary   ${param}    enable                  ${enable}
    Run Keyword If      '${delisted}'!='none'               Set To Dictionary   ${param}    delisted                ${delisted}
    [Return]    ${param}

User Compare Result For Get Market All Status
    [Arguments]         ${response}
    Run Keyword And Continue On Failure         Should Not Be Empty         ${response.json()}