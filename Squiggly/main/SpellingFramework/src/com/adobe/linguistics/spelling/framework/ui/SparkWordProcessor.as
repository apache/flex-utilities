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

package com.adobe.linguistics.spelling.framework.ui
{
	import com.adobe.linguistics.utils.ITokenizer;
	import com.adobe.linguistics.utils.TextTokenizer;
	import com.adobe.linguistics.utils.Token;
	
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.tlf_internal;
	
	import spark.components.RichEditableText;
	
	use namespace tlf_internal;	
	
	public class SparkWordProcessor implements IWordProcessor
	{
		private var mTextField:RichEditableText;

		public function SparkWordProcessor(textField:RichEditableText)
		{
			if (textField == null ) throw new Error("illegal argument."); 
			mTextField = textField;
		}
				
		
		public function replaceText(token:Token, replacement:String):void {
			var startIndex:int = token.first;
			var endIndex:int = token.last;
			
			var ta:RichEditableText = mTextField;
			var end:int = getValidLastWordIndex();
			
			if ( replacement == null ) return;
			
			if (mTextField.text.length<endIndex || startIndex<0) {
				return;
			}
			
			var _misspellStart:int = startIndex;
			var _misspellEnd:int = endIndex;
			
			// Workaround for Spark: changes in inactive components will trigger strange behavior			
			//var selectedElementRange:ElementRange = ElementRange.createElementRange(ta.textFlow, _misspellStart, _misspellEnd);
			//var selectedCharacterFormat:ITextLayoutFormat = ta.textFlow.interactionManager.activePosition == ta.textFlow.interactionManager.anchorPosition ? ta.textFlow.interactionManager.getCommonCharacterFormat() : selectedElementRange.characterFormat;
			//var selectedParagraphFormat:ITextLayoutFormat = selectedElementRange.paragraphFormat;
			//var selectedContainerFormat:ITextLayoutFormat = selectedElementRange.containerFormat;
			
			
			
			//var selectedCharacterFormat:ITextLayoutFormat = ta.textFlow.interactionManager.getCommonCharacterFormat();
			//var selectedContainerFormat:ITextLayoutFormat = ta.textFlow.interactionManager.getCommonContainerFormat();
			//var selectedParagraphFormat:ITextLayoutFormat = ta.textFlow.interactionManager.getCommonParagraphFormat();
			
			/*var tem:EditManager = new EditManager();
			ta.textFlow.interactionManager = tem;	*/
			
			
			ta.setFocus();
			//ta.text = ta.text.substr(0, _misspellStart) + replacement + ta.text.substr(_misspellEnd);
			
			//tem.applyFormat(selectedCharacterFormat,selectedParagraphFormat,selectedContainerFormat);
			//ta.textFlow.flowComposer.updateAllControllers();
			
			ta.textFlow;
			//ta.selectRange(_misspellStart + replacement.length, _misspellStart + replacement.length);
			ta.selectRange(_misspellStart+1, _misspellEnd);
			ta.insertText(replacement);
			ta.selectRange(_misspellStart, _misspellStart+1);
			ta.insertText("");
			
			//ta.textFlow.interactionManager.applyFormat(selectedCharacterFormat,null,null);
			
			// Workaround for unexpected jump
			ta.scrollToRange(end, end);
		}
		
		public function getWordAtPoint(x:uint, y:uint, externalTokenizer:ITokenizer=null):Token
		{
			// TODO: use a better alternative than _misspellStart, end
			var ta:RichEditableText = mTextField;	
			var index:int = SelectionManager.computeSelectionIndex(ta.textFlow, ta, ta, x, y);

			if (index >= ta.text.length) return null;

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

		// TODO: workaround for unexpected jump when word replaced, to be refactored for code sharing
		private function getValidLastWordIndex():int{
			var index:int = SelectionManager.computeSelectionIndex(mTextField.textFlow, mTextField, mTextField, mTextField.width+mTextField.horizontalScrollPosition, mTextField.height+mTextField.verticalScrollPosition);
			return index;
		}


	}
}