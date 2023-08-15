*** Settings ***
Documentation    This is test case to Get Staking Products
Resource        ${EXECDIR}/keyword/staking/get_staking_products.robot
Resource        ${EXECDIR}/variable/staking/uri.robot
Library         DataDriver   ${EXECDIR}/data/staking/csv/get_staking_products.csv

Default Tags    dev
Force Tags      get_staking_products
Test Teardown   API.End API Connection
Test Template   Get Staking Products

*** Variables ***
${params}                           ${None}
${uri}                              ${uri_v2_staking_products}

*** Test Cases ***
${test_number}-${test_type}-Get Staking Products-${test_desc}        ${expected_http_status_code}

*** Keywords ***
Get Staking Products
    [Arguments]         ${expected_http_status_code}
 
    &{data_dict}=       Create Dictionary       expected_http_status_code=${expected_http_status_code}
    &{headers}=         Create Dictionary       Accept=application/json     Content-Type=application/json
    Set Global Variable     ${headers}
    Start staging_gcp API Connection
    ${response}=        Send GET Request API        ${uri}          ${params}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
    Run Keyword And Continue On Failure     Run Keyword If  '${response.status_code}'=='200'        User Compare Result For Get Staking Products                 ${response}
