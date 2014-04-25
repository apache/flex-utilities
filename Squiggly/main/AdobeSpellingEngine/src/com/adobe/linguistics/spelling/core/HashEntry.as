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


package com.adobe.linguistics.spelling.core
{
	import com.adobe.linguistics.spelling.core.utils.StringUtils;
	public class HashEntry
	{
		private var _affStr:String; // affix flag vector
		private var _nextEntry:HashEntry;
		
		// Not sure now..just leave it here.
		private var _variableFields:String;   // variable fields (only for special pronounciation yet)
		
		
		public function HashEntry(affStr:String=null,desc:String = null)
		{
			this._affStr = StringUtils.sort(affStr);
			this._variableFields = desc;
			this._nextEntry = null;
		}
		
		public function addEntry(affStr:String=null,desc:String = null):Boolean {
			if ( this._nextEntry != null ) return false;
			this._nextEntry = new HashEntry(affStr, desc);
			return true;
		}
		
		public function get next():HashEntry {
			return this._nextEntry;
		}
		
		public function get affixFlagVector():String {
			return this._affStr;
		}
		
		public function set affixFlagVector(affStr:String):void {
			this._affStr = StringUtils.sort(affStr);
		}
		
		public function get variableFields():String {
			return this._variableFields;
		}
		
		public function set variableFields( varF:String) :void {
			this._variableFields = varF;
		}
		
		public function testAffix(flag:Number):Boolean {
			if ( this._affStr == null ) return false;
			var mid:int, left:int=0, right:int= this._affStr.length - 1;
			while ( left <= right ) {
				mid = (right+left)/2;
				if ( this._affStr.charCodeAt(mid) == flag )
					return true;
				if ( flag < this._affStr.charCodeAt(mid) ) right = mid -1;
				else left = mid + 1;
			}
			return false;
		}

		public function testAffixs(flags:Array):Boolean {
			for ( var i:int; i< flags.length; ++i) {
				if( testAffix(flags[i]) )
					return true;
			}
			return false;
		}
		//For develepors only, this function is made so that when flagmode=flag_long flags can be viewed.
		public function printFlag(flag:Number):void{
			var result:String =  String.fromCharCode(flag>>8) + String.fromCharCode(flag-((flag>>8)<<8));
			
		}

		
		static public function TESTAFF(affix:String, flag:Number):Boolean {
			if ( affix == null ) return false;
			affix =  StringUtils.sort(affix);
			var mid:int, left:int=0, right:int= affix.length - 1;
			while ( left <= right ) {
				mid = (right+left)/2;
				if ( affix.charCodeAt(mid) == flag )
					return true;
				if ( flag < affix.charCodeAt(mid) ) right = mid -1;
				else left = mid + 1;
			}
			return false;
			
		}
	}
}