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

package com.adobe.linguistics.spelling
{
	import com.adobe.linguistics.spelling.UserDictionaryInternal;
	import com.adobe.linguistics.spelling.utils.WordList;
	
	import flash.utils.Dictionary;

	/**
	 * Represents a user dictionary.
	 *
	 * <p>This class represents a user dictionary that is used by the <code>SpellingService</code> class. This class itself is an in-memory object
	 * and doesn't store persistent data. However, developers can import/export a <code>UserDictionary</code> object from/to a vector of String, 
	 * and use other flash classes to keep the data persistent. You may want to consider using one of the following options for permanent storage:
	 *
	 * <ul>
	 *	<li>SharedObject, which is used in our SpellingUI class to store words added from the ContextMenu</li>
	 *	<li>File/FileStream, which is used in our UserDictionaryExample and can be shared across AIR applications</li>
	 *	<li>Server side storage, for example database so that it can be shared across users</li>
	 * </ul>
	 * </p>
	 * <p>If you are using our SpellingUI class the UserDictionary will be created behind the scene and stored in a SharedObject.</p>
	 */	 
	public class UserDictionary
	{
		//private var _ud:UserDictionaryInternal;
		private var _udMap:Dictionary;
		/**
		 * @private
		 */
		/*
		public function get internalUserDictionary():UserDictionaryInternal
		{
			return _ud;
		}
		*/
		
		/**
		 * Constructs a new <code>UserDictionary</code> which can later be added to a <code>SpellingService</code> object.
		 *
		 * @param wordList A vector of words (String) to be added as the initial entries of this <code>UserDictionary</code>
		 * @see UserDictionary.wordList
		 *
		 */
		public function UserDictionary(wordListMap:Array=null)
		{
			_udMap= new Dictionary();
			
			if(wordListMap)
			{
				for (var k:String in wordListMap)
				{
					//var wordList:Vector.<Object>= wordListMap[k] as Vector.<Object>;
					var array:Array = new Array();
					if (wordListMap[k]/*wordList*/) 
					{
						for each (var w:Object in wordListMap[k]/*wordList*/)
						array.push(w.toString());
					}
					_udMap[k] = new UserDictionaryInternal(k, array);
				}
				
			}
			
			
			
		}

		/**
		 * Add a word to the user dictionary.
		 * 
		 * @param word A word to be added to this <code>UserDictionary</code>.
		 * @return <code>true</code> if the operation is successful. <code>false</code> if the operation is failed, for example if the word is already added.
		 * @see UserDictionary.removeWord()
		 * 
		 */		
		public function addWord(word:String, language:String = "en_US"):Boolean	
		{
			if(_udMap[language]==null)
				_udMap[language]=new UserDictionaryInternal(language);
			return _udMap[language].addWord(word);
		}

		/**
		 * Removes a word from the user dicitonary.
		 * 
		 * @param word A word to be removed from this <code>UserDictionary</code>.
		 * @return True if the operation was successful, false if the operation was failed, for example if the word doesn't exist in the dictionary.
		 * @see UserDictionary.addWord()
		 * 
		 */		
		public function removeWord(word:String, language:String = "en_US"):Boolean
		{
			
			return _udMap[language].removeWord(word);
		}

		/**
		 * All words in this user dictionary.
		 *
		 * @return A vector of String that contains all words in this user dictionary
		 * 
		 */		
		public function getWordList(language:String):WordList
		{
			if(language==null || language == "")
				return null;
			//var result:Vector.<String> = new Vector.<String>();
			
			//for each (var w:String in array)
			//	result.push(w);
			var udInternal:UserDictionaryInternal=_udMap[language];
			
			return (udInternal? udInternal.wordList as WordList :null);
		}
		
		public function get wordListMap():Array
		{
			var result:Array = new Array();
			for each(var k:Object in _udMap)
			{
				var lang:String= k._language;
				var array:Array= (k.wordList as WordList).toArray();
				var wordVector:Vector.<String>= new Vector.<String>;
				if (array) 
				{
					for each (var w:String in array)
					wordVector.push(w);
				}
				result[lang] = wordVector;
				
			}
			return result;
		}
        
        public function get wordList():Array
        {
            var result:Array = new Array();
            for each(var k:Object in _udMap)
            {
                var lang:String= k._language;
                var array:Array= (k.wordList as WordList).toArray();
                var wordVector:Vector.<String>= new Vector.<String>;
                if (array) 
                {
                    for each (var w:String in array)
                    result.push(w);
                }
            }
            return result;
        }
	}
}