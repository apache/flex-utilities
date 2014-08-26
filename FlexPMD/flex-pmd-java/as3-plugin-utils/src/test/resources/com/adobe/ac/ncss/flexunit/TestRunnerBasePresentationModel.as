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
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   
   import flexunit.flexui.event.TestRunnerBasePresentationModelProperyChangedEvent;
   import flexunit.framework.TestCase;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.collections.ListCollectionView;

   [Event( name="rowSelectedChanged",          type="flash.events.Event")]
   [Event( name="testSuiteRunDurationChanged", type="flash.events.Event")]
   [Event( name="totalErrorsChanged",          type="flash.events.Event")]
   [Event( name="totalFailuresChanged",        type="flash.events.Event")]
   [Event( name="progressChanged",             type="flash.events.Event")]
   [Event( name="filterChanged",               type="flash.events.Event")]
   [Event( name="filterEnableChanged",         type="flash.events.Event")]

   public class TestRunnerBasePresentationModel extends EventDispatcher
   {
      public var totalTests : int;
      public var filterModel : FilterTestsModel = new FilterTestsModel();
      private var _rowSelected : AbstractRowData;

      private var _totalErrors : int;
      private var _totalFailures : int;
      private var _numTestsRun : int;

      private var _testSuiteStartTime : int;
      private var _testSuiteEndTime : int;


      private var _allTestsTreeCollection : ListCollectionView;
      private var _errorTestsTreeCollection : ListCollectionView;
      private var _testClassMap : Object = new Object();
      private var _errorTestClassMap : Object = new Object();
      private var _filterSectionEnabled : Boolean = false;
      private var _testsRunning : Boolean;
      private var errorHasBeenFound : Boolean = false;
      
      public function TestRunnerBasePresentationModel()
      {
         filterModel.addEventListener( 
            TestRunnerBasePresentationModelProperyChangedEvent.FILTER_CHANGED,
            handleFilterChanged )
      }
      
      public function get dataProvider() : ListCollectionView
      {
         if( _testsRunning )
         {
            return _errorTestsTreeCollection;
         }
         else
         {
            return _allTestsTreeCollection;
         }
      }
      
      public function get testsRunning() : Boolean
      {
         return _testsRunning;
      }

      public function set filterSectionEnabled( value : Boolean ) : void
      {
         _filterSectionEnabled = value;

         dispatchPropertyChanged(
               TestRunnerBasePresentationModelProperyChangedEvent.FILTER_ENABLE_CHANGED );
      }

      public function get filterSectionEnabled() : Boolean
      {
         return _filterSectionEnabled;
      }

      public function set numTestsRun( value : int ) : void
      {
         _numTestsRun = value;

         dispatchPropertyChanged(
               TestRunnerBasePresentationModelProperyChangedEvent.PROGRESS_CHANGED );
      }

      public function get numTestsRun() : int
      {
         return _numTestsRun;
      }

      public function get totalFailures() : int
      {
         return _totalFailures;
      }

      public function get totalErrors() : int
      {
         return _totalErrors;
      }

      public function get suiteDurationFormatted() : String
      {
         return ( ( _testSuiteEndTime - _testSuiteStartTime ) / 1000 ) + " seconds";
      }

      public function set rowSelected( value : AbstractRowData ) : void
      {
         _rowSelected = value;

         dispatchPropertyChanged(
               TestRunnerBasePresentationModelProperyChangedEvent.ROW_SELECTED_CHANGED );
      }

      public function get rowSelected() : AbstractRowData
      {
         return _rowSelected;
      }

      public function get testFunctionSelected() : TestFunctionRowData
      {
         return _rowSelected as TestFunctionRowData;
      }

      public function get testCaseSelected() : TestCaseData
      {
         return _rowSelected as TestCaseData;
      }

      public function addFailure() : void
      {
         _totalFailures++;

         dispatchPropertyChanged(
               TestRunnerBasePresentationModelProperyChangedEvent.TOTAL_FAILURES_CHANGED );
      }

      public function addError() : void
      {
         _totalErrors++;

         dispatchPropertyChanged(
               TestRunnerBasePresentationModelProperyChangedEvent.TOTAL_ERRORS_CHANGED );
      }

      public function launchTests() : void
      {
         _testsRunning = true;
         _testSuiteStartTime = getTimer();

         _allTestsTreeCollection = new ArrayCollection();
         _allTestsTreeCollection.filterFunction = filterModel.searchFilterFunc;
         
         _errorTestsTreeCollection = new ArrayCollection();         
      }

      public function endTimer() : void
      {
         _testsRunning = false;
         
         _testSuiteEndTime = getTimer();

         dispatchPropertyChanged(
               TestRunnerBasePresentationModelProperyChangedEvent.TOTAL_FAILURES_CHANGED );
         dispatchPropertyChanged(
               TestRunnerBasePresentationModelProperyChangedEvent.TEST_SUITE_RUN_DURATION_CHANGED );
         dispatchPropertyChanged(
               TestRunnerBasePresentationModelProperyChangedEvent.TOTAL_ERRORS_CHANGED );
      }

      public function addTestRowToHierarchicalList(
                  testCase : TestCase,
                  error : Error,
                  success : Boolean,
                  isFailure : Boolean ) : TestFunctionRowData
      {
         var rowToAdd : TestFunctionRowData = new TestFunctionRowData();
         var parentRow : TestCaseData;

         rowToAdd.label = testCase.methodName;
         rowToAdd.qualifiedClassName = testCase.className;
         rowToAdd.testSuccessful = success;
         rowToAdd.testIsFailure = isFailure;
         rowToAdd.testMethodName = testCase.methodName;
         rowToAdd.testCase = testCase;
         rowToAdd.error = error;
         

         parentRow = findTestCaseParentRowInAllTests( rowToAdd );

         if ( parentRow && parentRow.testFunctions as IList )
         {
            parentRow.addTest( rowToAdd );
         }

         if( ! success )
         {
            parentRow = findTestCaseParentRowInErrorTests( rowToAdd );
            
            if ( parentRow && parentRow.testFunctions as IList )
            {
               parentRow.addTest( rowToAdd );
            }
         }

         return rowToAdd;
      }

      private function findTestCaseParentRowInAllTests( 
               testFunction : TestFunctionRowData ) : TestCaseData
      {
         var testCaseParentRow : TestCaseData;

         // Check local _currentTestClassRow to see if it's the correct Test Class Summary object
         if ( testCaseSelected &&
              testCaseSelected.qualifiedClassName == testFunction.qualifiedClassName )
         {
            testCaseParentRow = testCaseSelected;
         }
         else if ( _testClassMap[ testFunction.qualifiedClassName ] != null )
         {
            // Lookup testClassName in object map
            testCaseParentRow = _testClassMap[ testFunction.qualifiedClassName ] as TestCaseData;
         }

         if ( ! errorHasBeenFound )
         {
            rowSelected = testFunction;
         }

         if ( testCaseParentRow )
         {
            return testCaseParentRow;
         }
         else
         {
            // Else create a new row and add it to the list
            testCaseParentRow = new TestCaseData( testFunction );
            
            // Mark _currentTestClassRow and add the new testClassName to object map

            _testClassMap[ testFunction.qualifiedClassName ] = testCaseParentRow;

            _allTestsTreeCollection.addItem( testCaseParentRow );
         }

         return testCaseParentRow;
      }

      private function findTestCaseParentRowInErrorTests( 
               testFunction : TestFunctionRowData ) : TestCaseData
      {
         var testCaseParentRow : TestCaseData;

         if ( _errorTestClassMap[ testFunction.qualifiedClassName ] != null )
         {
            // Lookup testClassName in object map
            testCaseParentRow = _errorTestClassMap[ testFunction.qualifiedClassName ] as TestCaseData;
         }

         if ( testCaseParentRow )
         {
            return testCaseParentRow;
         }
         else
         {
            // Else create a new row and add it to the list
            testCaseParentRow = new TestCaseData( testFunction );

            // Mark _currentTestClassRow and add the new testClassName to object map

            rowSelected = testFunction;
            
            errorHasBeenFound = true;

            _errorTestClassMap[ testFunction.qualifiedClassName ] = testCaseParentRow;

            _errorTestsTreeCollection.addItem( testCaseParentRow );
         }

         return testCaseParentRow;
      }
      
      private function handleFilterChanged( event : Event ) : void
      {
         dispatchEvent( event.clone() );
      }
      
      private function dispatchPropertyChanged( type : String ) : void
      {
         dispatchEvent(
               new TestRunnerBasePresentationModelProperyChangedEvent( type ) );
      }
   }
}
