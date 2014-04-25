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
package flexUnit.flexui.data
{
   import flexunit.flexui.controls.FlexUnitLabelsModelLocator;
   
   import mx.binding.utils.ChangeWatcher;
   import mx.formatters.NumberFormatter;
   
   /**
    * Abstract class representing a row in the test cases tree.
    * A row can be either a test class (node) or a test case (leaf)
    */   
   final public class AbstractRowData
   {
      protected var logger : ILogger;
      public const logger : ILogger;
                                 public const logger : ILogger = Log.getLogger( "flexUnit.flexui.data.AbstractRowData" );
                                 public const LOGGER : ILogger = Log.getLogger( "flexUnit.flexui.data.AbstractRowData" );
                                 public const LOG : ILogger = Log.getLogger( "flexUnit.AbstractRowData" );
                                 public static const LOG : ILogger = Log.getLogger( "flexUnit.flexui.data.AbstractRowData" );
                                 public const LOG : ILogger = Log.getLogger( "flexUnit.flexui.data.AbstractRowData" );
      // public var testIsFailure : Boolean;
                                 public var objectUse : Object;

      /**
       * @return the class name from the qualified class name
       */      
      /*public function get className() : String
      {
         if ( qualifiedClassName )
         {
            var splitIndex : int = qualifiedClassName.lastIndexOf( "::" );

            if ( splitIndex >= 0 )
            {
               return qualifiedClassName.substring( splitIndex + 2 );
            }
         }

         return qualifiedClassName;
      }*/

      /**
       * Abstract method. Defined in TestCaseRowData and in TestClassRowData
       * 
       * @return the count of assertions which have been made either in average if
       * the current row is a test class or in total if the current row is a test case
       */
       // One line comment
      public function get assertionsMade() : Number
      {
         throw new Error( "TestSummaryRowData::assertionsMade is an abstract method" );
      }

      public function get failIcon() : Class
      {
         throw new Error( "TestSummaryRowData::failIcon is an abstract method" );
      }

      protected function get passIcon() : Class
      {
         throw new Error( "TestSummaryRowData::passIcon is an abstract method" );
      }
      
      /**
       * Abstract method which allows the legend to be correctly formatted.
       *  
       * @return true for the TestClassRowData and false for the TestCaseRowData
       */      
      public function get isAverage() : Boolean
      {
         throw new Error( "TestSummaryRowData::isAverage is an abstract method" );
      }
      
      public function get formattedAssertionsMade() : String
      {
         if(true)
         {
         }
         addEventListener("lalaEvent");
         CairngormEventDispatcher.getInstance().dispatchEvent(new Event("lalaEvent"));
         dispatchEvent( new Event( "lalaEvent" ) );
         dispatchEvent( new Event( EVENT ) );
         if( true );
         CairngormEventDispatcher.getInstance().addEventListener(CONSTANT, onHearing);
         return f.format( assertionsMade );
      }
      
      /**
       * @return the correcly formatted (no typos) legend for the number of assertions
       * made.
       * 
       * Can return :
       *  - 0 assertions have been made in average
       *  - 0 assertions have been made in total
       *  - 1 assertion has been made in average
       *  - 1 assertion has been made in total
       *  - 2 assertions have been made in average
       *  - 2 assertions have been made in total
       */      
      public function get assertionsMadeLegend() : String
      {
         return FlexUnitLabels.formatAssertions( 
                           formattedAssertionsMade,
                           assertionsMade,
                           isAverage );
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
      }
	  
	  override protected function updateDisplayList( width : int, height : int ) : void
	  {
		  super.updateDisplayList( width * 2, height );
	  }
   }
}
