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




package com.adobe.linguistics.utils
{
	/**
	 * The <code>ITokenizer</code> Interface.
	 * This interface defines default methods which will be used for Adobe Linguistic Service.
	 * Be independent from any UI component or be able to adapt to a given UI component. 
	 * Provide or define standardized way so that third-party can switch to their tokenizer.
	 * Be able to use for any given language either by some kind of language specific handling or by some kind of unified logic for any given language.
	 * More sophisticated implementations can be done for particular locales or environments in an application by implementing this interface.

	 * @playerversion Flash 10
	 * @langversion 3.0
	 */
	public interface ITokenizer
	{
		
		/**
		 * Return the first word in the text being scanned. 
		 * 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		function getFirstToken():Token;
		
		/**
		 * Return the last word in the text being scanned. 
		 * 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		function getLastToken():Token;
		
		/**
		 * Determine the next word following the current token.  
		 * 
		 * Return the token of the next word or <code>lastToken</code> object if all word have been returned.
		 * @param token A <code>Token</code> object to be used for determining next word.
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		function getNextToken(token:Token):Token;
		
		/**
		 * Determine the previous word preceding the current token.  
		 * 
		 * Return the token of the previous word or <code>firstToken</code> object if all word have been returned.
		 * @param token A <code>Token</code> object to be used for determining previous word.
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		function getPreviousToken(token:Token):Token;

	}
}