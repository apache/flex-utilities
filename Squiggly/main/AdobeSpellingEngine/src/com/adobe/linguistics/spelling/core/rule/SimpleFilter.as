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


package com.adobe.linguistics.spelling.core.rule
{
	public class SimpleFilter
	{
		private var _matchString:String;
		private var _replacementString:String;
		public function SimpleFilter(matchingString:String, replacementString:String)
		{
			this.matchString = matchingString;
			this.replacement = replacementString;
		}
		
		public function set matchString(value:String) :void {
			this._matchString = value;
		}
		public function get matchString():String {
			return this._matchString;
		}
		
		public function set replacement(value:String) :void {
			this._replacementString = value;
		}
		public function get replacement() :String {
			return this._replacementString;
		}

	}
}