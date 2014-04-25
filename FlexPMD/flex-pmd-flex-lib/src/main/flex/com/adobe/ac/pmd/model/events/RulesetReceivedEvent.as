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
package com.adobe.ac.pmd.model.events
{
   import com.adobe.ac.pmd.model.Ruleset;

   import flash.events.Event;

   public class RulesetReceivedEvent extends Event
   {
      public static const EVENT_NAME : String = "rulesetReceived";

      private var _ruleset : Ruleset;

      public function RulesetReceivedEvent( ruleset : Ruleset )
      {
         super( EVENT_NAME );

         _ruleset = ruleset;
      }

      public function get ruleset() : Ruleset
      {
         return _ruleset;
      }

      override public function clone() : Event
      {
         return new RulesetReceivedEvent( ruleset );
      }
   }
}