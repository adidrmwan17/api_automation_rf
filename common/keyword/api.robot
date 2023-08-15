*** Settings ***
Resource        ${EXECDIR}/common/library.robot
Variables       ${EXECDIR}/etc/conf/conf.yaml
Documentation   API General Function

*** Variables ***
#########################
# General Configuration #
#########################
${environment}                beta              #possible values: {dev|staging|sandbox|prod}
${alias}                      api_automation
&{headers}                    Accept=application/json     x-app-debug=true
${timeout}                    15

*** Keywords ***
# ~~~ START - Creating and Ending Session ~~~
End API Connection
    Delete All Sessions
# ~~~ END - Creating and Ending Session ~~~
# ~~~ START - REQUEST
Send GET Request API
    [arguments]             ${URI}      ${params}
    ${response}=            Get Request     ${alias}        ${URI}      params=${params}    headers=${headers}      timeout=${timeout}
    Log                     ${response.content}
    Log                     ${response.headers}
    [return]                ${response}

Send POST Request API
    [arguments]             ${URI}      ${params}       ${payload}
    ${response}=            Post Request    ${alias}        ${URI}      params=${params}      data=${payload}     headers=${headers}      allow_redirects=True        timeout=${timeout}
    Log                     ${response.content}
    Log                     ${response.headers}
    [Return]                ${response}

Send POST Request API File Upload
    [arguments]             ${URI}      ${params}       ${payload}      ${files}
    ${response}=            Post Request    ${alias}        ${URI}      params=${params}      data=${payload}     headers=${headers}      allow_redirects=True        timeout=${None}    files=${files}
    Log                     ${response.content}
    Log                     ${response.headers}
    [Return]                ${response}

Send PUT Request API
    [arguments]             ${URI}      ${params}       ${payload}
    ${response}=            Put Request    ${alias}     ${URI}      params=${params}      data=${payload}     headers=${headers}      allow_redirects=True        timeout=${timeout}
    Log                     ${response.content}
    Log                     ${response.headers}
    [Return]                ${response}

Send PATCH Request API
    [arguments]             ${URI}      ${params}       ${payload}
    ${response}=            Patch Request   ${alias}        ${URI}      params=${params}      data=${payload}     headers=${headers}      allow_redirects=True        timeout=${timeout}
    Log                     ${response.content}
    Log                     ${response.headers}
    [Return]                ${response}

Send DELETE Request API
    [arguments]             ${URI}      ${params}       ${payload}
    ${response}=            Delete Request    ${alias}      ${URI}      params=${params}      data=${payload}     headers=${headers}      allow_redirects=True        timeout=${timeout}
    Log                     ${response.content}
    Log                     ${response.headers}
    [Return]                ${response}
# ~~~ END - REQUEST
# ~~~ START - Check Status Code ~~~
Check HTTP Response Code is
    [arguments]                       ${response}       ${expectCode}
    ${status}=      Run Keyword And Return Status       Should Be Equal As Strings          ${response.status_code}     ${expectCode}
    Log             ${status}
    [Return]        ${status}

Check HTTP Response Code is NOT
    [arguments]     ${response}                         ${expectCode}
    ${status}=      Run Keyword And Return Status       Should Not Be Equal As Strings      ${response.status_code}     ${expectCode}
    Log             ${status}
    [Return]        ${status}

Send Request And Check HTTP Response Code Equals
    [Arguments]     ${expected}     ${keyword_name}     @{args}
    ${response}=        Run Keyword     ${keyword_name}     @{args}
    Should Be Equal As Strings      ${response.status_code}     ${expected}
    [Return]    ${response}
# ~~~ END - Check Status Code ~~~
# ~~~ START - GQL QUERY ~~~~
Send GQL Request
    [Arguments]     ${auth}     ${query}    ${variables}    ${headers}
    ${URI}=         Set Variable    ${base_url_service.gql}
    ${response}=    Execute Gql Query    ${URI}   ${headers}   ${query}   ${variables}
    Log     ${response.content}
    Log     ${response.headers}
    [Return]    ${response}
# ~~~ END - GQL QUERY ~~~~
# ~~~ START - Retrier ~~~~
Retry Until Response Code Equals
    [Arguments]         ${timeout}    ${retry_interval}      ${expected}        ${keyword_name}     @{args}
    ${response}=    Run Keyword And Continue On Failure     Wait Until Keyword Succeeds     ${timeout}      ${retry_interval}       Send Request And Check HTTP Response Code Equals    ${expected}     ${keyword_name}     @{args}
    [Return]    ${response}
# ~~~ END - Retrier ~~~~
