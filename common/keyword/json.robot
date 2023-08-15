*** Settings ***
Resource        ${EXECDIR}/common/library.robot
Documentation   JSON General Function

*** Keywords ***
# ~~~ START - JSON Related Keyword ~~~
Read JSON File From The Specified Path
    [arguments]         ${jsonFilePath}
    ${jsonFile}=        Load Json From File     ${jsonFilePath}
    Log                 ${jsonFile}
    [Return]            ${jsonFile}

Read JSON File From Filepath
    [Documentation]     This keyword uses custom python file
    [arguments]                         ${jsonFilePath}
    ${jsonFile}=                        Read JSON File      ${jsonFilePath}
    Log                                 ${jsonFile}
    [Return]                            ${jsonFile}

Read JSON File From URL
    [Documentation]     This keyword uses custom python file
    [arguments]                         ${jsonFileUrl}
    ${jsonFile}=                        Read JSON URL       ${jsonFileUrl}
    Log                                 ${jsonFile}
    [Return]                            ${jsonFile}

Convert The Read jsonFile into String
    [arguments]             ${jsonFile}
    Log                     ${jsonFile}
    ${payload}=             Convert JSON To String  ${jsonFile}
    Log                     ${payload}
    [return]                ${payload}

Convert jsonString Back to JSON
    [arguments]             ${payload}
    Log                     ${payload}
    ${payload}=             To Json  ${payload}    pretty_print=True
    Log                     ${payload}
    [return]                ${payload}

Convert Response Body into JSON
    [arguments]             ${response}
    ${responseBodyToJSON}=  To Json  ${response.content}    pretty_print=True
    Log                     ${responseBodyToJSON}
    [return]                ${responseBodyToJSON}

Convert Response Body into String
    [arguments]                 ${response}
    ${responseBodyToString}=    Convert To String           ${response.content}
    Log                         ${responseBodyToString}
    [return]                    ${responseBodyToString}

Read Value from Specific Key in The Read jsonFile
    [Arguments]     ${jsonFile}       ${variableKey}
    ${value}=       Get Value From Json       ${jsonFile}       ${variableKey}
    Log             ${value}
    [Return]        ${value}

Update The Selected JSON Key with New Value
    [Arguments]         ${payload}       ${variableKey}      ${newValue}
    ${payload}=         Update Value To Json      ${payload}     ${variableKey}       ${newValue}
    ${payload_view}=    Beautify Payload    ${payload}
    Log                 ${payload_view}
    Log                 ${payload}
    [Return]            ${payload}

Delete The Value of The Selected JSON Key
    [Arguments]         ${payload}       ${variableKey}
    ${payload}=         Delete Object From Json      ${payload}     ${variableKey}
    ${payload_view}=    Beautify Payload    ${payload}
    Log                 ${payload_view}
    Log                 ${payload}
    [Return]            ${payload}

Update or Delete Selected JSON Key
    [Arguments]         ${payload}          ${variableKey}      ${newValue}
    ${data_type_newValue}=                  Check Data Type     ${newValue}
    ${newValue_set}=    Run Keyword If      '${data_type_newValue}'=='STRING'   Convert To Lowercase    ${newValue}
    ...                 ELSE                Set Variable                        ${newValue}
    ${payload}=         Run Keyword If      '${newValue_set}'=='none'   Delete The Value of The Selected JSON Key   ${payload}      ${variableKey}
    ...                 ELSE                Update The Selected JSON Key with New Value     ${payload}          ${variableKey}      ${newValue}
    ${payload_view}=    Beautify Payload    ${payload}
    Log                 ${payload_view}
    [Return]            ${payload}

ADD Key and Value To JSON
    [Arguments]         ${payload}       ${variableKey}        ${value}
    ${payload}=         Add Object To Json      ${payload}     ${variableKey}      ${value}
    ${payload_view}=    Beautify Payload    ${payload}
    Log                 ${payload_view}
    Log                 ${payload}
    [Return]            ${payload}

jsonFile Set Global AS payload
    ${payload}=             Set Variable        ${jsonFile}
    Log                     ${payload}
    Set Global Variable     ${payload}
    [Return]                ${payload}

Set payload to EMPTY
    ${payload}              Set Variable        ${EMPTY}
    Log                     ${payload}
    [Return]                ${payload}

Compare JSON File With JSON Schema
    [arguments]             ${json_schema}  ${json_payload}
    ${schema}               Get Binary File    ${json_schema}
    ${schema}               evaluate    json.loads('''${schema}''')    json
    ${instance}             evaluate    json.loads(r'''${json_payload}''')    json
    validate    instance=${instance}    schema=${schema}

Beautify Payload
    [Arguments]     ${payload}
    ${payload}=     Convert The Read jsonFile into String   ${payload}
    ${payload}=     Convert jsonString Back to JSON         ${payload}
    Log             ${payload}
    [Return]        ${payload}
# ~~~ END - JSON Related Keyword ~~~