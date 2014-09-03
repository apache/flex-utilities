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
package com.adobe.ac.pmd.view.model
{
    import com.adobe.ac.model.IPresentationModel;
    import com.adobe.ac.pmd.model.Violation;
    
    import flash.events.Event;
    import flash.events.EventDispatcher;
    
    import mx.collections.ArrayCollection;
    import mx.collections.Grouping;
    import mx.collections.GroupingField;

    [Event( name="currentVisibilityChange", type = "flash.events.Event" )]
    public class ResultsModel extends EventDispatcher implements IPresentationModel
    {
        private static const CURRENT_VISIBILITY_CHANGE : String = "currentVisibilityChange";
        private static const VIOLATIONS_COMPUTED : String = "violationsComputed";
        private static const SELECTED_GROUP_FIELDS_CHANGE : String = 'selectedGroupFieldsChange';

        private var _grouping : Grouping;
        private var _violations : ViolationsModel
        
        [Bindable]
        public var selectedViolation : Violation;
        
        public function ResultsModel()
        {
        	_violations = new ViolationsModel();
        	_grouping = new Grouping();
        	selectedGroupFields = [ 1 ];
        }
        
        public function filter() : void
        {
        	_violations.filter();
            dispatchEvent( new Event( CURRENT_VISIBILITY_CHANGE ) )
        }
        
        public function set selectedGroupFields( value : Array ) : void
        {
        	_grouping.fields = [];
        	for each ( var indice : Number in value )
        	{
        		_grouping.fields.push( ResultsFilter.GROUPING_FIELDS[ indice ] );
        	}
        	
        	dispatchEvent( new Event( SELECTED_GROUP_FIELDS_CHANGE ) );
        }
        
        [Bindable('selectedGroupFieldsChange')]
        public function get selectedGoupFieldIndices() : Array
        {
        	var indices : Array = [];
        	var currentIndexInPossibleFields : int;
        	
        	for each ( var selectedField : GroupingField in _grouping.fields )
        	{
        		currentIndexInPossibleFields = 0;
        		for each ( var possibleField : GroupingField in ResultsFilter.GROUPING_FIELDS )
        		{
        			if ( selectedField == possibleField )
        			{
        				indices.push( currentIndexInPossibleFields );
        				break;
        			}
        			currentIndexInPossibleFields++;
        		}
        	}
        	return indices;
        }
        
        [Bindable("unused")]
        public function get grouping() : Grouping
        {
        	return _grouping;
        }

        public function set currentPriorityVisible( value : int ) : void
        {
            ResultsFilter.currentPriorityVisible = value;
        }

        public function set violations( value : ArrayCollection ) : void
        {
            _violations.violations = value;

            dispatchEvent( new Event( VIOLATIONS_COMPUTED ) );
        }

        [Bindable( "violationsComputed" )]
        public function get errors() : int
        {
            return _violations.errors;
        }

        [Bindable( "violationsComputed" )]
        public function get warnings() : int
        {
            return _violations.warnings;
        }

        [Bindable( "violationsComputed" )]
        public function get informations() : int
        {
            return _violations.informations;
        }

        [Bindable( "violationsComputed" )]
        public function get violationsNumber() : int
        {
            return _violations.violations.source.length;
        }

        [Bindable( "violationsComputed" )]
        public function get violations() : ArrayCollection
        {
            return _violations.violations;
        }
    }
}