from pymongo import MongoClient

class mongoDbLib(object):
    def connect_to_mongodb(self, mongo_uri_set, replica_set):
        client = MongoClient("mongodb://" + mongo_uri_set + "/?replicaSet=" + replica_set)
        return client

    def mongodb_insert_single_file(self, mongo_uri_set, replica_set, db_name, col_name, mongo_query):
        '''This creates a keyword named "Mongodb Insert Single File"

        This keyword return the generated Object ID
        '''
        client = self.connect_to_mongodb(mongo_uri_set, replica_set)
        db = client[db_name]
        collection = db[col_name]
        x = collection.insert_one(mongo_query)
        print(x.inserted_id)
        return x.inserted_id
    
    def mongodb_retrieve_object_id_from_mongo_query(self, mongo_uri_set, replica_set, db_name, col_name, mongo_query):
        '''This creates a keyword named "Mongodb retrieve Object Id From Mongo Query"

        This keyword return the Object ID
        '''
        client = self.connect_to_mongodb(mongo_uri_set, replica_set)
        db = client[db_name]
        collection = db[col_name]
        x = collection.find_one(mongo_query)
        ObjectId = x.get('_id')
        print(x)
        print(ObjectId)
        return ObjectId
    
    def mongodb_delete_single_file(self, mongo_uri_set, replica_set, db_name, col_name, mongo_query):
        '''This creates a keyword named "Mongodb Delete Single File"

        This keyword returns NOTHING
        '''
        client = self.connect_to_mongodb(mongo_uri_set, replica_set)
        db = client[db_name]
        collection = db[col_name]
        collection.delete_one(mongo_query)
    
    def mongodb_search_single_file(self, mongo_uri_set, replica_set, db_name, col_name, mongo_query):
        '''This creates a keyword named "Mongodb Search Single File"

        This keyword returns 1 file only. Random data will be returned if mongo_query is NOT defined
        '''
        client = self.connect_to_mongodb(mongo_uri_set, replica_set)
        db = client[db_name]
        collection = db[col_name]
        x = collection.find_one(mongo_query)
        print(x)
        return x
    
    def mongodb_count_documents(self, mongo_uri_set, replica_set, db_name, col_name, mongo_query):
        '''This creates a keyword named "Mongodb Count Documents"

        This keyword returns the number of documents. mongo_query can be set as None
        '''
        client = self.connect_to_mongodb(mongo_uri_set, replica_set)
        db = client[db_name]
        collection = db[col_name]
        x = collection.find(mongo_query).count()
        print(x)
        return x