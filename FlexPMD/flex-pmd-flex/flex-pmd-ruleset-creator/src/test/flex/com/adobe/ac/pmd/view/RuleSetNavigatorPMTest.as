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
 package com.adobe.ac.pmd.view
{
   import com.adobe.ac.pmd.control.events.GetRootRulesetEvent;
   import com.adobe.ac.pmd.model.RootRuleset;
   import com.adobe.ac.pmd.model.Ruleset;
   import com.adobe.ac.pmd.model.events.RulesetReceivedEvent;

   import flexunit.framework.CairngormEventSource;
   import flexunit.framework.EventfulTestCase;

   import mx.collections.ArrayCollection;

   public class RuleSetNavigatorPMTest extends EventfulTestCase
   {
      private var model : RuleSetNavigatorPM;
      
      public function RuleSetNavigatorPMTest()
      {
      }

      override public function setUp() : void
      {
         model = new RuleSetNavigatorPM();
      }

      public function testGetRootRuleset() : void
      {
         listenForEvent( CairngormEventSource.instance, GetRootRulesetEvent.EVENT_NAME );

         model.getRootRuleset();

         assertEvents();
      }

      public function testOnReceiveRootRuleset() : void
      {
         var emptyRootRuleset : RootRuleset = new RootRuleset();

         listenForEvent( model, RuleSetNavigatorPM.ROOT_RULESET_RECEIVED );

         model.onReceiveRootRuleset( emptyRootRuleset );

         assertEvents();
         assertEquals( emptyRootRuleset, model.rootRuleset );

         var rootRuleset : RootRuleset = new RootRuleset();

         rootRuleset.rulesets = new ArrayCollection();
         rootRuleset.rulesets.addItem( new Ruleset() );
         rootRuleset.rulesets.addItem( new Ruleset() );

         model.onReceiveRootRuleset( rootRuleset );

         assertEquals( rootRuleset, model.rootRuleset );

         for each( var childRuleset : Ruleset in rootRuleset.rulesets )
         {
            assertTrue( childRuleset.hasEventListener( RulesetReceivedEvent.EVENT_NAME ) );
         }
      }
   }
}