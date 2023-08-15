*** Settings ***
Documentation    This is test case to Get Market All Status
Resource        ${EXECDIR}/keyword/market/get_market_all_status.robot
Resource        ${EXECDIR}/variable/market/uri.robot
Library         DataDriver   ${EXECDIR}/data/market/csv/get_market_all_status.csv

Default Tags    dev
Force Tags      get_market
Test Teardown   API.End API Connection
Test Template   Get Market All Status

*** Variables ***
${params}                           ${None}
${uri}                              ${uri_v3_market}

*** Test Cases ***
${test_number}-${test_type}-Get Market All Status-${test_desc}         ${disable}      ${enable}       ${delisted}        ${expected_http_status_code}

*** Keywords ***
Get Market All Status
    [Arguments]         ${disable}      ${enable}       ${delisted}     ${expected_http_status_code}
   
    &{data_dict}=       Create Dictionary       disable=${disable}      enable=${enable}       delisted=${delisted}     expected_http_status_code=${expected_http_status_code}
    ${valid_data}=      User Generate Valid Data For Get Market All Status
    &{headers}=         Create Dictionary       Accept=application/json     Content-Type=application/json
    ${params}=          User Define Query Parameters For Get Market All Status    ${data_dict}     ${valid_data}
    Set Global Variable     ${headers}
    Start staging_gcp API Connection
    ${response}=        Send GET Request API        ${uri}          ${params}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
    Run Keyword And Continue On Failure     Run Keyword If  '${response.status_code}'=='200'        User Compare Result For Get Market All Status                ${response}
