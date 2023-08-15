*** Settings ***
Resource        ${EXECDIR}/common/library.robot
Documentation   String General Function

*** Keywords ***
Generate Random Number X length
    [Arguments]             ${length}
    ${randomNumber}=        Generate Random String      ${length}       [NUMBERS]
    ${randomNumber}=        Convert To Integer          ${randomNumber}
    Log                     ${randomNumber}
    [return]                ${randomNumber}

Generate Random Decimal Number X X length
    [Arguments]             ${length1}      ${length2}
    ${randomDec1}=          Generate Random String      ${length1}      [NUMBERS]
    ${randomDec2}=          Generate Random String      ${length2}      [NUMBERS]
    ${random}=              Set Variable                ${randomDec1}.${randomDec2}
    ${random}=              Convert To Number           ${random}
    Log                     ${random}
    [return]                ${random}

Generate Random String Alphanumeric X length
    [Arguments]             ${length}
    ${random}               Generate Random String        ${length}       [LETTERS][NUMBERS]
    Log                     ${random}
    [return]                ${random}

Generate Random String Alphabet X length
    [Arguments]             ${length}
    ${random}               Generate Random String        ${length}       [LETTERS]
    Log                     ${random}
    [return]                ${random}

Generate Random Unique Timestamp
    ${d}=           Get Current Date            result_format=%Y%m%d%H:%M:%S:%f
    ${d}=           Convert To String           ${d}
    ${d}=           Remove String               ${d}    -   :   .   ${SPACE}
    ${result}=      Convert To String           ${d}
    Log             ${result}
    [return]        ${result}

Generate Epoch Timestamp
    ${d}=       Get Current Date
    ${d}=       Convert Date    ${d}    epoch
    ${d}=       Convert To String           ${d}
    ${d}=       Remove String               ${d}    -   :   .   ${SPACE}
    ${result}=      Convert To String           ${d}
    Log             ${result}
    [return]        ${result}

Generate Random String for Unique Identifier
    [Arguments]     ${input}
    ${random}       Generate Random String      3       [LETTERS]
    ${input}=       Remove String               ${input}        ${SPACE}
    ${d}=           Get Current Date            result_format=%Y%m%d%H:%M:%S:%f
    ${d}=           Convert To String           ${d}
    ${d}=           Remove String               ${d}    -   :   .   ${SPACE}
    ${result}=      Convert To String           ${random}_${d}_${input}
    Log             ${result}
    [return]        ${result}

Generate Date X Day - X Hour - X Timezone for JSON
    [Arguments]     ${day}      ${hour}     ${timezone}
    ${d}=           Get Current Date        result_format=%Y-%m-%d %H:%M:%S
    ${d}=           Add Time To Date        ${d}    ${day} days         result_format=%Y-%m-%d %H:%M:%S
    ${d}=           Add Time To Date        ${d}    ${hour} hours       result_format=%Y-%m-%d %H:%M:%S
    ${d}=           Convert To String       ${d}
    ${d}=           Replace String          ${d}    ${SPACE}    T
    ${d}=           Set Variable            ${d}${timezone}
    [return]        ${d}

Generate Date X Day - X Hour - X Minute - X Timezone for JSON
    [Arguments]     ${day}      ${hour}     ${minute}  ${timezone}
    ${d}=           Get Current Date        result_format=%Y-%m-%d %H:%M:%S
    ${d}=           Add Time To Date        ${d}    ${day} days         result_format=%Y-%m-%d %H:%M:%S
    ${d}=           Add Time To Date        ${d}    ${hour} hours       result_format=%Y-%m-%d %H:%M:%S
    ${d}=           Add Time To Date        ${d}    ${minute} minutes   result_format=%Y-%m-%d %H:%M:%S
    ${d}=           Convert To String       ${d}
    ${d}=           Replace String          ${d}    ${SPACE}    T
    ${d}=           Set Variable            ${d}${timezone}
    [return]        ${d}

Generate Date X UTC Time - X Day - X Hour - X Minute - X Second - X Timezone for JSON
    [Arguments]     ${utc_time}     ${day}  ${hour}     ${minute}   ${second}   ${timezone}
    [Documentation]     Possible values:
    ...                 ${utc_time} can be 7 for UTC+7 or -7 for UTC-7 and so on. Set 0 for default
    ...                 ${day} can be picked to -1 for yesterday or 1 for next day and so on. Set 0 for default
    ...                 ${hour} can be picked to -1 for an hour ago or 1 for next hour and so on. Set 0 for default
    ...                 ${minute} can be picked to -1 for a minute ago or 1 for next minute and so on. Set 0 for default
    ...                 ${second} can be picked to -1 for a second ago or 1 for next second and so on. Set 0 for default
    ...                 ${timezone} pick your timezon can be +07:00 or Z. Set ${EMPTY} for EMPTY or +00:00 for default. WATCH your ${utc_time}
    ${d}=           Get Current Date        UTC     ${utc_time} hours
    ${d}=           Add Time To Date        ${d}    ${day} days         result_format=%Y-%m-%d %H:%M:%S
    ${d}=           Add Time To Date        ${d}    ${hour} hours       result_format=%Y-%m-%d %H:%M:%S
    ${d}=           Add Time To Date        ${d}    ${minute} minutes   result_format=%Y-%m-%d %H:%M:%S
    ${d}=           Add Time To Date        ${d}    ${second} seconds   result_format=%Y-%m-%d %H:%M:%S
    ${d}=           Convert To String       ${d}
    ${d}=           Replace String          ${d}    ${SPACE}    T
    ${d}=           Set Variable            ${d}${timezone}
    [return]        ${d}

Generate Date X UTC Time - X Day - X Hour - X Minute - X Second - X Timezone SEPARATELY
    [Arguments]     ${utc_time}     ${day}  ${hour}     ${minute}   ${second}   ${timezone}
    [Documentation]     Possible values:
    ...                 ${utc_time} can be 7 for UTC+7 or -7 for UTC-7 and so on. Set 0 for default
    ...                 ${day} can be picked to -1 for yesterday or 1 for next day and so on. Set 0 for default
    ...                 ${hour} can be picked to -1 for an hour ago or 1 for next hour and so on. Set 0 for default
    ...                 ${minute} can be picked to -1 for a minute ago or 1 for next minute and so on. Set 0 for default
    ...                 ${second} can be picked to -1 for a second ago or 1 for next second and so on. Set 0 for default
    ...                 ${timezone} pick your timezon can be +07:00 or Z. Set ${EMPTY} for EMPTY or +00:00 for default. WATCH your ${utc_time}
    ${d}=           Get Current Date        UTC     ${utc_time} hours
    ${d}=           Add Time To Date        ${d}    ${day} days         result_format=%Y-%m-%d %H:%M:%S
    ${d}=           Add Time To Date        ${d}    ${hour} hours       result_format=%Y-%m-%d %H:%M:%S
    ${d}=           Add Time To Date        ${d}    ${minute} minutes   result_format=%Y-%m-%d %H:%M:%S
    ${d}=           Add Time To Date        ${d}    ${second} seconds   result_format=%Y-%m-%d %H:%M:%S
    ${d}=           Convert To String       ${d}
    ${d}=           Replace String          ${d}    ${SPACE}    T
    ${d}=           Set Variable            ${d}${timezone}
    ${year}=        Get Substring   ${d}    0   4
    ${month}=       Get Substring   ${d}    5   7
    ${day}=         Get Substring   ${d}    8   10
    ${hour}=        Get Substring   ${d}    11   13
    ${minute}=      Get Substring   ${d}    14   16
    ${second}=      Get Substring   ${d}    17   19
    ${result}=      Create Dictionary   year=${year}    month=${month}      day=${day}
    ...             hour=${hour}    minute=${minute}    second=${second}
    ...             timezone=${timezone}
    [return]        ${result}

Generate Date X Day - X Timezone for JSON
    [Arguments]     ${day}      ${timezone}
    ${d}=           Get Current Date        result_format=%Y-%m-%d 00:00:00
    ${d}=           Add Time To Date        ${d}    ${day} days         result_format=%Y-%m-%d 00:00:00
    ${d}=           Convert To String       ${d}
    ${d}=           Replace String          ${d}    ${SPACE}    T
    ${d}=           Set Variable            ${d}${timezone}
    [return]        ${d}
    
Convert Date Into Spesific TimeZone
    [Arguments]     ${date}    ${timezone}
    ${d}=           Convert To String       ${date}
    ${d}=           Replace String          ${d}    ${SPACE}    T
    ${d}=           Set Variable            ${d}${timezone}
    [return]        ${d}

Set URI by Combining It With Other Input
    [Arguments]             ${URI}      ${operator}     ${input}
    Log                     URI received is ${URI} and the operator received is ${operator} and the input received is ${input}
    ${URI}=                 Set Variable        ${URI}${operator}${input}
    Log                     ${URI}
    [Return]                ${URI}

Convert String Into Base64
    [Arguments]             ${input}
    Log                     Input received is ${input}
    ${result}=              Encode To Base64     ${input}
    Log                     ${result}
    [Return]                ${result}

Convert String Into MD5
    [Arguments]             ${input}
    Log                     Input received is ${input}
    ${result}=              Encode To MD5     ${input}
    Log                     ${result}
    [Return]                ${result}

Convert String Into SHA256
    [Arguments]             ${input}
    Log                     Input received is ${input}
    ${result}=              Encode To SHA256     ${input}
    Log                     ${result}
    [Return]                ${result}

Convert String Into Fowler Noll Vo 1a 32
    [Arguments]             ${input}
    Log                     Input received is ${input}
    ${result}=              Encode To Fowler Noll Vo 1a 32     ${input}
    Log                     ${result}
    [Return]                ${result}

Convert Value Of Boolean Into Digit And Vice Versa
    [Documentation]     Convert true into 1 - false into 0 AND vice versa
    ...                 The data type of the result will be returned accordingly
    [Arguments]         ${input}
    ${result}=          Run Keyword If  '${input}'=='TRUE'          Set Variable        1
    ...                 ELSE IF         '${input}'=='true'          Set Variable        1
    ...                 ELSE IF         '${input}'=='True'          Set Variable        1
    ...                 ELSE IF         '${input}'=='${TRUE}'       Set Variable        1
    ...                 ELSE IF         '${input}'=='FALSE'         Set Variable        0
    ...                 ELSE IF         '${input}'=='false'         Set Variable        0
    ...                 ELSE IF         '${input}'=='False'         Set Variable        0
    ...                 ELSE IF         '${input}'=='${FALSE}'      Set Variable        0
    ...                 ELSE IF         '${input}'=='1'             Set Variable        ${TRUE}
    ...                 ELSE IF         '${input}'=='0'             Set Variable        ${FALSE}
    ...                 ELSE            Set Variable                ${input}
    ${result}=          Convert Input To Correct Data Type          ${result}
    [Return]            ${result}

Get First X Characters in String
    [Arguments]             ${input}        ${length}
    Log                     Input received is ${input} and length received is ${length}
    ${result}=              Get Substring   ${input}        0       ${length}
    Log                     ${result}
    [Return]                ${result}

Get Last X Characters in String
    [Arguments]             ${input}        ${length}
    Log                     Input received is ${input} and length received is ${length}
    ${result}=              Get Substring   ${input}        -${length}
    Log                     ${result}
    [Return]                ${result}

Check Data Type
    [Arguments]         ${object}
    [Documentation]     Checks if the ${object} is INTEGER, NUMBER or STRING
    Return From Keyword If      not "${object}"    NONE
    ${result}       ${value}=      Run Keyword And Ignore Error    Convert To Number        ${object}
    ${isnumber}=    Run Keyword And Return Status    Should Be Equal As Strings             ${object}   ${value}
    ${result}       ${value}=      Run Keyword And Ignore Error    Convert To Integer       ${object}
    ${isinteger}=   Run Keyword And Return Status   Should Be Equal As Strings              ${object}   ${value}
    ${result}       ${value}=      Run Keyword And Ignore Error    Convert To Boolean       ${object}
    ${isBoolean}=   Run Keyword And Return Status   Should Be Equal As Strings              ${object}   ${value}
    Return From Keyword If      ${isnumber}     NUMBER
    Return From Keyword If      ${isinteger}    INTEGER
    # Return From Keyword If      ${isBoolean}    BOOLEAN
    Return From Keyword If      '${object}'=='TRUE' or '${object}'=='FALSE' or '${object}'=='True' or '${object}'=='False' or '${object}'=='true' or '${object}'=='false'       BOOLEAN
    Return From Keyword         STRING

Convert Input To Correct Data Type
    [Arguments]         ${input}
    ${data_type}=       Check Data Type     ${input}
    ${result}=          Run Keyword If  '${data_type}'=='INTEGER'   Convert To Integer  ${input}
    ...                 ELSE IF         '${data_type}'=='NUMBER'    Convert To Number   ${input}
    ...                 ELSE IF         '${input}'=='TRUE'          Set Variable        ${TRUE}
    ...                 ELSE IF         '${input}'=='true'          Set Variable        ${TRUE}
    ...                 ELSE IF         '${input}'=='True'          Set Variable        ${TRUE}
    ...                 ELSE IF         '${input}'=='FALSE'         Set Variable        ${FALSE}
    ...                 ELSE IF         '${input}'=='false'         Set Variable        ${FALSE}
    ...                 ELSE IF         '${input}'=='False'         Set Variable        ${FALSE}
    ...                 ELSE            Convert To String           ${input}
    [Return]            ${result}

Create HMAC256 with secret key
    [Arguments]             ${input}              ${secretKey}
    Log                     Input received is ${input}
    Log                     Input received is ${secretKey}
    ${result}=              Encode To HMAC256   ${input}    ${secretKey}
    Log                     ${result}
    [Return]                ${result}

Remove Space Characters In A Word
    [Arguments]             ${input}
    Log                     Input received is ${input}
    ${str}=                 Convert To String      ${input}
    ${result}=              Remove String   ${str}    ${space}   ${empty}
    [Return]                ${result}

Convert Number Into Specific Defined Decimal Places - Round Method
    [Arguments]                     ${input}              ${inputtedDecimal}
    Log                             Input received is ${input}
    Log                             Input received is ${inputtedDecimal}
    ${inputIsHere}=                 Convert To Number       ${input}
    ${inputtedDecimalIsHere}        Convert To Integer      ${inputtedDecimal}
    ${resultAsNumber}=              Convert Number Into Defined Decimal   ${inputIsHere}    ${inputtedDecimalIsHere}
    ${result}=                      Convert To String       ${resultAsNumber}
    Log                             ${result}
    [Return]                        ${result}

Convert Number Into Specific Defined Decimal Places - Floor Method
    [Arguments]                     ${input}              ${inputtedDecimal}
    Log                             Input received is ${input}
    Log                             Input received is ${inputtedDecimal}
    ${inputIsHere}=                 Convert To Number       ${input}
    ${inputtedDecimalIsHere}=       Convert To Integer      ${inputtedDecimal}
    ${resultAsNumber}=              Convert Number Into Defined Floor Decimal   ${inputIsHere}    ${inputtedDecimalIsHere}
    ${result}=                      Convert To String       ${resultAsNumber}
    Log                             ${result}
    [Return]                        ${result}

Convert Number Into Specific Defined Decimal Places - Ceil Method
    [Arguments]                     ${input}              ${inputtedDecimal}
    Log                             Input received is ${input}
    Log                             Input received is ${inputtedDecimal}
    ${inputIsHere}=                 Convert To Number       ${input}
    ${inputtedDecimalIsHere}=       Convert To Integer      ${inputtedDecimal}
    ${resultAsNumber}=              Convert Number Into Defined Ceil Decimal   ${inputIsHere}    ${inputtedDecimalIsHere}
    ${result}=                      Convert To String       ${resultAsNumber}
    Log                             ${result}
    [Return]                        ${result}

Generate UUID Based on Type
    [Arguments]                 ${uuidType}
    Log                         Input received is ${uuidType}
    ${resultAsUuid}=            Run Keyword If                  '${uuidType}'=='4'      Generate Uuid Type Four
    ${result}=                  Convert To String               ${resultAsUuid}
    Log                         ${result}
    [Return]                    ${result}

Create Multi Part
    [Documentation]     This keyword is used prior uploading file(s) using REST POST API method
    ...                 to prepare the file data to be uploaded
    [Arguments]     ${add_to}   ${part_name}    ${file_path}
    ${file_data}=   Get Binary File     ${file_path}
    ${file_dir}  ${file_name}=  Split Path  ${file_path}
    ${part_data}=   Create List     ${file_name}    ${file_data}    ${None}
    Set To Dictionary   ${add_to}   ${part_name}=${part_data}
    [Return]    ${add_to}

Add or Delete Selected params Key
    [Arguments]     ${params}   ${params_key}   ${params_value}
    Run Keyword If  '${params_value}'=='none'   Remove From Dictionary  ${params}   ${params_key}
    Log             ${params}
    [Return]        ${params}

Change None into Some Value
    [Arguments]     ${input}    ${type}
    ${result}=      Run Keyword If  '${input}'=='none' and '${type}'=='zero'    Set Variable    ${0}
    ...                 ELSE IF     '${input}'=='none' and '${type}'=='empty'   Set Variable    ${Empty}
    ...                 ELSE IF     '${input}'=='none' and '${type}'=='false'   Set Variable    ${False}
    ...                 ELSE    Set Variable    ${input}
    [Return]        ${result}