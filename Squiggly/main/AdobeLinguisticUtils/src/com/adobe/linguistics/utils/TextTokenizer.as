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
	import __AS3__.vec.Vector;
	
	import flash.utils.Dictionary;
	
    import flash.text.engine.TextBlock;
    import flash.text.engine.TextElement;
    import flash.text.engine.ElementFormat;

		
	/**
	 * <p>The <code>TextTokenizer</code> class locates the boundaries of words in a 
	 * block of text.</p>
	 * 
	 * Word boundary locations are found according to these general principles:
	 * <ul>
	 * 		<li> Be able to tokenize a block of text specified by start and end positions </li> 
	 * 		<li> Default separator is Unicode white space character. Also break on newlines </li> 
	 * 		<li> Tokens consist of either words or numbers in which case it may include commas, etc.. </li> 
	 * 		<li> Apostrophes or hyphens within a word are kept with the word </li> 
	 * 		<li> Punctuation, spaces and other characters that are not part of a token, are broken out separately </li> 
	 * </ul>
	 * <p>In the future versions, this class would also provide a way for the developers to customize the separators used by the tokenizer. </p>
	 * 
	 * @playerversion Flash 9.x
 	 * @langversion 3.0
	*/
	public class TextTokenizer implements ITokenizer
	{
		

		private var _textBlock:TextBlock;
		private var _textHolder:String;
		private var _startIndex:int;
		private var _endIndex:int;
		private var _firstToken:Token;
		private var _lastToken:Token;
		
		private var _ignoredCharactersDict:Dictionary = new Dictionary();


		/**
		 * The tokenizer for a String object.
		 * This class implements the ITokenizer interface.
		 * Constructs a new TextTokenizer object to break String to words by creating with a new piece of text. 
		 * @param textHolder A <code>String</code> object to hold the text which will be processed by this tokenizer.
		 * @param startIndex A <code>int</code> type input to hold the starting index of input text should be scanned.
		 * @param endIndex A <code>int</code> type input to hold the ending index of input text should be scanned.
		 * <span class="hide"> TODO param requestedLocaleIDName The LocaleID name to be used by this TextTokenizer object. </span>
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public function TextTokenizer(textHolder:String, startIndex:int=0, endIndex:int=int.MAX_VALUE)//, requestedLocaleIDName:String=null)
		{
			//requestedLocaleIDName parameter is useful for potential extension. won't handle it in the first round of implementation.
			//  same comments for API: requestedLocaleIDName()/actualLocaleIDName()/getAvailableLocaleIDNames()
            var textElement:TextElement = new TextElement(textHolder, new ElementFormat()); 
            var textBlock:TextBlock = new TextBlock();
            textBlock.content = textElement; 
			
			/* init a tokenizer object */
			this._textBlock = textBlock;
			this._textHolder = textHolder;
			this._startIndex =  0;
			this._endIndex = this._textBlock.content.text.length;
			initDefaultIgnoredCharacters();
			setStartIndex(startIndex);
			setEndIndex(endIndex);
			
		}
		
		private function setStartIndex(value:int):void {
			if ( value <= 0 ) 
				this._startIndex = 0;
			else if ( value >= this._endIndex ) 
				this._startIndex = this._endIndex;
			else
				this._startIndex=value;
		}
		
		// strange behaviour with String.substring() function... need more thinking....
		private function setEndIndex(value:int):void {
			if ( value >= this._textBlock.content.text.length ) 
				this._endIndex = this._textBlock.content.text.length;
			else if ( value <= this._startIndex ) 
				this._endIndex = this._startIndex;
			else
				this._endIndex = value;
		}

		private function initDefaultIgnoredCharacters():void {
			var ignoredCharsArray:Array = [
				0x002d,
				0x2010
			];
			var ignoredChars:String = "";
			for ( var i:int=0; i< ignoredCharsArray.length; ++i ) {
				ignoredChars=ignoredChars+String.fromCharCode(ignoredCharsArray[i]);
			}
			this.ignoredCharacters = ignoredChars;
		}

		private function getNextTokenByIndex( startPos:int ):Token{
			var resultToken:Token = null;
			/* calculate first token and return it. */
			var i:int = (startPos > this._startIndex) ? startPos: this._startIndex;
			while ( i< this._endIndex ) {
				var begin:int = i;
				i = this._textBlock.findNextWordBoundary(begin);
				var end:int = ( i <= this._endIndex) ? i : this._endIndex;
				if ( !isSingleSpecialCharacter( this._textHolder.substring(begin,end) ) ) {
					resultToken = new Token(begin,end);
					break;				
				}
			}
			if ( resultToken==null ) resultToken = this.getLastToken();
			return resultToken;
		}
		
		private function getPreviousTokenByIndex( endPos:int):Token {
			var resultToken:Token = null;
			/* calculate first token and return it. */
			var i:int = (endPos < this._endIndex) ? endPos: this._endIndex;
			
			/* special handling for last element in the word, bof */
			var specialHandling:Boolean = false;
			if ( i == this._endIndex ) {
				specialHandling = true;
				i = this._endIndex -1;
			}
			/* special handling for last element in the word, eof */
			
			while ( i > this._startIndex ) {
				var end:int = i;
				i = this._textBlock.findPreviousWordBoundary(end);
				var begin:int = ( i > this._startIndex) ? i : this._startIndex;
				
				/* special handling for last element in the word, bof */
				if ( specialHandling ) {
					end = (this._textBlock.findNextWordBoundary(begin)<this._endIndex) ?this._textBlock.findNextWordBoundary(begin):this._endIndex;
					specialHandling=false;
					if ( (end != this._endIndex) && !isSingleSpecialCharacter(this._textHolder.substring(this._endIndex-1,this._endIndex)) ) {
						begin = this._endIndex-1;
						i=begin;
						end = this._endIndex;
					} 
				}
				/* special handling for last element in the word, eof */
				
				if ( !isSingleSpecialCharacter( this._textHolder.substring(begin,end) ) ) {
					resultToken = new Token(begin,end);
					break;	
				}
			}
			if ( resultToken==null ) resultToken = this.getFirstToken();
			return resultToken;
		}
		
		private function isExceptionCharacter(word:String):Boolean {
			if ( word.length != 1 ) return false;
			if ( this._ignoredCharactersDict[word] == true ) return true;
			return false;
		}
		
		private function getNextFilteredTokenByIndex(startPos:int):Token {
			var token:Token = getNextTokenByIndex(startPos);
			var firstToken:Token = token;
			var cursor:int=token.last+1;
			
			while ( (cursor < this._endIndex) ) {
				if ( !isExceptionCharacter(this._textHolder.substring(cursor-1,cursor)) ) {
					break;
				}else {
					//another request from Harish about handling case abc\\abc abc\.abc case...not 100% sure about the correct behavior...
					/*bof*/
					while( cursor < this._endIndex && isExceptionCharacter(this._textHolder.substring(cursor-1,cursor)) ) {
						cursor++;
					}
					cursor--;
					/*eof*/
				}
				token = getNextTokenByIndex(cursor);
				if ( token.first != cursor ) {
					token = firstToken;
					break;
				}
				token.first=firstToken.first;
				firstToken = token;
				cursor = token.last+1;
			} 
			return token;
		}

		private function getPreviousFilteredTokenByIndex(endPos:int):Token {
			var token:Token = getPreviousTokenByIndex(endPos);
			var lastToken:Token = token;
			var cursor:int=token.first-1;
			
			while ( ( cursor > this._startIndex ) ) {
				if ( !isExceptionCharacter(this._textHolder.substring(cursor,cursor+1)) ) {
					break;
				}else {
					//another request from Harish about handling case abc\\abc abc\.abc case...not 100% sure about the correct behavior...
					/*bof*/
					while( cursor > this._startIndex && isExceptionCharacter(this._textHolder.substring(cursor,cursor+1)) ) {
						cursor--;
					}
					cursor++;
					/*eof*/
				}
				token = getPreviousTokenByIndex(cursor);
				if ( token.last != cursor ) {
					token = lastToken;
					break;
				}
				token.last=lastToken.last;
				lastToken = token;
				cursor = token.first-1;
			} 
			return token;
		}

		private function isSingleSpecialCharacter(word:String):Boolean{
			if ( word.length != 1 ) return false;
			if ( word.toLocaleLowerCase() == word.toLocaleUpperCase() ) return true;
			return false;
		}
		
		/** 
		 * Set all of ignored separators to this tokenizer class.
		 * 
		 * A vector of int containing all of ignored separators code point which are used by this class. 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		public function set ignoredSeparators(characters:Vector.<int>):void {
			if ( characters == null || characters.length==0 ) return;
			this._ignoredCharactersDict = new Dictionary();
			for ( var i:int =0;i<characters.length;++i) {
				this._ignoredCharactersDict[String.fromCharCode(characters[i])]=true;
			}
		}
		
		/**
		 * Get all of ignored separators used by this tokenizer class.
		 * 
		 * A vector of int containing all of ignored separators code point which are used by this class. 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		public function get ignoredSeparators():Vector.<int>{
			var result:Vector.<int> = new Vector.<int>();
			for ( var key:String in _ignoredCharactersDict) {
				result.push(key.charCodeAt(0) );
			}
			return result;
			
		}
		
		private function set ignoredCharacters(value:String ) :void {
			if( value == null || value == "" ) return;
			var charArr:Array = value.split("");
			this._ignoredCharactersDict = new Dictionary();
			for ( var i:int = 0;i< charArr.length;++i) {
				this._ignoredCharactersDict[charArr[i]]=true;
			}
		}
		
		private function get ignoredCharacters():String {
			var result:String = "";
			for ( var key:String in _ignoredCharactersDict) {
				result +=key;
			}
			return result;
		}
		
		/**
		 * The name of the requested locale ID that was passed to the constructor of this TextTokenizer object. 
		 * 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */	/*	
		public function get requestedLocaleIDName():String {
			return null;
		}
		
		
		/**
		 * The name of the actual locale ID used by this TextTokenizer object. 
		 * 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */	/*	
		public function get actualLocaleIDName():String {
			return null;
		}
		
		/**
		 * Lists all of the locale ID names supported by this class.
		 * 
		 * A vector of strings containing all of the locale ID names supported by this class. 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		/*
		public static function getAvailableLocaleIDNames():Vector.<String>{ return null;}
*/
		/**
		 * Return the first word in the text being scanned. 
		 * <p> NOTE: In a special case when there are no valid tokens in text, it returns a pseudo token having first and last index set to int.MAX_VALUE. As a result<code> firstToken().first </code>equals int.MAX_VALUE and<code> firstToken().last </code>equals int.MAX_VALUE.</p>
		 * 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		public function getFirstToken():Token {
			
			/* return the cached one. */
			if ( this._firstToken != null )
				return this._firstToken;
			
			/* calculate first token and return it. */
			//this._firstToken = getNextTokenByIndex(this._startIndex); // without any filter from LS, directly use FTE tokenizer...
			this._firstToken = getNextFilteredTokenByIndex(this._startIndex);

			return this._firstToken;
		}
		
		/**
		 * @private
		 * Return the last word in the text being scanned. 
		 * 
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		public function getLastToken():Token {
			/* return the cached one. */
			if ( this._lastToken != null )
				return this._lastToken;
				
			/* calculate last token and return it. */
			this._lastToken = new Token(int.MAX_VALUE,int.MAX_VALUE);
			return this._lastToken;
		}
		
		/**
		 * Determine the next word following the current token.  
		 * 
		 * <p>Returns the token of the next word.</p><p> NOTE: When there are no more valid tokens, it returns a pseudo token having first and last index set to int.MAX_VALUE. As a result<code> getNextToken().first </code>equals int.MAX_VALUE and<code> getNextToken().last </code>equals int.MAX_VALUE.</p>
		 * @param token A <code>Token</code> object to be used for determining next word.
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		public function getNextToken(token:Token):Token {
			//return getNextTokenByIndex(token.last); // without any filter from LS, directly use FTE tokenizer...
			return getNextFilteredTokenByIndex(token.last);
		}
		
		/**
		 * Determine the word preceding the current token.  
		 * 
		 * <p>Returns the token of the previous word or<code> getFirstToken </code>object if there is no preceding word.</p>
		 * @param token A <code>Token</code> object to be used for determining previous word.
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		public function getPreviousToken(token:Token):Token {
			//return getPreviousTokenByIndex( token.first );// without any filter from LS, directly use FTE tokenizer...
			return getPreviousFilteredTokenByIndex( token.first )
		}

	}
	
}