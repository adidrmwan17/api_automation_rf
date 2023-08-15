*** Settings ***
Documentation    This is test case to Login User
Resource        ${EXECDIR}/keyword/user/get_status_auth.robot
Library         DataDriver   ${EXECDIR}/data/user/csv/get_status_auth.csv

Default Tags    dev
Force Tags      get_status_auth
Test Teardown   API.End API Connection
Test Template   Get Status Auth

*** Variables ***
${params}                           ${None}
${uri}                              ${uri_v3_user_status_auth}

*** Test Cases ***
${test_number}-${test_type}-Get Status Auth-${test_desc}        ${expected_http_status_code}

*** Keywords ***
Get Status Auth
    [Arguments]         ${expected_http_status_code}

    ${auth}=            Get Token Auth Using Password       valid       valid    
    &{data_dict}=       Create Dictionary       expected_http_status_code=${expected_http_status_code}
    &{headers}=         Create Dictionary   Accept=application/json     Content-Type=application/json       token=${auth}
    Set Global Variable     ${headers}
    Start staging_gcp API Connection
    ${response}=        Send GET Request API   ${uri}      ${params}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
    Run Keyword And Continue On Failure     Run Keyword If  '${response.status_code}'=='200'        User Compare Result For Get Status Auth                 ${response}
