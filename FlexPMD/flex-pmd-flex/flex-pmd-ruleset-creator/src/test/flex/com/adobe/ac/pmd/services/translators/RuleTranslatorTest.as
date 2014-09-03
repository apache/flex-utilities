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
package com.adobe.ac.pmd.services.translators
{
	import com.adobe.ac.pmd.model.Rule;
	
	import flexunit.framework.EventfulTestCase;

	public class RuleTranslatorTest extends EventfulTestCase
	{
		public function testSerialize() : void
		{
			var rule : Rule = new Rule();
			
			rule.name = "ruleName";
			
			var xml : XML = RuleTranslator.serialize( rule );
			
			assertEquals( <rule since="null" class="ruleName" message="null"><description/><priority>3</priority></rule>, xml );

			rule.since = "0.9";
			rule.message = "";
			xml = RuleTranslator.serialize( rule );

			assertEquals( <rule since="0.9" class="ruleName" message=""><description/><priority>3</priority></rule>, xml );
		}
		
		public function testDeserialize() : void
		{
			var xml : XML = <rule since="0.9" class="ruleName" message=""><description/><priority>3</priority></rule>;
			var rule : Rule = RuleTranslator.deserialize( xml );
			var expectedRule : Rule = new Rule();
			
			expectedRule.name = "ruleName";
			expectedRule.since = "0.9"; 
			expectedRule.message = "";

			assertEquals( expectedRule.name, rule.name );
			assertEquals( expectedRule.since, rule.since );
			assertEquals( expectedRule.message, rule.message );
		}
	}
}