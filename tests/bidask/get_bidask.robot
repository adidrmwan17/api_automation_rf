*** Settings ***
Documentation    This is test case to Get Bid Ask
Resource        ${EXECDIR}/keyword/bidask/get_bidask.robot
Resource        ${EXECDIR}/variable/bidask/uri.robot
Library         DataDriver   ${EXECDIR}/data/bidask/csv/get_bidask.csv

Default Tags    dev
Force Tags      get_bid_ask
Test Teardown   API.End API Connection
Test Template   Get Bid Ask

*** Variables ***
${params}                           ${None}
${uri}                              ${uri_v2_bidask}

*** Test Cases ***
${test_number}-${test_type}-Get Bid Ask-${test_desc}        ${expected_http_status_code}

*** Keywords ***
Get Bid Ask
    [Arguments]         ${expected_http_status_code}

    ${auth}=            Get Token Auth Using Password       valid       valid    
    &{data_dict}=       Create Dictionary       expected_http_status_code=${expected_http_status_code}
    &{headers}=         Create Dictionary       Accept=application/json     Content-Type=application/json       token=${auth}
    Set Global Variable     ${headers}
    Start staging_gcp API Connection
    ${response}=        Send GET Request API        ${uri}          ${params}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
    Run Keyword And Continue On Failure     Run Keyword If  '${response.status_code}'=='200'        User Compare Result For Get Bid Ask                 ${response}
