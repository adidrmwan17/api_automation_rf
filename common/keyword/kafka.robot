*** Settings ***
Resource        ${EXECDIR}/common/library.robot
Documentation   Kafka General Function

*** Keywords ***
Publish Message to Kafka
    [Arguments]  ${server}  ${port}  ${topic}  ${header}  ${value}
    ${producer_id}=  Create Producer  ${server}  ${port}
    Produce  group_id=${producer_id}  topic=${topic}  value=${value}  headers=${header}
    Wait Until Keyword Succeeds  10x  0.5s  All Messages Are Delivered  ${producer_id}

All Messages Are Delivered
    [Arguments]  ${producer_id}
    ${count}=  Flush  ${producer_id}
    Log  Reaming messages to be delivered: ${count}
    Should Be Equal As Integers  ${count}  0


