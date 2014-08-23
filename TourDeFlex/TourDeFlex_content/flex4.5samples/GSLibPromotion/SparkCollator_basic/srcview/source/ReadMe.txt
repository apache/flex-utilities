Sample Name ---- Spark SortingCollator

Introduction:
The SortingCollator class provides locale-sensitve string comparison capabilities with inital settings suitable for linguistic sorting purposes such as sorting a list of text strings that are displayed to an end-user. The MatchingCollator class provides locale-sensitve string comparison capabilities with inital settings suitable for general string matching such as finding a matching word in a block of text. 

SortingCollator and MatchingCollator are wrepper classes around the flash.globalization.Collator class. Therefore the locale-specific string comparison is provided by the flash.globalization.Collator class.

For more information about flash.globalization.Collator, please visit:  http://help.adobe.com/en_US/FlashPlatform/beta/reference/actionscript/3/flash/globalization/Collator.html 

Usage of the sample code:
1. Select locale for the SortingCollator
2. Input two strings in the text inputs
3. Change the property value to see different sorting result by select/un-select each check boxes
4. Compare result of those two strings will shows in the middle of two text inputs.