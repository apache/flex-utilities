Sample Name ---- Spark NumberValidator

Introduction:
The NumberValidator class ensures that a String represents a valid number according to the conventions of a locale. It can validate strings that represent int,uint, and Number objects. 

The validator can ensure that the input falls within a given range (specified by minValue and maxValue properties), is an integer (specified by domain property), is non-negative (specified by allowNegative property), correctly specifies negative and positive numbers, and does not exceed the specified number offractionalDigits.

Usage of the sample code:
1. Select a Locale from the locale comboBox first. It will use en_US as the default choice.
2. Create customized validate criterions by entering value in text input like, 'Max Value'.
3. Create customized error message by entering value in the error message text input.
4. Input a number in the text input at bottom to validate.
5. Validate the inputted number by making focus out of the text input.
6. If the data entered is invalid, default error message in red will be shown if user did not customize their own one.
The customized error message will be shown if user already set one. 