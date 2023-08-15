*** Settings ***
Documentation    This is test case to Get Acc Trade BTC
Resource        ${EXECDIR}/keyword/trade/get_acctrade_btc.robot
Resource        ${EXECDIR}/variable/trade/uri.robot
Library         DataDriver   ${EXECDIR}/data/trade/csv/get_acctrade_btc.csv

Default Tags    dev
Force Tags      get_referral
Test Teardown   API.End API Connection
Test Template   Get Acc Trade BTC

*** Variables ***
${params}                           ${None}
${uri}                              ${uri_v2_acctrade}

*** Test Cases ***
${test_number}-${test_type}-Get Acc Trade BTC-${test_desc}        ${expected_http_status_code}

*** Keywords ***
Get Acc Trade BTC
    [Arguments]         ${expected_http_status_code}

    ${auth}=            Get Token Auth Using Password       valid       valid    
    &{data_dict}=       Create Dictionary       expected_http_status_code=${expected_http_status_code}
    &{headers}=         Create Dictionary       Accept=application/json     Content-Type=application/json       token=${auth}
    Set Global Variable     ${headers}
    Start staging_gcp API Connection
    ${response}=        Send GET Request API        ${uri}          ${params}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
    Run Keyword And Continue On Failure     Run Keyword If  '${response.status_code}'=='200'        User Compare Result For Get Acc Trade BTC                 ${response}
