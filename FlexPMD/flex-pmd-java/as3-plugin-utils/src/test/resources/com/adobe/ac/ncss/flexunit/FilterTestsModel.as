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
   import flash.events.EventDispatcher;
   
   import flexunit.flexui.data.filter.ITestFunctionStatus;
   import flexunit.flexui.event.TestRunnerBasePresentationModelProperyChangedEvent;
   
   import mx.collections.IList;

   [Event( 
      name="filterChanged", 
      type="flash.events.Event")]
   
   public class FilterTestsModel extends EventDispatcher
   {
      public var filter : String;
      
      private var _selectedTestFunctionStatus : ITestFunctionStatus;

      public function searchFilterFunc( item : Object ) : Boolean
      {
         if ( item is TestCaseData )
         {
            var testClassSum : TestCaseData = item as TestCaseData;

            testClassSum.filterText = filter;
            testClassSum.selectedTestFunctionStatus = _selectedTestFunctionStatus;
            testClassSum.refresh();

            var testCaseChildren : IList = testClassSum.children;

            if ( testCaseChildren && testCaseChildren.length > 0 )
            {
               return true;
            }
         }

         return false;
      }
      
      public function set selectedTestFunctionStatus( value : ITestFunctionStatus ) : void
      {
         _selectedTestFunctionStatus = value;
         
         dispatchEvent(
               new TestRunnerBasePresentationModelProperyChangedEvent( 
                     TestRunnerBasePresentationModelProperyChangedEvent.FILTER_CHANGED, 
                     true ) );
      }

      public function get selectedTestFunctionStatus() : ITestFunctionStatus
      {
         return _selectedTestFunctionStatus;
      }
   }
}