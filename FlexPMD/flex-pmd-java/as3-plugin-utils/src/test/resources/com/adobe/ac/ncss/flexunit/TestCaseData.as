////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package flexunit.flexui.data
{
   import flexunit.flexui.data.filter.ITestFunctionStatus;
   import flexunit.flexui.data.filter.TestfFunctionStatuses;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.collections.ListCollectionView;

   public class TestCaseData extends AbstractRowData
   {
      public var testFunctions : IList = new ArrayCollection();
      public var filterText : String;
      public var selectedTestFunctionStatus : ITestFunctionStatus = TestfFunctionStatuses.ALL;
      
      [Embed(source="/assets/pass_small.png")]
      private static var passImg : Class;

      [Embed(source="/assets/fail_small.png")]
      private static var failImg : Class;

      private var _testsNumber : int;
      private var _testsPassedNumber : int;

      public function TestCaseData( testFunction : TestFunctionRowData )
      {
         label = testFunction.className;
         qualifiedClassName = testFunction.qualifiedClassName;
         testFunctions = new ArrayCollection();
         testSuccessful = true;
         _testsNumber = 0;
         _testsPassedNumber = 0;
      }

      public function get children() : IList
      {
         return testFunctions;
      }

      override public function get failIcon() : Class
      {
         return failImg;
      }

      override public function get passIcon() : Class
      {
         return passImg;
      }
      
      override public function get isAverage() : Boolean
      {
         return true;
      }

      public function get testsNumber() : int
      {
         return _testsNumber;
      }

      public function get passedTestsNumber() : int
      {
         return _testsPassedNumber;
      }
      
      override public function get assertionsMade() : Number
      {
         var currentAssertionsMade : Number = 0;
         
         for each ( var test : TestFunctionRowData in testFunctions )
         {
            currentAssertionsMade += test.assertionsMade;
         }
         
         if ( testFunctions.length > 0 )
         {
            return currentAssertionsMade / testFunctions.length;
         }
         return 0;
      }
      
      public function addTest( testFunctionToAdd : TestFunctionRowData ) : void
      {
         testFunctionToAdd.parentTestCaseSummary = this;
         if ( ! testFunctionToAdd.testSuccessful )
         {
            testSuccessful = false;
         }
         else
         {
            _testsPassedNumber++;
         }
         _testsNumber++;
         testFunctions.addItem( testFunctionToAdd );
      }

      public function refresh() : void
      {
         var filteredChildren : ListCollectionView = testFunctions as ListCollectionView;
         if ( filteredChildren )
         {
            filteredChildren.filterFunction = searchFilterFunc;
            filteredChildren.refresh();
         }
      }

      private function searchFilterFunc( item : Object ) : Boolean
      {
         var testFunction : TestFunctionRowData = item as TestFunctionRowData;
         if ( ( className && className.toLowerCase().indexOf( filterText.toLowerCase() ) != - 1 ) ||
              filterText == null ||
              filterText == "" ||
              testFunction.isVisibleOnFilterText( filterText.toLowerCase() ) )
         {
            if ( selectedTestFunctionStatus.isTestFunctionVisible( testFunction ) )
               return true;
         }

         return false;
      }
   }
}
