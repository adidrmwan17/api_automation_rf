*** Settings ***
Documentation   Keywords for Get Order Book By ID
Resource        ${EXECDIR}/common/keyword/common_keyword.robot
Variables       ${EXECDIR}/data/user/yaml/user.yaml

*** Keywords ***
User Generate Valid Data For Get Order Book By ID
    ${id}=              Set Variable        ${20}

    ${result}=          Create Dictionary       id=${id}

    [Return]            ${result}

User Define Query Parameters For Get Order Book By ID
    [Arguments]     ${data_dict}     ${valid_data}
    ${id}=    Run Keyword If  '${data_dict.id}'=='valid'    Set Variable    ${valid_data.id}
    ...             ELSE    Set Variable     ${data_dict.id}
    
    Set To Dictionary   ${data_dict}    id              ${id}

    &{param}=   Create Dictionary
    Run Keyword If      '${id}'!='none'             Set To Dictionary   ${param}    id              ${id}
    [Return]    ${param}

User Compare Result For Get Order Book By ID
    [Arguments]         ${response}
    Run Keyword And Continue On Failure         Should Not Be Empty         ${response.json()['s']}