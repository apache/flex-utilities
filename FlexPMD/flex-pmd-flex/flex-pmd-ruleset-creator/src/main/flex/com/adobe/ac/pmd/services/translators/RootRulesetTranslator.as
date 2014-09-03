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
	import com.adobe.ac.pmd.model.RootRuleset;
	import com.adobe.ac.pmd.model.Rule;
	import com.adobe.ac.pmd.model.Ruleset;
	
	import mx.collections.ArrayCollection;

	public class RootRulesetTranslator
	{
		public static function deserialize( xml : XML ) : RootRuleset
		{
			var ruleset : RootRuleset = new RootRuleset();
			var children : XMLList = xml.children();
			
			ruleset.name = xml.@name;
			
			for( var i : int = 1; i < children.length(); i++ )
			{
				var ruleXml : XML = children[ i ];
				
				if( ruleXml.@ref != undefined )
				{
					var childRuleset : Ruleset = new Ruleset(); // NO PMD AvoidInstanciationInLoop
					
					childRuleset.isRef = true;
					childRuleset.getRulesetContent( ruleXml.@ref );
					ruleset.rulesets.addItem( childRuleset );
				}
				else
				{
					if ( ! ruleset.rulesets )
					{
						ruleset.rulesets = new ArrayCollection();
					}
					var nestingRuleset : Ruleset;
					if ( ruleset.rulesets.length == 0 )
					{
						nestingRuleset = new Ruleset(); // NO PMD AvoidInstanciationInLoop
						
						nestingRuleset.name = "Custom ruleset";
						ruleset.rulesets.addItem( nestingRuleset );
					}
					else
					{
						nestingRuleset = Ruleset( ruleset.rulesets.getItemAt( 0 ) );
					}
					var newRule : Rule = RuleTranslator.deserialize( ruleXml );

					newRule.ruleset = nestingRuleset;
					nestingRuleset.rules.addItem( newRule );
				}
			}
			
			return ruleset;			
		}

		public static function serializeRootRuleset( ruleset : RootRuleset ) : XML
		{
			var xmlString : String = "<ruleset name=\"" + ruleset.name + "\"" + 
				"xmlns=\"http://pmd.sf.net/ruleset/1.0.0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"" +
				"xsi:schemaLocation=\"http://pmd.sf.net/ruleset/1.0.0 http://pmd.sf.net/ruleset_xml_schema.xsd\"" +
				"xsi:noNamespaceSchemaLocation=\"http://pmd.sf.net/ruleset_xml_schema.xsd\">" +
				"<description>" + ( ruleset.description ? ruleset.description : "" ) + "</description>";
			
			for each( var childRuleset : Ruleset in ruleset.rulesets )
			{
				xmlString += serializeRuleset( childRuleset ).toXMLString();
			}
			xmlString += "</ruleset>";
			
			return XML( xmlString );
		}
		
		private static function serializeRuleset( ruleset : Ruleset ) : XMLList
		{
			var xmlString : String = "";
			
			for each( var rule : Rule in ruleset.rules )
			{
				if ( !rule.deleted )
				{
					xmlString += RuleTranslator.serialize( rule ).toXMLString();
				}
			}
			
			return new XMLList( xmlString );
		}}
}