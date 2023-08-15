*** Settings ***
Documentation    This is test case to Login User
Resource        ${EXECDIR}/keyword/user/post_login_user.robot
Library         DataDriver   ${EXECDIR}/data/user/csv/post_login_user.csv

Default Tags    dev
Force Tags      post_login_user
Test Teardown   API.End API Connection
Test Template   Post Login User

*** Variables ***
${params}                           ${None}
${json_payload}                     ${EXECDIR}/template/user/login.json
${uri}                              ${uri_v3_user_login}

*** Test Cases ***
${test_number}-${test_type}-Post Login User-${test_desc}    ${email}     ${password}        ${expected_http_status_code}

*** Keywords ***
Post Login User
    [Arguments]         ${email}     ${password}        ${expected_http_status_code}

    &{data_dict}=       Create Dictionary       email=${email}     password=${password}       expected_http_status_code=${expected_http_status_code}
    ${valid_data}=      User Generate Valid Data For Post Login User
    ${json_file}=       Read JSON File From The Specified Path              ${json_payload}
    ${payload}=         User Define Payload For Post Login User             ${json_file}         ${data_dict}      ${valid_data}
    &{headers}=         Create Dictionary   Accept=application/json     Content-Type=application/json
    Set Global Variable     ${headers}
    Start staging_gcp API Connection
    ${response}=        Send POST Request API   ${uri}      ${params}       ${payload}
    Run Keyword And Continue On Failure     Should Be Equal As Strings  ${response.status_code}     ${data_dict.expected_http_status_code}
    # Run Keyword And Continue On Failure     Run Keyword If  '${response.status_code}'=='200'        User Compare Result For Post Login User                 ${response}       ${data_dict}
