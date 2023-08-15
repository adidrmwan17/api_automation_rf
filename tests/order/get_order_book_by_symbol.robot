*** Settings ***
Documentation    This is test case to Get Get Order Book By Symbol
Resource        ${EXECDIR}/keyword/order/get_order_book_by_symbol.robot
Resource        ${EXECDIR}/variable/order/uri.robot
Library         DataDriver   ${EXECDIR}/data/order/csv/get_order_book_by_symbol.csv

Default Tags    dev
Force Tags      get_order_book_by_symbol
Test Teardown   API.End API Connection
Test Template   Get Order Book By Symbol

*** Variables ***
${params}                           ${None}
${uri}                              ${uri_v3_order_book}

*** Test Cases ***
${test_number}-${test_type}-Get Order Book By Symbol-${test_desc}        ${symbol}      ${expected_http_status_code}

*** Keywords ***
Get Order Book By Symbol
    [Arguments]         ${symbol}       ${expected_http_status_code}
   
    &{data_dict}=       Create Dictionary       symbol=${symbol}        expected_http_status_code=${expected_http_status_code}
    ${valid_data}=      User Generate Valid Data For Get Order Book By Symbol
    &{headers}=         Create Dictionary       Accept=application/json     Content-Type=application/json
    Set Global Variable     ${headers}
    ${params}=          User Define Query Parameters For Get Order Book By Symbol    ${data_dict}     ${valid_data}
    Start staging_gcp API Connection
    ${response}=        Send GET Request API        ${uri}          ${params}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
    Run Keyword And Continue On Failure     Run Keyword If  '${response.status_code}'=='200'        User Compare Result For Get Order Book By Symbol                 ${response}
