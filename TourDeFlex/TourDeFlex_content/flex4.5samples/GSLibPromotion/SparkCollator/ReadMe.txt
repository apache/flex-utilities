Sample Name ---- Spark SortingCollator and Spark MatchingCollator

Introduction:
The SortingCollator class provides locale-sensitve string comparison capabilities with inital settings suitable for linguistic sorting purposes such as sorting a list of text strings that are displayed to an end-user. The MatchingCollator class provides locale-sensitve string comparison capabilities with inital settings suitable for general string matching such as finding a matching word in a block of text. 

SortingCollator and MatchingCollator are wrepper classes around the flash.globalization.Collator class. Therefore the locale-specific string comparison is provided by the flash.globalization.Collator class.

For more information about flash.globalization.Collator, please visit:  http://help.adobe.com/en_US/FlashPlatform/beta/reference/actionscript/3/flash/globalization/Collator.html 

Usage of the sample code:
1. Select the collator type, SortingCollator or MatchingCollator (The sample will use MatchingCollator at initial).
2. Once collator type is selected, the checkboxes of property will be enabled with default value according to the collator type. And the strings in below list will be sorted based on those property settings.
3. Change the property value to see different sorting result by select/un-select each check boxes. 
4. All strings which are equal will be shown in the same line of the list.