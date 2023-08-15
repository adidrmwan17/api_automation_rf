# -*- coding: utf-8 -*-
import ssl

from typing import List, Optional, Union

from robot.api import logger
from robot.utils import ConnectionCache
from cassandra.auth import PlainTextAuthProvider
from cassandra.policies import TokenAwarePolicy, DCAwareRoundRobinPolicy
from cassandra.cluster import Cluster, ResponseFuture, ResultSet, Session


class cassandraCqlLibrary(object):
    """
    Library for executing CQL statements in database [ http://cassandra.apache.org/ | Apache Cassandra ].
    == Dependencies ==
    | datastax python-driver | https://github.com/datastax/python-driver |
    | robot framework | http://robotframework.org |
    == Additional Information ==
    - [ http://www.datastax.com/documentation/cql/3.1/cql/cql_using/about_cql_c.html | CQL query language]
    == Example ==
    | *Settings* | *Value* | *Value* | *Value* |
    | Library    | CassandraCQLLibrary |
    | Library    | Collections |
    | Suite Setup     |  Connect To Cassandra  |  192.168.33.10  |  9042 |
    | Suite Teardown  |  Disconnect From Cassandra |
    | *Test Cases*  | *Action* | *Argument* | *Argument* |
    | Get Keyspaces |
    |               | Execute CQL  |  USE system |
    |               | ${result}=   |  Execute CQL  |  SELECT * FROM schema_keyspaces; |
    |               | Log List  |  ${result} |
    |               | Log  |  ${result[1].keyspace_name} |
    """

    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self) -> None:
        """ Initialization. """
        self._connection: Optional[Session] = None
        self._cache = ConnectionCache()

    @property
    def keyspace(self) -> str:
        """Get keyspace Cassandra.
        Returns:
            keyspace: the name of the keyspace in Cassandra.
        """
        if self._connection is None:
            raise Exception('There is no connection to Cassandra cluster.')
        return self._connection.keyspace

    def connect_to_cassandra(self, host: str, port: Union[int, str] = 9042, alias: str = None, keyspace: str = None,
                             username: str = None, password: str = '') -> Session:
        """
        Connect to Apache Cassandra cluster.
        AllowAllAuthenticator and PasswordAuthenticator are supported as authentication backend.
        This setting should be in configuration file cassandra.yaml:
        by default:
        | authenticator: AllowAllAuthenticator
        or for password authentification:
        | authenticator: PasswordAuthenticator
        *Args:*\n
            _host_ - IP address or host name of a cluster node;\n
            _port_ - connection port;\n
            _alias_ - connection alias;\n
            _keyspace_ - the name of the keyspace that the UDT is defined in;\n
            _username_ - username to connect to cassandra
            _password_ - password for username
        *Returns:*\n
            Index of current connection.
        *Example:*\n
        | Connect To Cassandra  |  192.168.1.108  |  9042  |  alias=cluster1 |
        """
        try:
            auth_provider = PlainTextAuthProvider(username=username, password=password) if username else None
            ssl_options = {
                'ca_certs': './Cert/cassandra-client-staging.pem',
                'ssl_version': ssl.PROTOCOL_TLSv1
            }
            cluster = Cluster([host], port=int(port), auth_provider=auth_provider,
                              load_balancing_policy=TokenAwarePolicy(DCAwareRoundRobinPolicy()),
                              ssl_options=ssl_options,
                              protocol_version=4)

            session = cluster.connect()
            if keyspace is not None:
                session.set_keyspace(keyspace)
            self._connection = session
            return self._cache.register(self._connection, alias)
        except Exception as e:
            raise Exception('Connect to Cassandra error: {0}'.format(e))

    def disconnect_from_cassandra(self) -> None:
        """
        Close current connection with cluster.
        *Example:*\n
        | Connect To Cassandra  |  server-host.local |
        | Disconnect From Cassandra |
        """
        if self._connection is None:
            raise Exception('There is no connection to Cassandra cluster.')
        self._connection.shutdown()

    def execute_cql(self, statement: str) -> ResultSet:
        """
        Execute CQL statement.
        *Args:*\n
            _statement_ - CQL statement;
        *Returns:*\n
            Execution result.
        *Example:*\n
        | ${result}=  |  Execute CQL  |  SELECT * FROM system.schema_keyspaces; |
        | Log  |  ${result[1].keyspace_name} |
        =>\n
        system
        """
        if not self._connection:
            raise Exception('There is no connection to Cassandra cluster.')

        logger.debug("Executing :\n %s" % statement)
        result = self._connection.execute(statement, timeout=60)
        return result
