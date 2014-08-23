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
	import com.adobe.ac.model.IDomainModel;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ListCollectionView;
	import mx.events.CollectionEvent;

	public class RootRuleset  extends EventDispatcher implements IDomainModel
	{
		public static const CUSTOM_RULESET_NAME : String = "Parameterized rules";
		private static const RULES_CHANGED : String = "rulesChange";
		public var name : String;
		public var description : String;
		[Bindable]
		public var rulesets : ListCollectionView = new ArrayCollection();
		
		private var _customRuleset : Ruleset = null;
		
		public function RootRuleset()
		{
			rulesets.addEventListener(CollectionEvent.COLLECTION_CHANGE, handleRulesetChange);
		}
		

		public function get customRuleset():Ruleset
		{
			return _customRuleset;
		}

		public function addRegExpBasedRule( rule : Rule ) : void
		{
			if ( ! customRuleset )
			{
				_customRuleset = new Ruleset();
				_customRuleset.name = CUSTOM_RULESET_NAME;
				rulesets.addItem( _customRuleset );
			}
			
			rule.ruleset = _customRuleset;
			_customRuleset.rules.addItem( rule );
			rulesChanged();
		}
		
		private function handleRulesetChange( event : CollectionEvent ) : void
		{
			for each ( var ruleset : Ruleset in rulesets )
			{
				ruleset.rules.addEventListener(CollectionEvent.COLLECTION_CHANGE, handleRulesChange);
			}
		}
		
		private function handleRulesChange( event : CollectionEvent ) : void
		{
			rulesChanged();
		}
		
		public function rulesChanged() : void
		{
			dispatchEvent( new Event( RULES_CHANGED ) );			
		}
		
		[Bindable("rulesChange")]
		public function get rulesNb() : Number
		{
			var result : Number = 0;
			
			for each ( var ruleset : Ruleset in rulesets )
			{
				for each ( var rule : Rule in ruleset.rules )
				{
					if ( !rule.deleted )
					{
						result++;
					}
				}
			}
			
			return result;
		}
	}
}