*** Settings ***
Documentation    This is test case to Mission Polling Question First Action
Resource        ${EXECDIR}/keyword/mission/get_polling_question_today.robot
Library         DataDriver   ${EXECDIR}/data/mission/csv/get_polling_question_today.csv

Default Tags    dev
Force Tags      get_mission_polling_question_first_action
Test Teardown   API.End API Connection
Test Template   Get Mission Polling Question First Action

*** Variables ***
${params}                           ${None}
${uri}                              ${uri_v3_polling_question_today}

*** Test Cases ***
${test_number}-${test_type}-Get Mission Polling Question First Action-${test_desc}        ${expected_http_status_code}

*** Keywords ***
Get Mission Polling Question First Action
    [Arguments]         ${expected_http_status_code}

    ${auth}=            Get Token Auth Using Password       valid       valid    
    &{data_dict}=       Create Dictionary       expected_http_status_code=${expected_http_status_code}
    &{headers}=         Create Dictionary       Accept=application/json     Content-Type=application/json       token=${auth}
    Set Global Variable     ${headers}
    Start staging_gcp API Connection
    ${response}=        Send GET Request API        ${uri}          ${params}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
    # Run Keyword And Continue On Failure     Run Keyword If  '${response.status_code}'=='200'        User Compare Result For Get Status Auth                 ${response}
