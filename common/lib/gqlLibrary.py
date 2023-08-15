import requests

class gqlLibrary(object):

    def execute_gql_query(self, uri, headers, query, variables):
        if variables is not None:
            response = requests.post(uri, json={'query': query, 'variables': variables}, headers=headers)
        else:
            response = requests.post(uri, json={'query': query}, headers=headers)

        return response
