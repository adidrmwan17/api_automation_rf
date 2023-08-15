*** Settings ***
Resource        ${EXECDIR}/common/library.robot
Documentation   Excel General Function

*** Keywords ***
# ~~~ START - Excel Related Keyword ~~~
Write Specific Cell of an Excel File
    [Arguments]         ${filePath}     ${fileName}       ${rowNumber}     ${columnNumber}      ${inputtedData}
    Open Excel Document         filename=${filePath}          doc_id=${fileName}
    Write Excel Cell            row_num=${rowNumber}           col_num=${columnNumber}           value=${inputtedData}
    Save Excel Document             filename=${filePath}
    Close All Excel Documents

Write Multiple Rows of an Excel File
    [Arguments]         ${filePath}     ${fileName}       ${rowNumber}     ${colData}      ${inputtedData}
    Open Excel Document             filename=${filePath}            doc_id=${fileName}
    ${i}=   Convert To Integer      0
    FOR     ${columnNumber}         IN         @{colData}
            Write Excel Cell        row_num=${rowNumber}            col_num=${columnNumber}           value=${inputtedData[${i}]}
            ${i}=                   Convert To Integer              ${i+1}
    END
    Save Excel Document             filename=${filePath}
    Close All Excel Documents

# ~~~ END - Excel Related Keyword ~~~