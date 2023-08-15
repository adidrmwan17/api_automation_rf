*** Settings ***
Documentation    This is test case to Get OTC Products Settings
Resource        ${EXECDIR}/keyword/otc/get_otc_products_settings.robot
Resource        ${EXECDIR}/variable/otc/uri.robot
Library         DataDriver   ${EXECDIR}/data/otc/csv/get_otc_product_settings.csv

Default Tags    dev
Force Tags      get_otc_products_settings
Test Teardown   API.End API Connection
Test Template   Get OTC Products Settings

*** Variables ***
${params}                           ${None}
${uri}                              ${uri_v2_otc_products_setting}

*** Test Cases ***
${test_number}-${test_type}-Get OTC Products Settings-${test_desc}        ${expected_http_status_code}

*** Keywords ***
Get OTC Products Settings
    [Arguments]         ${expected_http_status_code}
   
    &{data_dict}=       Create Dictionary       expected_http_status_code=${expected_http_status_code}
    &{headers}=         Create Dictionary       Accept=application/json     Content-Type=application/json
    Set Global Variable     ${headers}
    Start staging_gcp API Connection
    ${response}=        Send GET Request API        ${uri}          ${params}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
    Run Keyword And Continue On Failure     Run Keyword If  '${response.status_code}'=='200'        User Compare Result For Get OTC Products Settings                ${response}
