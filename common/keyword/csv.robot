*** Settings ***
Resource        ${EXECDIR}/common/library.robot
Documentation   CSV General Function

*** Keywords ***
# ~~~ START - CSV Related Keyword ~~~
Read CSV File From The Specified Path
    [arguments]             ${csvFilePath}
    ${csvFile}=             Read CSV File       ${csvFilePath}
    Log                     ${csvFile}
    [Return]                ${csvFile}

Read CSV File From The Specified URL
    [arguments]             ${csvFileUrl}
    ${csvFile}=             Read CSV URL       ${csvFileUrl}
    Log                     ${csvFile}
    [Return]                ${csvFile}

Get Number of Data Rows in CSV File Excluding Header
    [arguments]             ${csvFile}
    Log                     ${csvFile}
    ${count}=               Get Length      ${csvFile}
    Log                     Return number of rows including header
    Log                     ${count}
    ${count}=               Evaluate        ${count} - 1
    Log                     Return number of rows excluding header
    ${count}=               Convert To Integer      ${count}
    Log                     ${count}
    [return]                ${count}
Get Number of Data Columns in CSV File
    [arguments]             ${csvFile}
    Log                     ${csvFile}
    ${count}=               Get Length      ${csvFile[0]}
    ${count}=               Convert To Integer      ${count}
    Log                     ${count}
    [return]                ${count}
Create Key-Value Pair from The Read CSV File
    [Arguments]         ${data}     ${row}      ${column_number}
    &{data_dict}=       Create Dictionary       none=none
    FOR    ${i}    IN RANGE        9999
        Set To Dictionary       ${data_dict}                ${data[0][${i}]}=${data[${row}][${i}]}
        Exit For Loop If        ${i}==${column_number-1}
    END
    Remove From Dictionary          ${data_dict}                none
    [Return]            ${data_dict}

Get CSV Data
    [Documentation]     This keyword returns dictionary with key:
    ...                 data, row_number and column_number
    [Arguments]     ${csv_filepath}
    ${data}=        Read CSV File From The Specified Path       ${csv_filepath}
    ${row_number}=      Get Number of Data Rows in CSV File Excluding Header        ${data}
    ${column_number}=   Get Number of Data Columns in CSV File      ${data}
    &{result}=      Create Dictionary   data=${data}    row_number=${row_number}    column_number=${column_number}
    [Return]        ${result}

Update Specific Row and Column of a CSV File
    [Arguments]         ${data}     ${row}      ${columnNameInput}      ${inputtedData}
    ${column}=  Get Column Number of A Header   ${data}     ${columnNameInput}
    ${data}=    Update CSV Content      ${data}     ${row}      ${column}      ${inputtedData}
    [Return]                ${data}

Write a CSV File from Data List
    [Arguments]     ${filename}     ${data}
    Write Data Into CSV     ${filename}     ${data}

Get Column Number of A Header
    [Arguments]     ${data}     ${columnNameInput}
    ${lengthOfColumn}=  Get length    ${data[0]}
    ${columnNameList}=      Set Variable    ${data[0]}
    ${columnNumber}=    Get Index From List     ${columnNameList}   ${columnNameInput}
    [Return]    ${columnNumber}

# ~~~ END - CSV Related Keyword ~~~