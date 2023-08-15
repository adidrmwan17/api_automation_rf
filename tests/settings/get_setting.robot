*** Settings ***
Documentation    This is test case to Get Settings
Resource        ${EXECDIR}/keyword/settings/get_settings.robot
Resource        ${EXECDIR}/variable/settings/uri.robot
Library         DataDriver   ${EXECDIR}/data/settings/csv/get_settings.csv

Default Tags    dev
Force Tags      get_settings
Test Teardown   API.End API Connection
Test Template   Get Settings

*** Variables ***
${params}                           ${None}
${uri}                              ${uri_v2_settings}

*** Test Cases ***
${test_number}-${test_type}-Get Settings-${test_desc}        ${expected_http_status_code}

*** Keywords ***
Get Settings
    [Arguments]         ${expected_http_status_code}

    ${auth}=            Get Token Auth Using Password       valid       valid    
    &{data_dict}=       Create Dictionary       expected_http_status_code=${expected_http_status_code}
    &{headers}=         Create Dictionary       Accept=application/json     Content-Type=application/json       token=${auth}
    Set Global Variable     ${headers}
    Start staging_gcp API Connection
    ${response}=        Send GET Request API        ${uri}          ${params}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
    Run Keyword And Continue On Failure     Run Keyword If  '${response.status_code}'=='200'        User Compare Result For Get Settings                 ${response}
