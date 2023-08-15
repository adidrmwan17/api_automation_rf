from oauth2Library import oauth2Library
from oauthlib.oauth2 import MissingTokenError
import pytest
import time

class Test_OAuth2Library(object):

    @pytest.fixture
    def oauth2(self):
        return oauth2Library()

    # integration test
    @pytest.mark.integration_test
    @pytest.mark.parametrize(
        'token_url, client_id, client_secret, should_success',
        [
            (
                'https://accountsvc.staging-0.shipper.id/v1/oauth2/token', 
                '4368c6b6-89ad-42c4-8d7b-845d0d485ad7', 
                'e2XXvhowNC04MlvktrhH',
                True),
            (
                'https://accountsvc.staging-0.shipper.id/v1/oauth2/token', 
                'invalid client id', 
                'invalid client secret',
                False),
        ]
    )
    def test_oauth2_get_client_credentials(self, oauth2, token_url, client_id, client_secret, should_success):
        token = oauth2.oauth2_client_credentials(token_url, client_id, client_secret)
        if should_success :
            assert len(token.get('access_token')) > 0
            refreshed_token = oauth2.oauth2_refresh_token('client_credentials', token_url, client_id, client_secret, token, '', '')
            assert len(refreshed_token.get('access_token')) > 0
            assert token.get('access_token') != refreshed_token.get('access_token')
        else :
            assert type(token) == MissingTokenError
    
    # integration test
    @pytest.mark.integration_test
    @pytest.mark.parametrize(
        'token_url, client_id, client_secret, username, password, should_success',
        [
            (
                'https://accountsvc.staging-0.shipper.id/v1/oauth2/token', 
                '5fc3eb81-f604-497f-ab26-1011d67af978', 
                'RMQ9cWAWm6FHKKgePSYtp6sSZ7fEEbv3',
                'qa+1110@shipper.id',
                '12345678',
                True),
            (
                'https://accountsvc.staging-0.shipper.id/v1/oauth2/token', 
                'invalid client id', 
                'invalid client secret',
                '',
                '',
                False),
        ]
    )
    def test_oauth2_get_password(self, oauth2, token_url, client_id, client_secret, username, password, should_success):
        token = oauth2.oauth2_password(token_url, client_id, client_secret, username, password)
        # refresh only when valid
        if should_success:
            assert len(token.get('access_token')) > 0
            refreshed_token = oauth2.oauth2_refresh_token('password', token_url, client_id, client_secret, token, username, password)
            assert len(refreshed_token.get('access_token')) > 0
            assert token.get('access_token') != refreshed_token.get('access_token')
        else:
            assert type(token) == MissingTokenError

    #mock test to replicate whenever token expires
    @pytest.mark.unit_test
    @pytest.mark.parametrize(
        'token_url, client_id, client_secret, expected_token, expected_refreshed_token, should_success',
        [
            (
                # refresh token since token expires within one second ( < 5 mins/ 300s )
                'https://accountsvc.staging-0.shipper.id/v1/oauth2/token', 
                'my_client_id', 
                'my_client_secret',
                {"expires_in": 1, "access_token": "access_token", "refresh_token": "refresh_token"},
                {'expires_in': 3600, "access_token": "refreshed_access_token", "refresh_token": "refresh_token"},
                True),
             (
                # no refresh since token expires within an hour
                'https://accountsvc.staging-0.shipper.id/v1/oauth2/token', 
                'my_client_id', 
                'my_client_secret',
                {"expires_in": 3600, "access_token": "access_token", "refresh_token": "refresh_token"},
                {"expires_in": 3600, "access_token": "access_token", "refresh_token": "refresh_token"},
                True),
            (
                # failed
                'https://accountsvc.staging-0.shipper.id/v1/oauth2/token', 
                'invalid client id', 
                'invalid client secret',
                {},
                {},
                False),
        ]
    )
    def test_oauth2_client_credentials_test_refresh_token(self, mocker, oauth2, token_url, client_id, client_secret, expected_token, expected_refreshed_token, should_success):

        with mocker.patch('requests_oauthlib.OAuth2Session.fetch_token', return_value=expected_token):
            token = oauth2.oauth2_client_credentials(token_url, client_id, client_secret)
            if should_success:
                assert token == expected_token
                # recall to refresh
                with mocker.patch('requests_oauthlib.OAuth2Session.refresh_token', return_value=expected_refreshed_token):
                    token = oauth2.oauth2_client_credentials(token_url, client_id, client_secret)
                    assert token == expected_refreshed_token

    #mock test to replicate whenever token expires
    @pytest.mark.unit_test
    @pytest.mark.parametrize(
            'token_url, client_id, client_secret, username, password, expected_token, expected_refreshed_token, should_success',
            [
                # refresh token since token expires within one second ( < 5 mins/ 300s )
                (
                    'https://accountsvc.staging-0.shipper.id/v1/oauth2/token', 
                    'client_id', 
                    'client_secret',
                    'username',
                    'password',
                    {"expires_in": 1, "access_token": "access_token", "refresh_token": "refresh_token"},
                    {'expires_in': 3600, "access_token": "refreshed_access_token", "refresh_token": "refresh_token"},
                    True),
                (
                    # no refresh since token expires within an hour
                    'https://accountsvc.staging-0.shipper.id/v1/oauth2/token', 
                    'client_id', 
                    'client_secret',
                    'username',
                    'password',
                    {"expires_in": 3600, "access_token": "access_token", "refresh_token": "refresh_token"},
                    {"expires_in": 3600, "access_token": "access_token", "refresh_token": "refresh_token"},
                    True),
                (
                    'https://accountsvc.staging-0.shipper.id/v1/oauth2/token', 
                    'invalid client id', 
                    'invalid client secret',
                    '',
                    '',
                    {},
                    {},
                    False),
            ]
        )
    def test_oauth2_password_test_refresh_token(self, mocker, oauth2, token_url, client_id, client_secret, username, password, expected_token, expected_refreshed_token, should_success):

        with mocker.patch('requests_oauthlib.OAuth2Session.fetch_token', return_value=expected_token):
            token = oauth2.oauth2_password(token_url, client_id, client_secret, username, password)
            if should_success:
                assert token == expected_token
                # recall to refresh
                with mocker.patch('requests_oauthlib.OAuth2Session.refresh_token', return_value=expected_refreshed_token):
                    token = oauth2.oauth2_password(token_url, client_id, client_secret, username, password)
                    assert token == expected_refreshed_token