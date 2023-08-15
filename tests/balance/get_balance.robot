*** Settings ***
Documentation    This is test case to Get History Trans3
Resource        ${EXECDIR}/keyword/balance/get_balance.robot
Resource        ${EXECDIR}/variable/balance/uri.robot
Library         DataDriver   ${EXECDIR}/data/balance/csv/get_balance.csv

Default Tags    dev
Force Tags      get_balance
Test Teardown   API.End API Connection
Test Template   Get Balance

*** Variables ***
${params}                           ${None}
${uri}                              ${uri_v3_balance}

*** Test Cases ***
${test_number}-${test_type}-Get Balance-${test_desc}        ${expected_http_status_code}

*** Keywords ***
Get Balance
    [Arguments]         ${expected_http_status_code}

    ${auth}=            Get Token Auth Using Password       valid       valid    
    &{data_dict}=       Create Dictionary       expected_http_status_code=${expected_http_status_code}
    &{headers}=         Create Dictionary       token=${auth}
    Set Global Variable     ${headers}
    Start staging_gcp API Connection
    ${response}=        Send GET Request API        ${uri}          ${params}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
    Run Keyword And Continue On Failure     Run Keyword If  '${response.status_code}'=='200'        User Compare Result For Get Balance                 ${response}
