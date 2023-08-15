*** Settings ***
Documentation   Keywords for Get Active Account Bank Partner
Resource        ${EXECDIR}/common/keyword/common_keyword.robot
Resource        ${EXECDIR}/variable/user/post_login_user.robot
Resource        ${EXECDIR}/variable/user/uri.robot
Variables        ${EXECDIR}/data/user/yaml/user.yaml

*** Keywords ***
User Generate Valid Data For Post Login User
    ${email}=           Set Variable        ${user.email}
    ${password}=        Set Variable        ${user.password}

    ${result}=          Create Dictionary       email=${email}      password=${password}

    [Return]            ${result}

User Define Payload For Post Login User
    [Arguments]     ${payload}     ${data_dict}     ${valid_data}
    ${email}=       Run Keyword If  '${data_dict.email}'=='valid'    Set Variable    ${valid_data.email}
    ...             ELSE    Convert Input To Correct Data Type     ${data_dict.email}
    ${password}=    Run Keyword If  '${data_dict.password}'=='valid'    Set Variable    ${valid_data.password}
    ...             ELSE    Convert Input To Correct Data Type     ${data_dict.password}

    ${payload}=     Update or Delete Selected JSON Key      ${payload}      ${key_post_login_user_email}            ${email}
    ${payload}=     Update or Delete Selected JSON Key      ${payload}      ${key_post_login_user_password}         ${password}

    Set To Dictionary   ${data_dict}    email               ${email}
    Set To Dictionary   ${data_dict}    password            ${password}

    [Return]    ${payload}

