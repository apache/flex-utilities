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
   import flexunit.framework.EventfulTestCase;

   public class RuleTest extends EventfulTestCase
   {
      private var rule : Rule;
      
      public function RuleTest()
      {
      }

      override public function setUp():void
      {
         rule = new Rule();
      }
      
      public function testName() : void
      {
         listenForEvent( rule, Rule.NAME_CHANGE );
         
         rule.name = "com.adobe.ac.MyRule";
         
         assertEvents();
         assertEquals( "MyRule", rule.shortName );
         
         rule.name = "MyRule";
         assertEquals( "MyRule", rule.shortName );         
      }
      
      public function testRemove() : void
      {
         var parentRuleset : Ruleset = new Ruleset();
         
         rule.ruleset = parentRuleset;
         parentRuleset.rules.addItem( rule );
         rule.remove();
         
		 assertEquals( 1, parentRuleset.rules.length );
		 assertTrue( Rule( parentRuleset.rules.getItemAt( 0 ) ).deleted );
      }
   }
}