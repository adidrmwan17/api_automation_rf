*** Settings ***
Resource        ${EXECDIR}/common/library.robot
Variables       ${EXECDIR}/etc/conf/conf.yaml
Documentation   crated based on https://github.com/tarathep/robot-mongodb-library

*** Variables ***
${port}      27017

*** Keywords ***
Set Mongo DB Connection String
    [Arguments]  ${db_name}  ${collection}
    ${str_base_url}=    Get Substring  ${mongodb_orders.base_url}  1  -1
    @{members}=         Split String  ${str_base_url}  ${SPACE}
    ${conn_str}=        Set Variable  mongodb://${members}[0]:${port},${members}[1]:${port},${members}[2]:${port}/?replicaSet=${mongodb_orders.replica_set}
    &{MONGODB_CONNECT_STRING}=  Create Dictionary  connection=${conn_str}  database=${db_name}   collection=${collection}
    [Return]  ${MONGODB_CONNECT_STRING}

Set Mongo DB Connection String for Orders Collection
    ${MONGODB_CONNECT_STRING}=  Set Mongo DB Connection String  ${mongodb_orders.database}  orders
    [Return]  ${MONGODB_CONNECT_STRING}



