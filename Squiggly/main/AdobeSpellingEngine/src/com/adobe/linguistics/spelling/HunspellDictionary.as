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
	import com.adobe.linguistics.spelling.core.LinguisticRule;
	import com.adobe.linguistics.spelling.core.SquigglyDictionary;
	import com.adobe.linguistics.spelling.core.utils.LinguisticRuleLoader;
	import com.adobe.linguistics.spelling.core.utils.SquigglyDictionaryLoader;
	
	import flash.errors.IllegalOperationError;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	/**
	 *
	 * This class enables creation and loading of spelling metadata including rules and dictionary data
	 *
	 * @playerversion Flash 10
	 * @langversion 3.0
	 * @includeExample Examples/Air/CheckWord/src/CheckWord.mxml -noswf
	 */
	 
	public final class HunspellDictionary extends EventDispatcher implements ISpellingDictionary
	{
		private var _dict:SquigglyDictionary;
		private var _attrMgr:LinguisticRule;
		private var _rulePath:String;
		private var _dictionaryPath:String;
		
		private var ruleLoader:LinguisticRuleLoader = new LinguisticRuleLoader();
		private var dictLoader:SquigglyDictionaryLoader = new SquigglyDictionaryLoader();

		private var _loaded:Boolean;
		
		//adding vars for loading dictionaries in parts
		private var _enableDictionarySplit:Boolean;
		private var _wordsPerDictionarySplit:int;

		/**
		 * Constructs a new <code>HunspellDictionary</code> which can later be used by a <code>SpellChecker</code> object.
		 *
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public function HunspellDictionary()
		{
			_attrMgr = null;
			_dict = null;
			_rulePath = null ;
			_dictionaryPath = null;
			_loaded = false;
			//giving default values in case user does not want to specify these
			_enableDictionarySplit =false;
			_wordsPerDictionarySplit= 20000;

		}

		/**
			@private
			(This property is for Squiggly Developer use only.)
		*/
		public function get linguisticRule():LinguisticRule {
			return _attrMgr;
		}
		
		/**
			@private
			(This property is for Squiggly Developer use only.)
		*/
		public function get squigglyDictionary():SquigglyDictionary {
			return  _dict;
		}
		
		/**
		 * Loads a Hunspell dictionary and corresponding rules files as specified by the <code>dictionaryURL</code> and the <code>rulesURL</code>.
		 *
		 * <p>The actual loading is done asynchronously and
		 *	the <code>HunspellDictionary</code> object will dispatch an <code>Event.COMPLETE</code> event.
		 *	When an error condition occurs, it will dispatch an <code>IOErrorEvent.IO_ERROR</code> event.</p>
		 * @param rulesURL The URL of rule file to be loaded.
		 * @param dictionaryURL The URL of Dictionary file to be loaded.
		 * @playerversion Flash 10
		 * @langversion 3.0
		 * @example The following code shows how load API is called to load a Rule and Dictionary file to create a HunspellDictionay.
		 * <listing version="3.0">
		 * private var _newdict:HunspellDictionary = new HunspellDictionary();
		 * _newdict.load("dictionaries/en_US/en_US.aff", "dictionaries/en_US/en_US.dic");
		 * </listing>
		 */
		public function load(rulesURL:String, dictionaryURL:String):void {
			if ( rulesURL == null || dictionaryURL == null ) {
				throw new IllegalOperationError("load function did not receive two valid URLs.");
			}
			_rulePath = rulesURL;
			_dictionaryPath = dictionaryURL;
			
			ruleLoader.addEventListener(Event.COMPLETE,loadRuleComplete);
			ruleLoader.addEventListener(IOErrorEvent.IO_ERROR,handleError);
			ruleLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleError);
			ruleLoader.load( _rulePath);
			
		}

		/**
		 * A flag that indicates if the dictionary has finished loading.
		 * 
		 * @return <code>true</code> if loading is completed. <code>false</code> if loading has not completed.
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public function get loaded():Boolean
		{
			return _loaded;
		}

		
		// Private method to dispatch complete Event.
		private function loadRuleComplete(evt:Event):void {
			_attrMgr = ruleLoader.linguisticRule;
			
			dictLoader.linguisticRule = _attrMgr;
			dictLoader.addEventListener(Event.COMPLETE,loadDictionaryComplete);
			dictLoader.addEventListener(IOErrorEvent.IO_ERROR,handleError);
			dictLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleError);
			dictLoader.load(_dictionaryPath, _enableDictionarySplit, _wordsPerDictionarySplit);
		}

		// Private method to dispatch complete Event.
		private function loadDictionaryComplete(evt:Event):void {
			_dict = dictLoader.squigglyDictionary;
			_loaded = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		//Private method to dispatch an error event.
		private function handleError(evt:Event):void {
			bounceEvent(evt);
		}
		
		private function bounceEvent(evt:Event):void {
			dispatchEvent(evt.clone());
		}
		
		/**
		 * This is a flag that enables/disables loading of dictionary in splits.
		 * By default this flag is set to <code>false</code>. In case the initial loading time of dictionaries is found slow, this flag should be set to <code>true</code>. By enabling this, squiggly will load dictionary in splits with each split having <code>wordsPerDictionarySplit</code> number of words.
		 * <p>NOTE: This property, if used, should be set before calling <code>HunspellDictionary.load</code>. Once <code>HunspellDictionary.load</code> is called dictionaries will be loaded according to default values, and this property will not be used. </p>
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public function get enableDictionarySplit():Boolean
		{
			return _enableDictionarySplit;	
		}
		
		public function set enableDictionarySplit(enableDictionarySplit:Boolean):void
		{
			_enableDictionarySplit = enableDictionarySplit;
		}
		
		/**
		 * This property defines the number of words in one dictionary split.
		 * By default the value of this property is set to 20000 words. This property is used only if <code>enableDictionarySplit</code> is set to <code>true</code>. If <code>enableDictionarySplit</code> is set to <code>flase</code> this property turns void.
		 * <p>NOTE: This property, if used, should be defined before calling <code>HunspellDictionary.load</code>. Once <code>HunspellDictionary.load</code> is called dictionaries will be loaded according to default values, and this property will not be used. </p>
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public function get wordsPerDictionarySplit():int
		{
			
			return _wordsPerDictionarySplit;	
		}
		
		public function set wordsPerDictionarySplit(wordsPerDictionarySplit:int):void
		{
			if(wordsPerDictionarySplit<=0){
				//Do error Handling
				throw new IllegalOperationError("wordsPerDictionarySplit should be a positive non-zero value.");
			}
			_wordsPerDictionarySplit = wordsPerDictionarySplit;
		}
	}

}
