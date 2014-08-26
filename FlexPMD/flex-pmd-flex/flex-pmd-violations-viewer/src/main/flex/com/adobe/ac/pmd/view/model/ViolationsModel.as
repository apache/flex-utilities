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
	import com.adobe.ac.pmd.model.Violation;
	
	import mx.collections.ArrayCollection;
	
	public class ViolationsModel
	{
        private var _errors : int = 0;
        private var _warnings : int = 0;
        private var _informations : int = 0;
        private var _violations : ArrayCollection;
        
		public function ViolationsModel()
		{
		}
		
		public function get violations() : ArrayCollection
		{
			return _violations;
		}
		
		public function get errors() : int
		{
			return _errors;
		}
		
		public function get warnings() : int
		{
			return _warnings;
		}
		
		public function get informations() : int
		{
			return _informations;
		}

		public function set violations( value : ArrayCollection ) : void
        {
            _violations = value;
            _violations.filterFunction = ResultsFilter.filterViolation;

            for each ( var violation : Violation in _violations )
            {
                if ( violation.rule.priority.level == 1 )
                {
                    _errors++;
                }
                else if ( violation.rule.priority.level == 3 )
                {
                    _warnings++;
                }
                else if ( violation.rule.priority.level == 5 )
                {
                    _informations++;
                }
            }
            _violations.refresh();
        }
        
        public function filter() : void
        {
        	_violations.refresh();
        }
	}
}