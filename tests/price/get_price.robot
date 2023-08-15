*** Settings ***
Documentation    This is test case to Get Pricing
Resource        ${EXECDIR}/keyword/price/get_price.robot
Resource        ${EXECDIR}/variable/price/uri.robot
Library         DataDriver   ${EXECDIR}/data/price/csv/get_price.csv

Default Tags    dev
Force Tags      get_price
Test Teardown   API.End API Connection
Test Template   Get Price

*** Variables ***
${params}                           ${None}
${uri}                              ${uri_v2_price}

*** Test Cases ***
${test_number}-${test_type}-Get Price-${test_desc}        ${expected_http_status_code}

*** Keywords ***
Get Price
    [Arguments]         ${expected_http_status_code}
 
    &{data_dict}=       Create Dictionary       expected_http_status_code=${expected_http_status_code}
    &{headers}=         Create Dictionary       Accept=application/json     Content-Type=application/json
    Set Global Variable     ${headers}
    Start staging_gcp API Connection
    ${response}=        Send GET Request API        ${uri}          ${params}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
    Run Keyword And Continue On Failure     Run Keyword If  '${response.status_code}'=='200'        User Compare Result For Get Price                 ${response}
