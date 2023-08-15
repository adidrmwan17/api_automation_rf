*** Settings ***
Documentation    This is test case to Get Coins
Resource        ${EXECDIR}/keyword/coins/get_coins.robot
Resource        ${EXECDIR}/variable/coins/uri.robot
Library         DataDriver   ${EXECDIR}/data/coins/csv/get_coins.csv

Default Tags    dev
Force Tags      get_coins
Test Teardown   API.End API Connection
Test Template   Get Coins

*** Variables ***
${params}                           ${None}
${uri}                              ${uri_v2_coins}

*** Test Cases ***
${test_number}-${test_type}-Get Coins-${test_desc}        ${expected_http_status_code}

*** Keywords ***
Get Coins
    [Arguments]         ${expected_http_status_code}
   
    &{data_dict}=       Create Dictionary       expected_http_status_code=${expected_http_status_code}
    &{headers}=         Create Dictionary       Accept=application/json     Content-Type=application/json
    Set Global Variable     ${headers}
    Start staging_gcp API Connection
    ${response}=        Send GET Request API        ${uri}          ${params}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
    Run Keyword And Continue On Failure     Run Keyword If  '${response.status_code}'=='200'        User Compare Result For Get Coins                ${response}
