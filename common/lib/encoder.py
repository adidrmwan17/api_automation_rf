import base64
import hashlib
import hmac
import fnvhash

class encoder(object):

    def encode_to_base64(self, input):
        '''This creates a keyword named "Encode To Base64"

        This keyword takes one argument, which is string. It
        returns the string back into base 64
        '''
        input = bytes(input, encoding = 'utf-8')
        b64Val = base64.b64encode(input)
        result = b64Val
        print(result.decode('utf-8'))
        return result.decode('utf-8')
    
    def encode_to_md5(self, input):
        '''This creates a keyword named "Encode To MD5"

        This keyword takes one argument, which is string. It
        returns the string back into MD5
        '''
        str = input
        result = hashlib.md5(str.encode())
        print("The hexadecimal equivalent of hash is : ", end ="") 
        print(result.hexdigest())
        return (result.hexdigest())
    
    def encode_to_sha256(self, input):
        '''This creates a keyword named "Encode To SHA256"

        This keyword takes one argument, which is string. It
        returns the string back into SHA256
        '''
        str = input
        result = hashlib.sha256(str.encode())
        print("The hexadecimal equivalent of hash is : ", end ="") 
        print(result.hexdigest())
        return (result.hexdigest())

    def encode_to_hmac256(self, input, secretKeyInput):
        '''This creates a keyword named "Encode To HMAC256"

        This keyword takes two arguments, which is string. It
        returns the string back into HMAC256
        '''
        message = input.encode('utf-8')
        secretKey = secretKeyInput.encode('utf-8')
        hash = hmac.new(secretKey, message, hashlib.sha256)
        return hash.hexdigest()

    def encode_to_fowler_noll_vo_1a_32(self, input):
        message = input.encode('utf-8')
        result = fnvhash.fnv1a_32(message)
        return result
