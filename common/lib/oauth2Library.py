from oauthlib.oauth2 import LegacyApplicationClient, BackendApplicationClient
from requests_oauthlib import OAuth2Session
from requests.auth import HTTPBasicAuth
import time

class oauth2Library:
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    
    def __init__(self) -> None:
        self.oauth_sessions = {}
        self.tokens = {}
        self.expired_at = {}

    def _stringify_values(self, mode, token_url, client_id, client_secret, username='', password=''):
        return "%s@%s|%s:%s|%s:%s" % (mode, token_url, client_id, client_secret, username, password)

    def _init_oauth2_client_credentials(self, client_id):
        client = BackendApplicationClient(client_id=client_id)
        oauth = OAuth2Session(client=client)
        return oauth

    def _init_oauth2_password(self, client_id):
        client = LegacyApplicationClient(client_id=client_id)
        oauth = OAuth2Session(client=client)
        return oauth

    def _init_oauth2_refresh_token(self, client_id, expired_token):
        return OAuth2Session(client_id, token=expired_token)
    
    def oauth2_refresh_token(self, mode, refresh_token_url, client_id, client_secret, expired_token, username='', password=''):
        key = self._stringify_values(mode, refresh_token_url, client_id, client_secret, username, password)
        
        client = self._init_oauth2_refresh_token(client_id=client_id, expired_token=expired_token)
        auth = HTTPBasicAuth(client_id, client_secret)
        token = client.refresh_token(refresh_token_url, auth=auth)

        if ( token.get('access_token') and token.get('expires_in') ) == False :
            raise ValueError("error on oauth2 refresh token - get invalid payload from token endpoint")
        self.expired_at[key] = int(time.time()) + token['expires_in'] - 300 # minus 300 sec so it will be refreshed earlier
        self.tokens[key] = token

        return token

    def oauth2_client_credentials(self, token_url, client_id, client_secret):
        key = self._stringify_values("client_credentials", token_url, client_id, client_secret)
        
        # if token exists - we don't need to reinitialize the oauth2 client
        if self.tokens.get(key) and self.oauth_sessions.get(key) :
            # check the expiration key, if it is expired then refresh
            if int(time.time()) > self.expired_at[key]:
                return self.oauth2_refresh_token('client_credentials', 
                    refresh_token_url=token_url, 
                    client_id=client_id,
                    client_secret=client_secret,
                    username='',
                    password='',
                    expired_token=self.tokens[key])
            return self.tokens[key] 

        if self.oauth_sessions.get(key) is None:
            self.oauth_sessions[key] = self._init_oauth2_client_credentials(client_id)

        try :
            auth = HTTPBasicAuth(client_id, client_secret)
            token = self.oauth_sessions[key].fetch_token(token_url=token_url, auth=auth)
            if ( token.get('access_token') and token.get('expires_in') ) == False :
                raise ValueError("error on oauth2 client credentials - get invalid payload from token endpoint")
            self.expired_at[key] = int(time.time()) + token['expires_in'] - 300 # minus 300 sec so it will be refreshed earlier
            self.tokens[key] = token
        except Exception as e :
            return e

        return self.tokens[key]

    def oauth2_password(self, token_url, client_id, client_secret, username, password):
        key = self._stringify_values("password", token_url, client_id, client_secret, username, password)
        
        # if token exists - we don't need to reinitialize the oauth2 client
        if self.tokens.get(key) and self.oauth_sessions.get(key) :
            # check the expiration key, if it is expired then refresh
            if int(time.time()) > self.expired_at[key]:
                return self.oauth2_refresh_token('password',
                        refresh_token_url=token_url, 
                        client_id=client_id,
                        client_secret=client_secret,
                        username=username,
                        password=password,
                        expired_token=self.tokens[key])
            return self.tokens[key]

        if self.oauth_sessions.get(key) is None :
            self.oauth_sessions[key] = self._init_oauth2_password(client_id)

        try :
            auth = HTTPBasicAuth(client_id, client_secret)
            token = self.oauth_sessions[key].fetch_token(token_url=token_url, 
                                auth=auth, 
                                username=username, 
                                password=password)
            if ( token.get('access_token') and token.get('expires_in') ) == False :
                raise ValueError("error on oauth2 password - get invalid payload from token endpoint")
            self.expired_at[key] = int(time.time()) + token['expires_in'] - 300 # minus 300 sec so it will be refreshed earlier
            self.tokens[key] = token
        except Exception as e :
            return e

        return self.tokens[key]