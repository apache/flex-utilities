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
package com.adobe.ac.pmd.control.events
{
   import com.adobe.ac.pmd.api.IGetCustomRuleset;
   import com.adobe.cairngorm.control.CairngormEvent;
   
   import flash.events.Event;

   public class GetCustomRulesetEvent extends CairngormEvent
   {
      public static const EVENT_NAME : String = "ruleset.getRoot";

      private var _invoker : IGetCustomRuleset;

      public function GetCustomRulesetEvent( invoker : IGetCustomRuleset )
      {
         super( EVENT_NAME );
         _invoker = invoker;
      }

      public function get invoker() : IGetCustomRuleset
      {
         return _invoker;
      }

      override public function clone() : Event
      {
         return new GetCustomRulesetEvent( _invoker );
      }
   }
}