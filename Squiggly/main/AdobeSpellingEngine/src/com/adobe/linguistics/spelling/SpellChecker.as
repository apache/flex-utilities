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
	import com.adobe.linguistics.spelling.core.*;

	/**
	 * The spelling engine.
	 *
	 * <p>This class implements the <code>ISpellChecker</code> interface.
	 * This class performs spell&#x2d;checking and generates suggestion lists for misspelled words.
	 * This class does not include any user-interface elements. Use this class if you want to offer 
	 * control over how all upper case words are handled or words with numbers are handled, as this 
	 * level of control is not offered by the SpellUI class.  However, please keep in mind that if 
	 * you use this class, you will need to write your own UI.</p>
	 *
	 * <p>This class is based on the Hunspell algorithm and works with Hunspell/MySpell 
	 * dictionaries and corresponding language rules files.</p>
	 * <p>Currently, we support a subset of Hunspell rules(options). </p>
	 * <p>The future of this class is to align as much as possible with existing Hunspell solution 
	 * both for the algorithms and the content. </p> 
	 * <p>In this version, users can also directly load Open-Office dictionaries to HunspellDictionary 
	 * class and initialize a SpellChecker instance with this HunspellDictionary object. When using this 
	 * class, the language of use is implied by the dictionary supplied.  Please make sure you load the 
	 * appropriate dictionary based on the language the user selects to input.</p>
	 * 
	 * <p>Note: In the current implementation, only one main dictionary can be used at a time. In addition, 
	 * in this version, suggestions for misspelled words do not include words from the user dictionary.</p>
	 *
	 * @includeExample Examples/Flex/TextEditor/src/TextEditor.mxml -noswf
	 * 
	 * @playerversion Flash 10
	 * @langversion 3.0
	 */
	public class SpellChecker implements ISpellChecker
	{
		private var _spellingEngine:SquigglyEngine;
		private var _rule:LinguisticRule;
		private var _dict:SquigglyDictionary;
		
		private var _udEngine:UserDictionaryEngine;
		
		/**
		 * Constructs a new <code>SpellChecker</code> object that performs language sensitive spell checking.
		 * 
		 * @param spellingDictionary A <code>ISpellingDictionary</code> interface to be used by this <code>SpellChecker</code>.
		 * For example, you can pass a <code>HunspellDictonary</code> object which already implemented the <code>ISpellingDictionary</code> interface to this constructor.
		 *
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public function SpellChecker(spellingDictionary:ISpellingDictionary)
		{
			_rule = spellingDictionary.linguisticRule;
			_dict = spellingDictionary.squigglyDictionary;
			_spellingEngine = new SquigglyEngine(_rule,_dict);
			_spellingEngine.fastMode = true;
			_udEngine = new UserDictionaryEngine();
		}

		/**
		 * Add a user dictionary to the SpellChecker.
		 * 
		 * @return <code>true</code> if the operation is successful. <code>false</code> if the operation failed.
		 * @param userDictionary A <code>UserDictionary</code> object to be added to this <code>SpellChecker</code>.
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		public function addUserDictionary(userDictionary:UserDictionary):Boolean
		{
			return _udEngine.addDictionary(userDictionary.internalUserDictionary);
		}
		
		/**
		 * Remove a user dictionary from the SpellChecker.
		 * 
		 * @return <code>true</code> if the operation is successful. <code>false</code> if the operation failed.
		 * @param userDictionary A <code>UserDictionary</code> object to be removed from this <code>SpellChecker</code>.
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		public function removeUserDictionary(userDictionary:UserDictionary):Boolean
		{
			return _udEngine.removeDictionary(userDictionary.internalUserDictionary);
		}

		
		/**
		 * Spellchecks a word.
		 * 
		 * @param word	A string containing a word.
		 * 			<p><strong>Notes:</strong></p>
		 *				<ul>
		 *					<li>
		 *						Please be aware that it is the caller's responsibility to break down sentences into words that can be handled by this method.
		 *  					For example, this method does not support punctuation marks such as comma, colon, quotes, etc.
		 *						Punctuation marks should be stripped out from the word prior to calling this method.
		 *						If a word contains white spaces (such as a regular space or non-breaking space), the word will be considered as misspelled.
		 *					</li>
		 *				</ul>
		 * @return <code>true</code> if the word is properly spelled. <code>false</code> if the word is misspelled.
		 *
		 * @includeExample Examples/Flex/CheckWord/src/CheckWord.mxml -noswf
		 * 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public function checkWord(word:String):Boolean
		{
			return (_spellingEngine==null)? false:(_udEngine.spell(word) || _spellingEngine.spell(word));
		}
		
		/**
		 * Gets suggestions for a misspelled word. 
		 *
		 * @param word	A string containing a misspelled word.
		 * 	
		 * @return	A list of suggestions. <p>Up to ten suggestions may be returned.</p>
		 *
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public function getSuggestions(word:String):Array
		{
			return (_spellingEngine==null)? null:_spellingEngine.suggest(word);
		}


		/** @private
		 * The version of this <code>SpellChecker</code> class.
		 * 
		 * <p>Example: "0.3"</p>
		 * 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public static function get version():String
		{
			return "0.5";
		}



		/**
		 * This property controls if Title Case Words should be considered as properly spelled.
		 * 
		 * <p>The default value is <code>false</code>.</p> 
		 *
		 * <p>If <code>ignoreTitleCase</code> is set to <code>true</code>, any words with first character capped are always considered as properly spelled.</p>
		 * <p>If <code>ignoreWordWithTitleCase</code> is set to <code>true</code>, "Spel" will be considered as properly spelled even if the dictionary does not contain "spel" or "Spel".
		 * If <code>ignoreWordWithTitleCase</code> is set to <code>false</code>, "Spel" will be considered as mispelled unless the dictionary contain "Spel".</p>
		 *
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		private function get ignoreWordWithTitleCase():Boolean
		{
			return _spellingEngine.ignoreCappedWord;
		}
		private function set ignoreWordWithTitleCase(value:Boolean):void
		{
			_spellingEngine.ignoreCappedWord = value;
		}
		
		/**
		 * This property controls if words in all upper case should be considered as properly spelled or not.
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
		 *
		 *	<!--
		 *	<p>Following table contains some examples to show how this property works.</p>
		 * 	<p>Assumption: <code>ignoreWordWithTitleCase</code> = <code>false</code></p>
		 *	<table class="innertable">
		 *		<tr>
		 *			<td rowspan=2 align="center"><strong>Word in dictionary</strong></td>
		 *			<td rowspan=2 align="center"><strong>Input word</strong></td>
		 *			<td colspan=2 align="center"><strong><code>ignoreWordWithAllUpperCase</code></strong></td>
		 *		</tr>
		 *		<tr>
		 *			<td align="center"><strong><code>false</code></strong></td>
		 *			<td align="center"><strong><code>true</code></strong></td>
		 *		</tr>
		 *		<tr>
		 *			<td rowspan="4">apple</td>
		 *			<td>apple</td>
		 *			<td>Properly spelled</td>
		 *			<td>Properly spelled</td>
		 *		</tr>
		 *		<tr>
		 *			<td>APPLE</td>
		 *			<td>Properly spelled</td>
		 *			<td>Properly spelled</td>
		 *		</tr>
		 *		<tr>
		 *			<td>Apple</td>
		 *			<td>Properly spelled</td>
		 *			<td>Properly spelled</td>
		 *		</tr>
		 *		<tr>
		 *			<td>aPPLe</td>
		 *			<td>Properly spelled</td>
		 *			<td>Properly spelled</td>
		 *		</tr>
		 *		<tr>
		 *			<td rowspan="4">NATO</td>
		 *			<td>nato</td>
		 *			<td>Properly spelled</td>
		 *			<td>Properly spelled</td>
		 *		</tr>
		 *		<tr>
		 *			<td>NATO</td>
		 *			<td>Properly spelled</td>
		 *			<td>Properly spelled</td>
		 *		</tr>
		 *		<tr>
		 *			<td>Nato</td>
		 *			<td>Properly spelled</td>
		 *			<td>Properly spelled</td>
		 *		</tr>
		 *		<tr>
		 *			<td>NaTo</td>
		 *			<td>Properly spelled</td>
		 *			<td>Properly spelled</td>
		 *		</tr>
		 *		<tr>
		 *			<td rowspan="4">London</td>
		 *			<td>london</td>
		 *			<td>Properly spelled</td>
		 *			<td>Properly spelled</td>
		 *		</tr>
		 *		<tr>
		 *			<td>LONDON</td>
		 *			<td>Properly spelled</td>
		 *			<td>Properly spelled</td>
		 *		</tr>
		 *		<tr>
		 *			<td>London</td>
		 *			<td>Properly spelled</td>
		 *			<td>Properly spelled</td>
		 *		</tr>
		 *		<tr>
		 *			<td>LoNDoN</td>
		 *			<td>Properly spelled</td>
		 *			<td>Properly spelled</td>
		 *		</tr>
		 *		<tr>
		 *			<td rowspan="4">iPhone</td>
		 *			<td>iphone</td>
		 *			<td>Properly spelled</td>
		 *			<td>Properly spelled</td>
		 *		</tr>
		 *		<tr>
		 *			<td>IPHONE</td>
		 *			<td>Properly spelled</td>
		 *			<td>Properly spelled</td>
		 *		</tr>
		 *		<tr>
		 *			<td>IPhone</td>
		 *			<td>Properly spelled</td>
		 *			<td>Properly spelled</td>
		 *		</tr>
		 *		<tr>
		 *			<td>iPHoNe</td>
		 *			<td>Properly spelled</td>
		 *			<td>Properly spelled</td>
		 *		</tr>
		 *	</table>
		 *	-->
		 * 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public function get ignoreWordWithAllUpperCase():Boolean
		{
			return _spellingEngine.ignoreAllUpperCase;
		}
		public function set ignoreWordWithAllUpperCase(value:Boolean):void
		{
			_spellingEngine.ignoreAllUpperCase = value;
		}
		
		
		/**
		 * This property controls if words with numbers, such as windows95, should be considered as properly spelled.
		 * 
		 * <table class="innertable">
		 *		<tr>
		 *			<td align="center"><strong><code>ignoreWordWithNumber</code></strong></td>
		 *			<td align="center"><strong>&#160;</strong></td>
		 *			<td align="center"><strong>Description</strong></td>
		 *		</tr>
		 *		<tr>
		 *			<td><code>false</code></td>
		 *			<td>Default</td>
		 *			<td><p>Any words containing digits are checked for proper spelling.</p>
		 *				<p>Example: If <code>ignoreWordWithNumber</code> = <code>false</code>, "mispel99" will be checked for proper spelling.</p>
		 *			</td>
		 *		</tr>
		 *		<tr>
		 *			<td><code>true</code></td>
		 *			<td>&#160;</td>
		 *			<td><p>Words containing digits are always ignored/skipped regardless of the dictionary.</p>
		 *				<p>Example: If <code>ignoreWordWithNumber</code> = <code>true</code>, "mispel99" will be considered as properly spelled.</p>
		 *			</td>
		 *		</tr>
		 *	</table>
		 *
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public function get ignoreWordWithNumber():Boolean 
		{
			return _spellingEngine.ignoreWordWithNumber;
		}
		public function set ignoreWordWithNumber(value:Boolean):void
		{
			_spellingEngine.ignoreWordWithNumber = value;
		}


		/**
		 * <span class="hide">
		 * TODO: Decide this block based API.
		 * Check a block of text and find out all misspelled words in the text.
		 * 
		 * 
		 * @param text	A string containing a block of texts.
		 * @param separators	An array of separators.
		 *
		 * @return An Array of misspelled word tokens, each token contains the startIndex and length
		 *
		 * @playerversion Flash 10
		 * @langversion 3.0
		 * 
		 * Option 1:
		 *
		 * public function checkText(text:String, separators:Array):Array
		 * {
		 * }
		 * 
		 * Option 2:
		 *
		 * public function checkText(text:String, tokenizer:ITokenizer):SpellResultIterator
		 * {
		 * }
		 * </span>
		 */
	}
}

