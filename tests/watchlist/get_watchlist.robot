*** Settings ***
Documentation    This is test case to Get Watchlist
Resource        ${EXECDIR}/keyword/watchlist/get_watchlist.robot
Resource        ${EXECDIR}/variable/watchlist/uri.robot
Library         DataDriver   ${EXECDIR}/data/watchlist/csv/get_watchlist.csv

Default Tags    dev
Force Tags      get_settings
Test Teardown   API.End API Connection
Test Template   Get Watchlist

*** Variables ***
${params}                           ${None}
${uri}                              ${uri_v2_watchlist}

*** Test Cases ***
${test_number}-${test_type}-Get Watchlist-${test_desc}        ${expected_http_status_code}

*** Keywords ***
Get Watchlist
    [Arguments]         ${expected_http_status_code}

    ${auth}=            Get Token Auth Using Password       valid       valid    
    &{data_dict}=       Create Dictionary       expected_http_status_code=${expected_http_status_code}
    &{headers}=         Create Dictionary       Accept=application/json     Content-Type=application/json       token=${auth}
    Set Global Variable     ${headers}
    Start staging_gcp API Connection
    ${response}=        Send GET Request API        ${uri}          ${params}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
    Run Keyword And Continue On Failure     Run Keyword If  '${response.status_code}'=='200'        User Compare Result For Get Watchlist                 ${response}
