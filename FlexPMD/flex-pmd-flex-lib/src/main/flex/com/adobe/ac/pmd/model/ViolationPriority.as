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
package com.adobe.ac.pmd.model
{
   import flash.events.Event;
   import flash.events.EventDispatcher;

   public class ViolationPriority extends EventDispatcher
   {
      public static const ERROR : ViolationPriority = new ViolationPriority( 1, "Error" );
      public static const WARNING : ViolationPriority = new ViolationPriority( 3, "Warning" );
      public static const INFO : ViolationPriority = new ViolationPriority( 5, "Info" );

      private var _level : int;
      private var _name : String;

      public function ViolationPriority( level : int, name : String )
      {
         _level = level;
         _name = name;
      }

      public static function create( level : int ) : ViolationPriority
      {
         var result : ViolationPriority = null;
		 
         switch( level )
         {
            case 1:
				result = ERROR;
				break;
            case 3:
				result = WARNING;
				break;
            case 5:
				result = INFO;
				break;
            default:
               throw new Error( "Unknown violation level (" + level + ")" );
         }
		 return result;
      }

      public static function get values() : Array
      {
         return[ ERROR, WARNING, INFO ];
      }

      [Bindable( "unused" )]
      public function get level() : int
      {
         return _level;
      }

      [Bindable( "initialized" )]
      public function get name() : String
      {
         return _name;
      }

      override public function toString() : String
      {
         return _name;
      }
   }
}
