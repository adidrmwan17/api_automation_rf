*** Settings ***
Documentation    This is test case to Get Staking Balance
Resource        ${EXECDIR}/keyword/staking/get_staking_balances.robot
Resource        ${EXECDIR}/variable/staking/uri.robot
Library         DataDriver   ${EXECDIR}/data/staking/csv/get_staking_balances.csv

Default Tags    dev
Force Tags      get_referral
Test Teardown   API.End API Connection
Test Template   Get Staking Balance

*** Variables ***
${params}                           ${None}
${uri}                              ${uri_v2_staking_balances}

*** Test Cases ***
${test_number}-${test_type}-Get Staking Balance-${test_desc}        ${expected_http_status_code}

*** Keywords ***
Get Staking Balance
    [Arguments]         ${expected_http_status_code}

    ${auth}=            Get Token Auth Using Password       valid       valid    
    &{data_dict}=       Create Dictionary       expected_http_status_code=${expected_http_status_code}
    &{headers}=         Create Dictionary       Accept=application/json     Content-Type=application/json       token=${auth}
    Set Global Variable     ${headers}
    Start staging_gcp API Connection
    ${response}=        Send GET Request API        ${uri}          ${params}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
    # Run Keyword And Continue On Failure     Run Keyword If  '${response.status_code}'=='200'        User Compare Result For Get Staking Balance                 ${response}
