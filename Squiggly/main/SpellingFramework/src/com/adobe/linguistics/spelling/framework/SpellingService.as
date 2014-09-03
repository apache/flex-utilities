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
  
  
package com.adobe.linguistics.spelling.framework
{
	import com.adobe.linguistics.spelling.HunspellDictionary;
	import com.adobe.linguistics.spelling.SpellChecker;
	import com.adobe.linguistics.spelling.UserDictionary;
	import com.adobe.linguistics.spelling.core.UserDictionaryEngine;
	import com.adobe.linguistics.spelling.core.env.InternalConstants;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
//	import flash.utils.Timer;
//	import flash.events.TimerEvent;
	
	/**
	 * The SpellingService provides spell checking features for the specified language. 
	 * This class makes use of SpellingConfiguration class to dynamically get the language dictionary location. The dictionaries are then loaded and SpellChecker object
	 * created based on these dictionaries. SpellingService also caches SpellChecker and dictionary objects for individual languages for efficient reuse.
	 * @includeExample ../Examples/Flex/SpellingServiceEsg/src/SpellingServiceEsg.mxml -noswf
	 * @playerversion Flash 10
	 * @langversion 3.0.
	 * 
	 */
	public class SpellingService extends EventDispatcher
	{
		private var _language:String = null;
		private var _engine:SpellChecker = null;
		private var _udEngine:UserDictionaryEngine = null;
		private var _userDictionaries:Array = new Array();
		
				
		// Static table for caching engines and fixed dictionaries
		private static var _engines:Array = new Array();
		private static var _dicts:Array = new Array();
		
		/**
		 * Constructs a spelling service object.
		 *
		 * @param language The language used to create a <code>SpellingService</code>.
		 */
		public function SpellingService(language:String)
		{
			_language = language;		
		}

		/**
		 * Initialize the <code>SpellingService</code>. Once the initialization is done, an <code>Event.COMPLETE</code> event will be dispatched
		 * and the <code>SpellingService</code> is ready to be used.
		 */		
		public function init():void
		{
			_udEngine = new UserDictionaryEngine();
			
			// Since the engine and dictionary are shared, the loading has three status
			// Loaded
			if (_engines[_language] != null)
			{
				loadDictComplete(null);
			}
			// Loading
			else if (_dicts[_language] != null)
			{
				_dicts[_language].addEventListener(Event.COMPLETE, loadDictComplete);
			}
			// Loading not started
			else
			{			
				var urls:Object = SpellingConfiguration.resourceTable.getResource(_language);
				var hunspellDict:HunspellDictionary = new HunspellDictionary();
				_dicts[_language] = hunspellDict;
				hunspellDict.addEventListener(Event.COMPLETE, loadDictComplete);
				/*added for check on 10-12-2010
				var mytimer:Timer =new Timer(50,0);
				mytimer.start();
				var initTime:int =mytimer.currentCount;
				trace(initTime);*/
				
				//adding code for enabling loading in parts. Since spelling service class needs SpellingConfiguration so it this property uses it.
				hunspellDict.enableDictionarySplit=SpellingConfiguration.enableDictionarySplit;//user has to be freed from this. So we have to put a default value in SpellingConfiguration class.
				hunspellDict.wordsPerDictionarySplit=SpellingConfiguration.wordsPerDictionarySplit;//user has to be freed from this. So we have to put a default value in SpellingConfiguration class.
				
				hunspellDict.load(urls["rule"], urls["dict"]);
				/*var timePassed:int =mytimer.currentCount;
				trace(timePassed);*/
			}
		}
		
		private function loadDictComplete(e:Event):void
		{
			if (_engines[_language] == null) {
				_engines[_language] = new SpellChecker(_dicts[_language]);
			}
			_engine = _engines[_language];
			dispatchEvent(new Event(Event.COMPLETE));
		}
	
		/**
		 * Check the spelling of a word.
		 *
		 * @param word The word to be checked.
		 * @return True if the word is correctly spelled, false if it is misspelled.
		 */		
		public function checkWord(word:String):Boolean
		{
			return ((_udEngine.spell(word)) || (_engine.checkWord(word)));
		}

		/**
		 * Get the suggestion of a misspelled word. 
		 *
		 * @param word The word to be checked.
		 * @return A vector containing all suggestions for the misspelled word, ordered by similarity to the original word. 
		 * Note that if a word is already correctly spelled, an empty Vector is returned.
		 * @internal TODO: get the suggestions from user dicitonaries
		 */			
		public function getSuggestions(word:String):Vector.<String>
		{
			var resultArray:Array = _engine.getSuggestions(word);
			
			var resultVector:Vector.<String> = new Vector.<String>();
			for each (var i:String in resultArray) {
				resultVector.push(i);		
			}
			
			return resultVector;
		}
		
		/** 
		 * Add a <code>UserDictionary</code> to the <code>SpellingService</code>.
		 * 
		 * @param userDictionary The UserDictionary to be added.
		 * @return True if the UserDictionary is added successfully, false if any error occurs. An example error scenario: Trying to add a previously added user dictionary. 
		 * @see UserDictionary
		 */
		public function addUserDictionary(userDictionary:UserDictionary):Boolean
		{
			if  (_udEngine.addDictionary(userDictionary.internalUserDictionary) == true)
			{
				_userDictionaries.push(userDictionary);
				return true;
			} 
			
			return false;
		}

		/** 
		 * Remove a <code>UserDictionary</code> from the <code>SpellingService</code>.
		 * 
		 * @param userDictionary The UserDictionary to be removed.
		 * @return True if the UserDictionary is removed successfully, false if any error occurs. An example error scenario: Trying to remove a user dictionary that has not been added previously. 
		 * @see UserDictionary
		 */		
		public function removeUserDictionary(userDictionary:UserDictionary):Boolean
		{
			if (_udEngine.removeDictionary(userDictionary.internalUserDictionary) == true)
			{
				for ( var i:int =0; i < _userDictionaries.length; ++i ) {
					if ( userDictionary == _userDictionaries[i] ) {
						_userDictionaries.splice(i,1);
						return true;
					}
				}
			}
			
			return false;
		}
		
		/**
		 * A <code>Vector</code> of user dictionaries added to this <code>SpellingService</code>.
		 * 
		 * @return A <code>Vector</code> of <code>UserDictionary</code> objects.
		 * @see UserDictionary
		 */
		public function get userDictionaries():Vector.<UserDictionary>
		{	
			var resultVector:Vector.<UserDictionary> = new Vector.<UserDictionary>;
			for each (var i:UserDictionary in _userDictionaries) {
				resultVector.push(i);		
			}
			
			return resultVector;
		}
		
		/**
		 * This property controls if words in all upper-case should be considered as properly spelled or not.
		 * 
		 * <table class="innertable">
		 *		<tr>
		 *			<td align="center"><strong><code>ignoreWordWithAllUpperCase</code></strong></td>
		 *			<td align="center"><strong>&#160;</strong></td>
		 *			<td align="center"><strong>Description</strong></td>
		 *		</tr>
		 *		<tr>
		 *			<td><code>false</code></td>
		 *			<td>Default</td>
		 *			<td><p>Words with all characters in upper case are checked against the dictionary for proper spelling.</p>
		 *				<p>Example: if <code>ignoreWordWithAllUpperCase = false</code>, "MISPEL" will be checked for proper spelling.</p></td>
		 *		</tr>
		 *		<tr>
		 *			<td><code>true</code></td>
		 *			<td>&#160;</td>
		 *			<td><p>Any words with all characters in upper case are always considered as properly spelled,
		 *					no matter whether the word is in the dictionary or not.</p>
		 *				<p>Example: if <code>ignoreWordWithAllUpperCase = true</code>, "MISPEL" will be considered as properly spelled.</p></td>
		 *		</tr>
		 *	</table>
		 * */
		/* Getter Function for ignoring all word with all upper case*/
		public function get ignoreWordWithAllUpperCase():Boolean
		{
			return _engine.ignoreWordWithAllUpperCase;
		}
		/* Setter Function for ignoring all word with all upper case*/
		public function set ignoreWordWithAllUpperCase(value:Boolean):void
		{
			_engine.ignoreWordWithAllUpperCase=value;
		}
		
	}
}


