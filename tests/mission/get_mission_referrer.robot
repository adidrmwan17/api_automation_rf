*** Settings ***
Documentation    This is test case to Mission Referrer
Resource        ${EXECDIR}/keyword/mission/get_referrer.robot
Resource        ${EXECDIR}/variable/mission/uri.robot
Library         DataDriver   ${EXECDIR}/data/mission/csv/get_rerferrer.csv

Default Tags    dev
Force Tags      get_mission_referrer
Test Teardown   API.End API Connection
Test Template   Get Mission Referrer

*** Variables ***
${params}                           ${None}
${uri}                              ${uri_v3_mission_referrer}

*** Test Cases ***
${test_number}-${test_type}-Get Mission Referrer-${test_desc}        ${expected_http_status_code}

*** Keywords ***
Get Mission Referrer
    [Arguments]         ${expected_http_status_code}

    ${auth}=            Get Token Auth Using Password       valid       valid    
    &{data_dict}=       Create Dictionary       expected_http_status_code=${expected_http_status_code}
    &{headers}=         Create Dictionary       Accept=application/json     Content-Type=application/json       token=${auth}
    Set Global Variable     ${headers}
    Start staging_gcp API Connection
    ${response}=        Send GET Request API        ${uri}          ${params}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
    Run Keyword And Continue On Failure     Run Keyword If  '${response.status_code}'=='200'        User Compare Result For Get Mission Referrer                ${response}
