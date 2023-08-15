*** Settings ***
Documentation    This is test case to Get Profile
Resource        ${EXECDIR}/keyword/user/get_user_mode.robot
Resource        ${EXECDIR}/variable/user/uri.robot
Library         DataDriver   ${EXECDIR}/data/user/csv/get_user_mode.csv

Default Tags    dev
Force Tags      get_user_mode
Test Teardown   API.End API Connection
Test Template   Get User Mode

*** Variables ***
${params}                           ${None}
${uri}                              ${uri_v3_user_mode}

*** Test Cases ***
${test_number}-${test_type}-Get User Mode-${test_desc}        ${expected_http_status_code}

*** Keywords ***
Get User Mode
    [Arguments]         ${expected_http_status_code}

    ${auth}=            Get Token Auth Using Password       valid       valid    
    &{data_dict}=       Create Dictionary       expected_http_status_code=${expected_http_status_code}
    &{headers}=         Create Dictionary       Accept=application/json     Content-Type=application/json       token=${auth}
    Set Global Variable     ${headers}
    Start staging_gcp API Connection
    ${response}=        Send GET Request API        ${uri}          ${params}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
    Run Keyword And Continue On Failure     Run Keyword If  '${response.status_code}'=='200'        User Compare Result For Get User Mode                 ${response}
