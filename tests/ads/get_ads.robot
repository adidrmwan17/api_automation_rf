*** Settings ***
Documentation    This is test case to Get Ads
Resource        ${EXECDIR}/keyword/ads/get_ads.robot
Resource        ${EXECDIR}/variable/ads/uri.robot
Library         DataDriver   ${EXECDIR}/data/ads/csv/get_ads.csv

Default Tags    dev
Force Tags      get_ads
Test Teardown   API.End API Connection
Test Template   Get Ads

*** Variables ***
${params}                           ${None}
${uri}                              ${uri_v2_ads}

*** Test Cases ***
${test_number}-${test_type}-Get Ads-${test_desc}        ${expected_http_status_code}

*** Keywords ***
Get Ads
    [Arguments]         ${expected_http_status_code}

    &{data_dict}=       Create Dictionary       expected_http_status_code=${expected_http_status_code}
    &{headers}=         Create Dictionary       Accept=application/json     Content-Type=application/json
    Set Global Variable     ${headers}
    Start staging_gcp API Connection
    ${response}=        Send GET Request API        ${uri}          ${params}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
    # Run Keyword And Continue On Failure     Run Keyword If  '${response.status_code}'=='200'        User Compare Result For Get Ads                 ${response}
