*** Settings ***
Resource        ${EXECDIR}/common/library.robot
Resource        ${EXECDIR}/common/keyword/api.robot
Resource        ${EXECDIR}/common/keyword/csv.robot
Resource        ${EXECDIR}/common/keyword/json.robot
Resource        ${EXECDIR}/common/keyword/string.robot
Resource        ${EXECDIR}/common/keyword/excel.robot
Variables       ${EXECDIR}/etc/conf/conf.yaml
Resource        ${EXECDIR}/variable/user/uri.robot
Resource        ${EXECDIR}/keyword/user/post_login_user.robot

*** Keywords ***
# DATABASE CONNECTION - Please make it sorted by name asc
Start accountsvc DB Connection
    Connect To Database             pymysql     ${mysql_account_database_connection.db_name}    ${mysql_account_database_connection.db_user}    ${mysql_account_database_connection.db_pass}    ${mysql_account_database_connection.db_host}    ${mysql_account_database_connection.db_port}

# API CONNECTION - Please make it sorted by name asc
Start beta API Connection
    Create Session                  ${alias}        ${base_url_service.beta}       verify=True         headers=${headers}

Start staging_gcp API Connection
    Create Session                  ${alias}        ${base_url_service.staging_gcp}       verify=True         headers=${headers}

Get Token Auth Using Password
    [Arguments]         ${username}     ${password}
    ${json_payload}     Set variable            ${EXECDIR}/template/user/login.json
    ${uri}=             Set Variable            ${uri_v3_user_login}
    &{data_dict}=       Create Dictionary       email=${username}     password=${password}
    ${valid_data}=      User Generate Valid Data For Post Login User
    ${json_file}=       Read JSON File From The Specified Path              ${json_payload}
    ${payload}=         User Define Payload For Post Login User             ${json_file}         ${data_dict}      ${valid_data}
    &{headers}=         Create Dictionary       Accept=application/json     Content-Type=application/json
    Set Global Variable     ${headers}
    Start staging_gcp API Connection
    ${response}=        Send POST Request API   ${uri}      ${params}       ${payload}
    End API Connection
    Log   ${response}
    ${result}=          Set Variable    ${response.json()['result']['token']}
    Log   ${result}
    [Return]            ${result}

#tracksvc
Get Bearer Auth Using API Key
    [Documentation]     values for is_openid are true or false
    [Arguments]         ${client_name}      ${username}     ${apikey}      ${is_openid}

    ${username}=   Run Keyword If  '${client_name}'=='jne'     Set Variable    ${api_call_jne.username}
    ${apikey}=     Run Keyword If  '${client_name}'=='jne'     Set Variable    ${api_call_jne.api_key}

    &{result}=     Create Dictionary       username=${username}       apikey=${apikey}
    [Return]       ${result}

End DB Connection
    Disconnect From Database

Get Current Year and Month for Accessing Table
    ${date}=                        Get Current Date
    ${formattedDate}=               Convert Date            ${date}         datetime
    ${currentMonth}=                Convert To Integer      ${formattedDate.month}
    ${currentYearMonth}=            Run Keyword If          ${currentMonth} < 10              Set Variable      ${formattedDate.year}0${formattedDate.month}
    ...                                 ELSE                Set Variable      ${formattedDate.year}${formattedDate.month}
    [Return]                        ${currentYearMonth}

Get Table Partition for Accessing Table with Modulo 10
    [Arguments]                     ${clientId}
    ${resultMod}=                   Evaluate            ${clientId} % 10
    ${result}=                      Set Variable        p10_0${resultMod}
    [Return]                        ${result}

Get Year and Month Based On Reference Time
    [Arguments]                     ${reference_time}
    ${d}=       Split String	${reference_time}	-
    ${year}=    Set Variable    ${d}[0]
    ${month}=   Set Variable    ${d}[1]
    [Return]    ${year}${month}

Query And Validate Not Empty
    [Arguments]         ${query}
    ${query_result}=    Query   ${query}
    Should Not Be Empty         ${query_result}
    [Return]    ${query_result}

Retry Until Database Query Not Empty
    [Arguments]         ${timeout}    ${retry_interval}     ${query}
    ${query_result}=    Wait Until Keyword Succeeds     ${timeout}      ${retry_interval}       Query And Validate Not Empty  ${query}
    [Return]    ${query_result}
