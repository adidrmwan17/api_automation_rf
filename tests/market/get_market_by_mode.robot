*** Settings ***
Documentation    This is test case to Get Market By Mode
Resource        ${EXECDIR}/keyword/market/get_market_by_mode.robot
Resource        ${EXECDIR}/variable/market/uri.robot
Library         DataDriver   ${EXECDIR}/data/market/csv/get_market_by_mode.csv

Default Tags    dev
Force Tags      get_market
Test Teardown   API.End API Connection
Test Template   Get Market By Mode

*** Variables ***
${params}                           ${None}
${uri}                              ${uri_v3_market}

*** Test Cases ***
${test_number}-${test_type}-Get Market By Mode-${test_desc}         ${mode}        ${expected_http_status_code}

*** Keywords ***
Get Market By Mode
    [Arguments]         ${mode}     ${expected_http_status_code}
   
    &{data_dict}=       Create Dictionary       mode=${mode}           expected_http_status_code=${expected_http_status_code}
    ${valid_data}=      User Generate Valid Data For Get Market By Mode
    &{headers}=         Create Dictionary       Accept=application/json     Content-Type=application/json
    ${params}=          User Define Query Parameters For Get Market By Mode    ${data_dict}     ${valid_data}
    Set Global Variable     ${headers}
    Start staging_gcp API Connection
    ${response}=        Send GET Request API        ${uri}          ${params}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
    Run Keyword And Continue On Failure     Run Keyword If  '${response.status_code}'=='200'        User Compare Result For Get Market By Mode                ${response}
