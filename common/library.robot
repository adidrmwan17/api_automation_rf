*** Settings ***
Documentation   Mandatory Libraries
Library         RequestsLibrary
Library         Collections
Library         JSONLibrary
Library         String
Library         Process
Library         DateTime
Library         FakerLibrary
Library         OperatingSystem
Library         ImapLibrary2
Library         jsonschema
Library         ConfluentKafkaLibrary

Library         RobotMongoDBLibrary.Insert
Library         RobotMongoDBLibrary.Update
Library         RobotMongoDBLibrary.Find
Library         RobotMongoDBLibrary.Delete

Library         ${EXECDIR}/common/lib/csvLibrary.py
Library         ${EXECDIR}/common/lib/jsonSchema.py
Library         ${EXECDIR}/common/lib/readJson.py
Library         ${EXECDIR}/common/lib/encoder.py
Library         ${EXECDIR}/common/lib/numberFormatted.py
Library         ${EXECDIR}/common/lib/generateUuid.py
Library         ${EXECDIR}/common/lib/mongoDbLib.py
Library         ${EXECDIR}/common/lib/cassandraCqlLibrary.py
Library         ${EXECDIR}/common/lib/gqlLibrary.py
Library         ${EXECDIR}/common/lib/oauth2Library.py
Library         ${EXECDIR}/common/lib/configTemplate.py
Library         ${EXECDIR}/common/lib/excelLibrary.py

Library         ${EXECDIR}/common/lib/DatabaseLibrary/