from jsonschema import validate

class jsonSchema(object):
    def json_check(self, schema_standard, json_doc):
        schema = schema_standard
        json_document = json_doc
        validate(instance=json_doc, schema=schema)
        try:
            validate(instance=json_doc, schema=schema)
            return True
        except expression as identifier:
            return False