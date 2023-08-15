import math

class numberFormatted(object):

    def convert_number_into_defined_decimal(self, input, inputDecimal):
        '''This creates a keyword named "Convert Number Into Defined Decimal"
        This keyword takes two argument. It returns the string back into number
        '''
        return '{:.2f}'.format(round(input, inputDecimal))

    def convert_number_into_defined_floor_decimal(self, input, inputDecimal):
        '''This creates a keyword named "Convert Number Into Defined Floor Decimal"
        This keyword takes two argument. It returns the string back into number
        '''
        return (math.floor(input*(10**inputDecimal)))/(10**inputDecimal)

    def convert_number_into_defined_ceil_decimal(self, input, inputDecimal):
        '''This creates a keyword named "Convert Number Into Defined Floor Decimal"
        This keyword takes two argument. It returns the string back into number
        '''
        return (math.ceil(input*(10**inputDecimal)))/(10**inputDecimal)

    def convert_number_into_ordinal_number(self, input):
        '''
        Convert an integer into its ordinal representation::

            make_ordinal(0)   => '0th'
            make_ordinal(3)   => '3rd'
            make_ordinal(122) => '122nd'
            make_ordinal(213) => '213th'
        '''
        n = int(input)
        suffix = ['th', 'st', 'nd', 'rd', 'th'][min(n % 10, 4)]
        if 11 <= (n % 100) <= 13:
            suffix = 'th'
        return str(n) + suffix
