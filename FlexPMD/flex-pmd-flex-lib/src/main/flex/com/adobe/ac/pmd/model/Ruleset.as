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
    import com.adobe.ac.pmd.api.IGetRulesetContent;
    import com.adobe.ac.pmd.control.events.GetRulesetContentEvent;
    import com.adobe.ac.pmd.model.events.RulesetReceivedEvent;

    import flash.events.EventDispatcher;

    import mx.collections.ArrayCollection;
    import mx.collections.ListCollectionView;
    import mx.events.CollectionEvent;

    [Event( name="rulesetReceived",type="com.adobe.ac.pmd.model.events.RulesetReceivedEvent" )]
    public class Ruleset extends EventDispatcher implements IDomainModel, IGetRulesetContent // NO PMD BindableClass
    {
        private static const RULES_CHANGED : String = "rulesChange";
		[Bindable]
        public var isRef : Boolean;
		[Bindable]
        public var name : String;
		[Bindable]
        public var description : String;
		[Bindable]
        public var rules : ListCollectionView = new ArrayCollection();

        public function Ruleset()
        {
        }

        public function getRulesetContent( ref : String ) : void
        {
            new GetRulesetContentEvent( this, ref ).dispatch();
        }

        public function onReceiveRulesetContent( ruleset : Ruleset ) : void
        {
            name = ruleset.name;
            rules = ruleset.rules;
            isRef = ruleset.isRef;
            description = ruleset.description;
            dispatchEvent( new RulesetReceivedEvent( this ) );
        }
    }
}