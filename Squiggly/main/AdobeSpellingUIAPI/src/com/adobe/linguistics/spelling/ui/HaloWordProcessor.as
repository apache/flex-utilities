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

package com.adobe.linguistics.spelling.ui
{
	import com.adobe.linguistics.utils.ITokenizer;
	import com.adobe.linguistics.utils.TextTokenizer;
	import com.adobe.linguistics.utils.Token;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.controls.TextArea;
	import mx.controls.TextInput;


	public class HaloWordProcessor implements IWordProcessor
	{
		private var mTextField:TextField;

		public function HaloWordProcessor(textField:TextField)
		{
			if (textField == null ) throw new Error("illegal argument."); 
			mTextField = textField;
		}

		
		public function replaceText(startIndex:int, endIndex:int, replacement:String):void {
			
			if ( replacement == null ) return;
			
			if (mTextField.text.length<endIndex || startIndex<0) {
				return;
			}
			
			var _misspellStart:int = startIndex;
			var _misspellEnd:int = endIndex;
			// Try to preserve the format, this works if the whole misspelled word is the same format
			var tf:TextFormat = mTextField.getTextFormat(_misspellStart, _misspellEnd);
			mTextField.replaceText(_misspellStart, _misspellEnd, replacement);	
			mTextField.setTextFormat(tf, _misspellStart, _misspellStart+replacement.length);
			
			var ta:TextArea = mTextField.parent as TextArea;
			var ti:TextInput = mTextField.parent as TextInput;
			
			if (ta != null) {
				ta.selectionBeginIndex = _misspellStart + replacement.length;
				ta.selectionEndIndex = _misspellStart + replacement.length;
			}
			else if (ti != null) {
				ti.selectionBeginIndex = _misspellStart + replacement.length;
				ti.selectionEndIndex = _misspellStart + replacement.length;				
			}
			else {
				// Do nothing if it's not a valid text component
			}
		}


		public function getWordAtPoint(x:uint, y:uint, externalTokenizer:ITokenizer=null):Token
		{
			var _token:Token = tryGetWordAtPoint(x,y, externalTokenizer);
			return _token;
		}
		
		private function tryGetWordAtPoint(x:uint, y:uint, externalTokenizer:ITokenizer=null):Token {
			// TODO: use a better alternative than _misspellStart, end
			var index:uint = mTextField.getCharIndexAtPoint(x + mTextField.scrollH, y);
			if (index >= mTextField.text.length) return null;

			var tmpToken:Token = new Token(index,index);
			var tokenizer:ITokenizer;
			if ( externalTokenizer == null ) {
				tokenizer = new TextTokenizer(mTextField.text);	
			}else {
				tokenizer = externalTokenizer;
			}
			
			var result:Token = new Token(0,0);
			
			var preToken:Token = tokenizer.getPreviousToken(tmpToken);
			var nextToken:Token = tokenizer.getNextToken(tmpToken);
			if ( preToken.last == nextToken.first ) {
				result.first = preToken.first;
				result.last = nextToken.last;
				return result;		
			}else {
				return null;
			}
		}

	}
}