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
	import com.adobe.linguistics.spelling.utils.WordList;
	
	/**
	 * Represents a user dictionary.
	 *
	 * <p>This class represents a user dictionary that is used by the <code>SpellChecker</code> class. This class itself is an in-memory object
	 * and doesn't store persistent data. However, developers can import/export a <code>UserDictionaryInternal</code> object from/to an Array of String, 
	 * and use other flash classes to keep the data persistent. You may want to consider using one of the following options for permanent storage:
	 *
	 * <ul>
	 *	<li>SharedObject, which is used in our SpellUI class to store words added from the ContextMenu</li>
	 *	<li>File/FileStream, which is used in our UserDictionaryInternalExample and can be shared across AIR applications</li>
	 *	<li>Server side storage, for example database so that it can be shared across users</li>
	 * </ul>
	 * </p>
	 * <p>If you are using our SpellUI class the UserDictionaryInternal will be created behind the scene and stored in a SharedObject.</p>
	 * @includeExample Examples/Air/UserDictionaryInternalExample/src/UserDictionaryInternalExample.mxml -noswf
	 * @playerversion Flash 10
	 * @langversion 3.0
	 */	 
	public class UserDictionaryInternal
	{
		/**
		 @private
		 (This property is for Squiggly Developer use only.)
		 */
		public var _wordList:WordList;
		
		/**
		 * Constructs a new <code>UserDictionaryInternal</code> which can later be added to a <code>SpellChecker</code> object.
		 *
		 * @param wordList An array of words (String) to be added as the initial entries of this <code>UserDictionaryInternal</code>
		 * @see UserDictionaryInternal.wordList
		 *
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public function UserDictionaryInternal(wordList:Array=null)
		{
			// TODO: exception if has some problem with insert
			_wordList= new WordList();
			if (wordList) {
				for each (var w:String in wordList)
				_wordList.insert(w); 
			}
		}
		
		/**
		 * Add a word to the user dictionary.
		 * 
		 * @param word A word to be added to this <code>UserDictionaryInternal</code>.
		 * @return <code>true</code> if the operation is successful. <code>false</code> if the operation is failed.
		 * @see UserDictionaryInternal.removeWord()
		 * 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		public function addWord(word:String):Boolean	
		{
			return _wordList.insert(word);
		}
		
		/**
		 * Removes a word from the user dicitonary.
		 * 
		 * @param word A word to be removed from this <code>UserDictionaryInternal</code>.
		 * @return <code>true</code> if the operation is successful. <code>false</code> if the operation is failed.
		 * @see UserDictionaryInternal.addWord()
		 * 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		public function removeWord(word:String):Boolean
		{
			return _wordList.remove(word);
		}
		
		/**
		 * List of all words in this user dictionary.
		 *
		 * @return An Array of String that contains all words in this user dictionary
		 * 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		public function get wordList():Array
		{
			// TODO: make sure no return by reference
			return _wordList.toArray();
		}
	}
}