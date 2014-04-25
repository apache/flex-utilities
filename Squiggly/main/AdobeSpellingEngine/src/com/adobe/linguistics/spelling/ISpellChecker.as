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
	/**
	 * Interface for actual SpellChecker class implementations
	 *
	 * <p>If a new SpellChecker class is created, it must implement the methods and properties defined by this interface.
	 * The <code>SpellChecker</code> class implements this interface.</p>
	 * 
	 * @playerversion Flash 10
	 * @langversion 3.0
	 */
	public interface ISpellChecker
	{	
		/**
		 * Spellchecks a word.
		 * 
		 * @param word	A string containing a word.
		 * 			<p><strong>Note: </strong>Please be aware that it is the caller's responsibility to break down sentences into words that can be handled by this method.
		 *  			For example, this method does not support punctuation marks such as comma, colon, quotes, etc.
		 *				Punctuation marks should be stripped out from the word prior to calling this method.</p>
		 * @return <code>true</code> if the word is properly spelled. <code>false</code> if the word is misspelled.
		 *
		 * @includeExample Examples/Flex/CheckWord/src/CheckWord.mxml
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		function checkWord(word:String):Boolean;
		
		/**
		 * Gets suggestions for a misspelled word. 
		 *
		 * @param word	A string containing a misspelled word.
		 * 					<p>A properly spelled word does not generate any suggestions.</p>  
		 * @return	A list of suggestions.
		 *					If the input word is properly spelled, an empty list will be returned.</p>
		 *
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		function getSuggestions(word:String):Array;
		
	}
}
