*** Settings ***
Documentation    This is test case to Get History Trans3
Resource        ${EXECDIR}/keyword/history/get_history_trans3.robot
Resource        ${EXECDIR}/variable/history/uri.robot
Library         DataDriver   ${EXECDIR}/data/history/csv/get_history_trans3.csv

Default Tags    dev
Force Tags      get_history_trans3
Test Teardown   API.End API Connection
Test Template   Get History Trans3

*** Variables ***
${params}                           ${None}
${uri}                              ${uri_v2_history_trans3}

*** Test Cases ***
${test_number}-${test_type}-Get History Trans3-${test_desc}        ${expected_http_status_code}

*** Keywords ***
Get History Trans3
    [Arguments]         ${expected_http_status_code}

    ${auth}=            Get Token Auth Using Password       valid       valid    
    &{data_dict}=       Create Dictionary       expected_http_status_code=${expected_http_status_code}
    &{headers}=         Create Dictionary       token=${auth}
    Set Global Variable     ${headers}
    Start staging_gcp API Connection
    ${response}=        Send GET Request API        ${uri}          ${params}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
    # Run Keyword And Continue On Failure     Run Keyword If  '${response.status_code}'=='200'        User Compare Result For Get History Trans3                 ${response}
