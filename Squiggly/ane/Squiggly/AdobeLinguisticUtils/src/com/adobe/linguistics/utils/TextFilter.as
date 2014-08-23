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

/* 
* ToDo: Create ASDoc style comment to generate the API document.
*/
package com.adobe.linguistics.utils
{
	/**
	 * <p>This class provides some methods to filter out certain characters from the text.</p>
	 */
	public class TextFilter
	{
		public static const kTextChar_DiscretionaryHyphen:int 	= 0x00AD;
		public static const kTextChar_BreakRunInStyle:int		= 0x0003;
		public static const kTextChar_IndentToHere:int 			= 0x0007;
		public static const kTextChar_InvisibleSeparator:int 	= 0x2063;
		public static const kTextChar_ZeroWidthNonJoiner:int 	= 0x200C;
		public static const kTextChar_ZeroWidthJoiner:int		= 0x200D;
		public static const kTextChar_ZeroSpaceBreak:int 		= 0x200B;
		public static const kTextChar_ZeroSpaceNoBreak:int		= 0xFEFF;
		public static const kTextChar_RightSingleQuotationMark:int = 0x2019;
		public static const kTextChar_Apostrophe:int			= 0x0027;
		public static const kTextChar_NoBreakHyphen:int			= 0x2011;
		public static const kTextChar_UnicodeHyphen:int			= 0x2010;
		public static const kTextChar_HyphenMinus:int			= 0x002D;

		
		public function TextFilter()
		{
		}
		
		public function filterWord(inpWord:String):String
		{
			return replaceIgnoredCharacter((removeIgnoredCharacter(inpWord)));	
		}
		private function removeIgnoredCharacter(inpWord:String):String
		{
			if(!inpWord || inpWord.length<=0) 
				return inpWord;
			
			var tempWord:String= new String;

			for(var i:int=0; i< inpWord.length; i++)
			{
				if (   inpWord.charCodeAt(i)==kTextChar_DiscretionaryHyphen
					|| inpWord.charCodeAt(i)==kTextChar_BreakRunInStyle
					|| inpWord.charCodeAt(i)==kTextChar_IndentToHere
					|| inpWord.charCodeAt(i)==kTextChar_InvisibleSeparator
					|| inpWord.charCodeAt(i)==kTextChar_ZeroWidthNonJoiner
					|| inpWord.charCodeAt(i)==kTextChar_ZeroWidthJoiner
					|| inpWord.charCodeAt(i)==kTextChar_ZeroSpaceBreak
					|| inpWord.charCodeAt(i)==kTextChar_ZeroSpaceNoBreak
					)
				continue;
				
				tempWord=tempWord+inpWord.charAt(i); 
			}
			return tempWord;		
		}
		
		private function replaceIgnoredCharacter(inpWord:String):String
		{
			for(var i:int=0; inpWord && i<inpWord.length; i++)
			{
				if(inpWord.charCodeAt(i)==kTextChar_RightSingleQuotationMark)
					inpWord= inpWord.slice(0,i)+String.fromCharCode(kTextChar_Apostrophe)+inpWord.slice(i+1);
				else if(inpWord.charCodeAt(i)==kTextChar_NoBreakHyphen || inpWord.charCodeAt(i)==kTextChar_UnicodeHyphen)
					inpWord= inpWord.slice(0,i)+String.fromCharCode(kTextChar_HyphenMinus)+inpWord.slice(i+1);;
			}
			return inpWord;
		}
	}
}