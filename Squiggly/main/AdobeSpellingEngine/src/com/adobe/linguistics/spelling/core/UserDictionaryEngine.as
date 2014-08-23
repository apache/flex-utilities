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
	import com.adobe.linguistics.spelling.UserDictionaryInternal;
	
	public class UserDictionaryEngine
	{
		// Private properties
		private var _dictionaryList:Array;		// get only
		private var _userDict:UserDictionaryInternal;

		public function UserDictionaryEngine(ud:UserDictionaryInternal=null)
		{
			_dictionaryList = new Array();
		}
		public function addDictionary(userDictionary:UserDictionaryInternal):Boolean
		{
			if ( (userDictionary == null) ) return false;
			
			for ( var i:int = 0;i < _dictionaryList.length; ++i ) {
				if ( userDictionary == _dictionaryList[i] )
					return false;
			} 
			_dictionaryList.push(userDictionary);
			return true;
		}

		public function removeDictionary(userDictionary:UserDictionaryInternal):Boolean
		{
			
			for ( var i:int =0; i < _dictionaryList.length; ++i ) {
				if ( userDictionary == _dictionaryList[i] ) {
					_dictionaryList.splice(i,1);
					return true;
				}
			}
			return false;
		}
		
		public function spell( word:String ) :Boolean {
			var result:Boolean = false;
			for ( var i:int =0; (i < _dictionaryList.length) && (!result);++i ) {
				_userDict = _dictionaryList[i];
				if ( _userDict ) {
					result = (_userDict._wordList.lookup(word) != -1);
				}
			}
			return result;
		}

	}
}