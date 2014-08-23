Sample Name ---- Spark CurrencyValidator

Introduction:
The CurrencyValidator class ensures that a String represents a valid currency amount according to the conventions of a locale. This class uses the locale style for specifying the Locale ID. 

The validator can ensure that a currency string falls within a given range (specified by minValue and maxValue properties), is an integer (specified by domain property), is non-negative (specified by allowNegative property), correctly specifies negative and positive numbers, has the correct currency ISO code or currency symbol, and does not exceed the specified number of fractionalDigits. 

Usage of the sample code:
1. Select a Locale from the locale comboBox first. It will use en_US as the default choice.
2. Enter a number into text input.(The number should be an integer and less than 100.)
3. Make focus out of the text input to validate the number you entered.
4. If the data entered is invalid, error message in red will be shown. 