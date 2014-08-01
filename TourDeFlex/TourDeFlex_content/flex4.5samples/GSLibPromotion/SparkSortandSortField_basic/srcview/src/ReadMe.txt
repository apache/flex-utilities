Sample Name ---- Spark Sort and Spark SortField

Introduction:
Spark Sort provides the sorting information required to establish a sort on an existing view (ICollectionView interface or class that implements the interface). After you assign a Sort instance to the view's sort property, you must call the view's refresh() method to apply the sort criteria. 

Spark SortField provides the sorting information required to establish a sort on a field or property in a collection view. SortField class is meant to be used with Sort class.

Usage of the sample code:
1. Select a Locale from the locale comboBox first. It will use en_US as the default choice.
2. Click the button to sort the strings in the list.
