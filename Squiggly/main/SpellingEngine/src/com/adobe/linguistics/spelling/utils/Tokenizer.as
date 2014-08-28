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





package com.adobe.linguistics.spelling.utils
{

	import com.adobe.linguistics.spelling.utils.Token;
		
	public class Tokenizer
	{
		private var _data:String;
		private var _current:uint;

		public function Tokenizer(inText:String)
		{
			_data = inText;
			_current = 0;
		}
		public function next():Token
		{
			var first:uint;
			var last:uint;
			
			if (_current==_data.length) return null;
			while (isSeparator(_data.charAt(_current))) {
				_current++;
				if (_current==_data.length) return null;
			}
			first = _current;
			while (!isSeparator(_data.charAt(_current))) {
				_current++;
				if (_current==_data.length) break;
			}
			last = _current;
			
			// Special handling for single quote
			var charFirst:Number = _data.charCodeAt(first);
			var charLast:Number = _data.charCodeAt(last-1);
			if ((charFirst == 39) || (charFirst == 0x2018) || (charFirst == 0x2019)) first++;
			if ((charLast == 39) || (charLast == 0x2018) || (charLast == 0x2019)) last--;
			
			return new Token(first, last);	
		}
		
		private static var allValidChars:Array = [
			{startingChar:65, endingChar:90}, /*Basic Latin bof */
			{startingChar:97, endingChar:122},/*Basic Latin eof */
			{startingChar:39, endingChar:39}, /* "'" character*/
			{startingChar:0x2018, endingChar:0x2019}, /* "‘" and "’" character*/
			{startingChar:192, endingChar:214},/* Latin-1 supplement  bof */
			{startingChar:216, endingChar:246},
			{startingChar:248, endingChar:255},/* Latin-1 supplement  eof */
			{startingChar:256, endingChar:383},/* Lating Extended-A bof-eof    European Latin*/
			{startingChar:384, endingChar:447}, /* Latin extended-B bof-eof */
			{startingChar:48, endingChar:57}, /* number */
			{startingChar:536, endingChar:537} /* "ş" character, for romanian */
		];
		private static function isValidCharacter( inChar:int ) :Boolean {
			for ( var i:int = 0; i < allValidChars.length; ++i ) {
				if ( (inChar >= allValidChars[i].startingChar) && (inChar <= allValidChars[i].endingChar) )
					return true; 
			}
			return false;
		} 
		
		public static function isSeparator(inChar:String):Boolean
		{	
			var ccode:Number = inChar.charCodeAt();
			if ( isValidCharacter( ccode ) )
				return false;
			return true;
		}

	}
	
}