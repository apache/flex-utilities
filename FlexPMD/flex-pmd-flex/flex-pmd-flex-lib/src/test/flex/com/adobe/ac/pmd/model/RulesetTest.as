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
   import com.adobe.ac.pmd.control.events.GetRulesetContentEvent;
   import com.adobe.ac.pmd.model.events.RulesetReceivedEvent;
   
   import flexunit.framework.CairngormEventSource;
   import flexunit.framework.EventfulTestCase;
   
   import mx.collections.ArrayCollection;

   public class RulesetTest extends EventfulTestCase
   {
      private var model : Ruleset;
      
      public function RulesetTest()
      {
      }

      override public function setUp():void
      {
         model = new Ruleset();
      }
      
      public function testGetRulesetContent() : void
      {
         listenForEvent( CairngormEventSource.instance, GetRulesetContentEvent.EVENT_NAME );
         
         model.getRulesetContent( "ref" );
         
         assertEvents();
         assertEquals( model, GetRulesetContentEvent( lastDispatchedExpectedEvent ).invoker );
         assertEquals( "ref", GetRulesetContentEvent( lastDispatchedExpectedEvent ).ref );
      }
      
      public function testOnReceiveRulesetContent() : void
      {
         var receivedRuleset : Ruleset = new Ruleset();
         
         listenForEvent( model, RulesetReceivedEvent.EVENT_NAME );
         
         receivedRuleset.name = "name";
         receivedRuleset.description = "description";
         receivedRuleset.rules = new ArrayCollection();
         
         model.onReceiveRulesetContent( receivedRuleset );
         
         assertEvents();
         assertEquals( model, RulesetReceivedEvent( lastDispatchedExpectedEvent ).ruleset );
         assertEquals( receivedRuleset.name, model.name );
         assertEquals( receivedRuleset.description, model.description );
         assertEquals( receivedRuleset.rules, model.rules );
      }
   }
}