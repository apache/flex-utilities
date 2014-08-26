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
    import com.adobe.ac.pmd.model.ViolationPriority;
    
    import mx.collections.GroupingField;

    public final class ResultsFilter
    {
        public static const VIOLATION_PRIORITIES : Array = [ 
        				{ name: "All", level: 0 }, 
        				ViolationPriority.ERROR, 
        				ViolationPriority.WARNING,
            			ViolationPriority.INFO ];
    	public static const FILE_PATH_GROUPFIELD : GroupingField = new GroupingField( "shortPath" );
    	public static const RULENAME_GROUPFIELD : GroupingField = new GroupingField( "shortRuleName" );

		[ArrayElementType("mx.collections.GroupingField")]
    	public static const GROUPING_FIELDS : Array = [ FILE_PATH_GROUPFIELD, RULENAME_GROUPFIELD ];

        public static var currentPriorityVisible : int = 1; // NO PMD AvoidUsingPublicStaticField

        public static function filterViolation( value : Object ) : Boolean // NO PMD
        {
            if ( currentPriorityVisible == 0 )
            {
                return true;
            }
            return ( value as Violation ).rule.priority.level == currentPriorityVisible;
        }
    }
}