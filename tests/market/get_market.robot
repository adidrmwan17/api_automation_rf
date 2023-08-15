*** Settings ***
Documentation    This is test case to Get Market
Resource        ${EXECDIR}/keyword/market/get_market.robot
Resource        ${EXECDIR}/variable/market/uri.robot
Library         DataDriver   ${EXECDIR}/data/market/csv/get_market.csv

Default Tags    dev
Force Tags      get_market
Test Teardown   API.End API Connection
Test Template   Get Market

*** Variables ***
${params}                           ${None}
${uri}                              ${uri_v3_market}

*** Test Cases ***
${test_number}-${test_type}-Get Market-${test_desc}        ${expected_http_status_code}

*** Keywords ***
Get Market
    [Arguments]         ${expected_http_status_code}
   
    &{data_dict}=       Create Dictionary       expected_http_status_code=${expected_http_status_code}
    &{headers}=         Create Dictionary       Accept=application/json     Content-Type=application/json
    Set Global Variable     ${headers}
    Start staging_gcp API Connection
    ${response}=        Send GET Request API        ${uri}          ${params}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
    Run Keyword And Continue On Failure     Run Keyword If  '${response.status_code}'=='200'        User Compare Result For Get Market                ${response}
