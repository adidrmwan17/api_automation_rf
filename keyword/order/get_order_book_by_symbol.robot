*** Settings ***
Documentation   Keywords for Get Order Book By Symbol
Resource        ${EXECDIR}/common/keyword/common_keyword.robot
Variables       ${EXECDIR}/data/user/yaml/user.yaml

*** Keywords ***
User Generate Valid Data For Get Order Book By Symbol
    ${symbol}=          Set Variable        SHIB_IDR

    ${result}=          Create Dictionary       symbol=${symbol}

    [Return]            ${result}

User Define Query Parameters For Get Order Book By Symbol
    [Arguments]     ${data_dict}     ${valid_data}
    ${symbol}=      Run Keyword If  '${data_dict.symbol}'=='valid'    Set Variable    ${valid_data.symbol}
    ...             ELSE    Set Variable        ${data_dict.symbol}
    
    Set To Dictionary   ${data_dict}    symbol              ${symbol}

    &{param}=   Create Dictionary
    Run Keyword If      '${symbol}'!='none'             Set To Dictionary   ${param}    symbol              ${symbol}
    [Return]    ${param}

User Compare Result For Get Order Book By Symbol
    [Arguments]         ${response}
    Run Keyword And Continue On Failure         Should Not Be Empty         ${response.json()['s']}