Sample Name ---- Spark CurrencyValidator

Introduction:
The CurrencyValidator class ensures that a String represents a valid currency amount according to the conventions of a locale. This class uses the locale style for specifying the Locale ID. 

The validator can ensure that a currency string falls within a given range (specified by minValue and maxValue properties), is an integer (specified by domain property), is non-negative (specified by allowNegative property), correctly specifies negative and positive numbers, has the correct currency ISO code or currency symbol, and does not exceed the specified number of fractionalDigits. 

Usage of the sample code:
1. Select a Locale from the locale comboBox first. It will use en_US as the default choice.
2. Once locale is selected, the currency symbol and ISO code will be shown based on current locale setting.
3. Input each data fields (totally five)
4. Validate data for each text field by making focus out of the text field
5. Or you can also validate all text field at same time by clicking the 'Validate All' button in below.
6. If the data entered is invalid, error message in red will be shown. 