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
	import com.adobe.linguistics.extensions.HunspellNativeExtension;
	import com.adobe.linguistics.spelling.UserDictionary;
	import com.adobe.linguistics.spelling.core.UserDictionaryEngine;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	/**
	 * The SpellingService provides spell checking features for the specified language. 
	 * This class makes use of SpellingConfiguration class to dynamically get the language dictionary location. The dictionaries are then loaded and SpellChecker object
	 * created based on these dictionaries. 
	 * @includeExample ../Examples/Flex/SpellingServiceEsg/src/SpellingServiceEsg.mxml -noswf
	 * @playerversion Flash 10
	 * @langversion 3.0.
	 * 
	 */
	public class SpellingService extends EventDispatcher
	{
		private var _language:String = null;
		private const _allLanguage:String= "lang_neutral";
		private var _udEngine:UserDictionaryEngine = null;
		private var _userDictionaries:Array = new Array();
		private var _thirdPatyResourceLocation:String;
		
		private var _nativeExtension:HunspellNativeExtension;
		private var _nativeIsInit:Boolean;				
		// Static table for caching engines and fixed dictionaries
		//private static var _engines:Array = new Array();
	//	private static var _dicts:Array = new Array();
		private static const HUNSPELL_INIT_FAIL:int= -1
		private static const RESOURCE_FILES_MISSING:int= -2
		private static const HUNSPELL_INIT_SUCCESS:int= 1
			
		
		
		/**
		 * Constructs a spelling service object.
		 *
		 * @param language The language used to create a <code>SpellingService</code>.
		 */
		public function SpellingService(language:String)
		{
			_language = language;	
			_thirdPatyResourceLocation="";
		}

		/**
		 * Initialize the <code>SpellingService</code>. 
		 */		
		public function init():void
		{
			_udEngine = new UserDictionaryEngine();
			//initialize native extension
			_nativeExtension= new HunspellNativeExtension();
			//"E:\\P90\\esg\\users\\ugoyal\\nativeLib\\Dictionaries"
			
			if(_thirdPatyResourceLocation!="" && ( _nativeExtension.initHunspellObject(_language, _thirdPatyResourceLocation)==HUNSPELL_INIT_SUCCESS ) )
				_nativeIsInit=true;
			else
				_nativeIsInit=false;
			loadDictComplete(null);//TODO: If performace problems are found use event mechanism in DLL to load ANE.
		}
		
		private function loadDictComplete(e:Event):void
		{

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
			if(_nativeIsInit)
			return (  _udEngine.spell(word, _language) || _udEngine.spell(word, _allLanguage)|| _nativeExtension.checkWord(word,_language) );
			else //return true if the ANE is failed to initialize i.e. stop spell checking without effect working of the Product.
				return true;
			//return ((_udEngine.spell(word)) || (_engine.checkWord(word)));
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
			var resultArray:Array;
			if (_nativeIsInit)
				resultArray=_nativeExtension.getSuggestions(word, _language);
		//	var resultArray:Array;= _engine.getSuggestions(word);
			
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
			if  (_udEngine.addDictionary(userDictionary) == true)
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
			if (_udEngine.removeDictionary(userDictionary) == true)
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

		
		public function get thirdPatyResourceLocation():String
		{
			return _thirdPatyResourceLocation;
		}
		
		public function set thirdPatyResourceLocation(value:String):void
		{
			_thirdPatyResourceLocation = value;
		}
	}
}


