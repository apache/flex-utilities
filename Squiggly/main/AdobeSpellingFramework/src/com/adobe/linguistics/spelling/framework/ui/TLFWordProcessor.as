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
	import flashx.textLayout.edit.EditManager;
	import flashx.textLayout.tlf_internal;
	import flashx.textLayout.elements.TextFlow;
	
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.elements.FlowLeafElement;
	import flashx.textLayout.elements.ParagraphElement;
	
	use namespace tlf_internal;	
	
	public class TLFWordProcessor implements IWordProcessor
	{
		private var mTextFlow:TextFlow;
		private var _containerController:ContainerController;

		public function TLFWordProcessor(textFlow:TextFlow)
		{
			if (textFlow == null ) throw new Error("illegal argument."); 
			mTextFlow = textFlow;
		}
				
		
		public function replaceText(token:Token, replacement:String):void {
			var startIndex:int = token.first;
			var endIndex:int = token.last;
			
			var ta:TextFlow = mTextFlow;
			//var end:int = getValidLastWordIndex();
			
			if ( replacement == null ) return;
			
			/*if (mTextFlow.text.length<endIndex || startIndex<0) {
				return;
			}*/
			
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
			
			var tem:EditManager = ta.interactionManager as EditManager;
			
			
			
			//ta.setFocus();
			//ta.text = ta.text.substr(0, _misspellStart) + replacement + ta.text.substr(_misspellEnd);
			
			//tem.applyFormat(selectedCharacterFormat,selectedParagraphFormat,selectedContainerFormat);
			//ta.textFlow.flowComposer.updateAllControllers();
			
			//ta.textFlow;
			//ta.selectRange(_misspellStart + replacement.length, _misspellStart + replacement.length);
			
			
			tem.selectRange(_misspellStart+1, _misspellEnd);
			tem.insertText(replacement);
			tem.selectRange(_misspellStart, _misspellStart+1);
			tem.insertText("");
			
			//ta.textFlow.interactionManager.applyFormat(selectedCharacterFormat,null,null);
			
			// Workaround for unexpected jump
			//ta.scrollToRange(end, end);
		}
		
		/**
		 @private
		 (This property is for Squiggly Developer use only.)
		 */
		public function set textFlowContainerController(value:ContainerController):void {
			_containerController = value;
		}
		
		public function getWordAtPoint(x:uint, y:uint, externalTokenizer:ITokenizer=null):Token
		{
			// TODO: use a better alternative than _misspellStart, end
			var ta:TextFlow = mTextFlow;	
									
			var index:int = SelectionManager.computeSelectionIndex(ta, _containerController.container, _containerController.container, x, y);

			if (index >= ta.textLength) return null;

			var currentLeaf:FlowLeafElement = ta.findLeaf(index);
			var currentParagraph:ParagraphElement = currentLeaf ? currentLeaf.getParagraph() : null;
			
			var paraStart:uint = currentParagraph.getAbsoluteStart();
				
			//tokenizer = new TextTokenizer(currentParagraph.getText().substring());
			
			var tmpToken:Token = new Token(index - paraStart,index - paraStart);
			var tokenizer:ITokenizer;
			if ( externalTokenizer == null ) {
				tokenizer = new TextTokenizer(currentParagraph.getText().substring());	
			}else {
				tokenizer = externalTokenizer;
			}
			
			var result:Token = new Token(0,0);
			var preToken:Token = tokenizer.getPreviousToken(tmpToken);
			var nextToken:Token = tokenizer.getNextToken(tmpToken);
			if ( preToken.last == nextToken.first ) {
				result.first = preToken.first + paraStart;
				result.last = nextToken.last + paraStart;
				return result;		
			}else {
				return null;
			}
							
		}

		// TODO: workaround for unexpected jump when word replaced, to be refactored for code sharing
		private function getValidLastWordIndex():int{
			var index:int = 0;
			//var index:int = SelectionManager.computeSelectionIndex(mTextFlow.textFlow, mTextFlow, mTextFlow, mTextFlow.width+mTextFlow.horizontalScrollPosition, mTextFlow.height+mTextFlow.verticalScrollPosition);
			return index;
		}


	}
}