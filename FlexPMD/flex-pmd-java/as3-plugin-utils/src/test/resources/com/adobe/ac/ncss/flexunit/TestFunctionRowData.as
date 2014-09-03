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
   import flexunit.flexui.patterns.*;
   import flexunit.framework.TestCase;
   
   import mx.formatters.NumberFormatter;

   public class TestFunctionRowData extends AbstractRowData
   {
      public static const EMPTY_STRING : String = "-";

      private const patterns : Array =
          [
             new AssertNotContainedPattern(),
             new AssertNoMatchPattern(),
             new AssertMatchPattern(),
             new AssertContainedPattern(),
             new AssertEventOcurredPattern(),
             new AssertEqualsPattern(),
             new AssertNotNullPattern(),
             new AssertNotUndefinedPattern(),
             new AssertNullPattern(),
             new AssertUndefinedPattern(),
             new FailAsyncCallPattern()
          ];

      public var testCase : TestCase;
      public var testMethodName : String;
      public var parentTestCaseSummary : TestCaseData;
      public var expectedResult : String;
      public var actualResult : String;

      private var _errorMessage : String;
      private var _stackTrace : String;
      private var _error : Error;
      private var _location : String;
      private var _line : Number;

      [Embed(source="/assets/pass_mini.png")]
      private static var passImgMini : Class;

      [Embed(source="/assets/fail_mini.png")]
      private static var failImgMini : Class;

      override public function get failIcon() : Class
      {
         return failImgMini;
      }

      override public function get passIcon() : Class
      {
         return passImgMini;
      }
      
      override public function get assertionsMade() : Number
      {
         return testCase.assertionsMade;
      }

      override public function get formattedAssertionsMade() : String
      {
         var f : NumberFormatter = new NumberFormatter();
         
         f.precision = 0;
         f.rounding = "nearest";
         
         return f.format( assertionsMade );
      }
      
      override public function get isAverage() : Boolean
      {
         return false;
      }

      public function set error( value : Error ) : void
      {
         _error = value;

         _errorMessage = error ? error.message : EMPTY_STRING;
         expectedResult = EMPTY_STRING;
         actualResult = EMPTY_STRING;

         if ( error != null && error.getStackTrace() )
         {
            _stackTrace = formatStack( value.getStackTrace().replace( "<", "&lt;" ).replace( ">", "&gt;" ) );

            for ( var i : int = 0 ; i < patterns.length; i++ )
            {
               var pattern : AbstractPattern = AbstractPattern( patterns[ i ] );

               if( pattern.match( error.message ) )
               {
                  pattern.apply( this );
                  break;
               }
            }
         }
      }

      public function get error() : Error
      {
         return _error;
      }

      public function get errorMessage() : String
      {
         return _errorMessage;
      }

      public function get location() : String
      {
         if( _location )
         {
            return _location + " (l." + _line + ")";
         }
         return EMPTY_STRING;
      }

      public function get stackTrace() : String
      {
         return _stackTrace;
      }
      
      public function get stackTraceToolTip() : String
      {
         if ( _stackTrace == null )
            return null;
            
         var regexp : RegExp = /\(\)\[.*\\.*\:(\d*)\]/gm;
         var array : Array = _stackTrace.split( "<br/>" );
         var stackTraceToolTip : String = "";
         
         for ( var i : int = 0; i < array.length; i++ )
         {
            stackTraceToolTip += array[ i ].toString().replace( regexp, "() at l.$1" ) + "<br/>";
         }
         return stackTraceToolTip;
      }
      
      public function isVisibleOnFilterText( filter : String ) : Boolean
      {
         return testMethodName.toLowerCase().indexOf( filter ) > -1 ||
                actualResult.toLowerCase().indexOf( filter ) > -1 ||
                expectedResult.toLowerCase().indexOf( filter ) > -1
      }

      private function extractLocation( line : String ) : Boolean
      {

         var location : RegExp = /(.*):(\d+)\]$/
         var splittedLine : Array = line.split( "\\" );
         var results : Array = location.exec( splittedLine[ splittedLine.length - 1 ] ) as Array;

         if( results && results.length == 3 )
         {
            _location = results[ 1 ];
            _line = results [ 2 ];

            return true;
         }

        return false;
      }

      private function formatStack( stackTrace : String ) : String
      {
         var replaceNewLine : RegExp = /\n/mg;
         var html : String = stackTrace.replace( replaceNewLine, "<br/>" );
         var formattedStack : String = "";
         var isFirst : Boolean = true;

         for ( var i : int = 1; i < html.split( "<br/>" ).length; i++ )
         {
            var currentLine : String = html.split( "<br/>" )[ i ];
            var matchingFlexunit : RegExp = /(at flexunit.*)$/g;
            var matchingFlash : RegExp = /(at flash.*)$/g;
            var matchingFlex : RegExp = /(at mx.*)$/g;
            var matchingFunction : RegExp = /at Function\/http:\/\/adobe\.com\/AS3\//

            if( ! matchingFlex.test( currentLine ) &&
                ! matchingFlexunit.test( currentLine ) &&
                ! matchingFlash.test( currentLine ) &&
                ! matchingFunction.test( currentLine ) )
            {
               if( isFirst && extractLocation( currentLine ) )
               {
                  isFirst = false;
               }
               formattedStack += "<b>" + currentLine + "</b><br/>";
            }
            else
            {
               formattedStack += currentLine + "<br/>";
            }
         }
         return formattedStack;
      }
   }
}
