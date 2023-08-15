*** Settings ***
Documentation   Keywords for Get Mission Polling Question Today
Resource        ${EXECDIR}/common/keyword/common_keyword.robot
Variables       ${EXECDIR}/data/user/yaml/user.yaml

*** Keywords ***
User Compare Result For Get Notifications
    [Arguments]         ${response}
    Run Keyword And Continue On Failure         Should Be Equal As Strings          Akun Anda belum terverifikasi.                              ${response.json()[0]['message']}
    Run Keyword And Continue On Failure         Should Be Equal As Strings          Akun Anda belum diproteksi Two-Factor Authentication        ${response.json()[1]['message']}
    Run Keyword And Continue On Failure         Should Be Equal As Strings          Anda belum menambah metode pembayaran.                      ${response.json()[2]['message']}