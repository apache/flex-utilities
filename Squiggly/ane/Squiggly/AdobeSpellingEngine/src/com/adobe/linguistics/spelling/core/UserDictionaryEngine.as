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
	import com.adobe.linguistics.spelling.UserDictionary;
	import com.adobe.linguistics.spelling.utils.WordList;
	
	public class UserDictionaryEngine
	{
		// Private properties
		private var _dictionaryList:Array;		// get only
		private var _userDict:UserDictionary;

		public function UserDictionaryEngine(ud:UserDictionary=null)
		{
			_dictionaryList = new Array();
		}
		public function addDictionary(userDictionary:UserDictionary):Boolean
		{
			if ( (userDictionary == null) ) return false;
			
			for ( var i:int = 0;i < _dictionaryList.length; ++i ) {
				if ( userDictionary == _dictionaryList[i] )
					return false;
			} 
			_dictionaryList.push(userDictionary);
			return true;
		}

		public function removeDictionary(userDictionary:UserDictionary):Boolean
		{
			
			for ( var i:int =0; i < _dictionaryList.length; ++i ) {
				if ( userDictionary == _dictionaryList[i] ) {
					_dictionaryList.splice(i,1);
					return true;
				}
			}
			return false;
		}
		
		public function spell( word:String, language:String ) :Boolean {
			var result:Boolean = false;
			for ( var i:int =0; (i < _dictionaryList.length) && (!result);++i ) {
				_userDict = _dictionaryList[i];
				if ( _userDict ) {
					var wordList:WordList=_userDict.getWordList(language);
					if(wordList)
						result = (wordList.lookup(word) != -1);
					else
						result=false;
				}
			}
			return result;
		}

	}
}