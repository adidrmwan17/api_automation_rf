import urllib.request
import json

class readJson(object):

    def read_json_file(self, filename):
        '''This creates a keyword named "Read JSON File"

        This keyword takes one argument, which is a path to a .json file. It
        returns the content of the JSON file.
        '''
        with open(filename) as json_file:
            data = json.load(json_file)
            # data = json.dumps(data, indent=4)
            return data
    
    def read_json_url(self, jsonUrl):
        '''This creates a keyword named "Read JSON URL"

        This keyword takes one argument, which is a path to a .json file. It
        returns the content of the JSON file.
        '''
        with urllib.request.urlopen(jsonUrl) as url:
            source = url.read()
            data = json.loads(source)
            # data = json.dumps(data, indent=4)
            return data