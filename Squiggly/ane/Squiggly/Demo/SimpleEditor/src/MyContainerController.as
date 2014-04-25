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

package {
	import com.adobe.linguistics.spelling.SpellUIForTLF;
	import com.adobe.linguistics.spelling.framework.SpellingService;
	import com.adobe.linguistics.spelling.ui.IHighlighter;
	import com.adobe.linguistics.spelling.ui.IWordProcessor;
	import com.adobe.linguistics.spelling.ui.TLFWordProcessor;
	import com.adobe.linguistics.utils.TextFilter;
	import com.adobe.linguistics.utils.Token;
	import flash.net.SharedObject;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import flashx.textLayout.compose.StandardFlowComposer;
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.IEditManager;
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.elements.FlowLeafElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.CompositionCompleteEvent;
	import flashx.textLayout.events.StatusChangeEvent;
	import flashx.undo.IUndoManager;
	
	class MyContainerController extends ContainerController
	{

		public function MyContainerController(container:Sprite,compositionWidth:Number=100,compositionHeight:Number=100)
		{
			super (container, compositionWidth, compositionHeight);
			spellingEnabled=false;
			_textFilter= new TextFilter();
		}
		
		/** Overridden to add custom items to the context menu */
		override protected function createContextMenu():ContextMenu
		{
			// Get the default context menu used by TLF for editable flows
			contextMenu= super.createContextMenu();
			
			// Listen for menu selection
			contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, updateCustomMenuItems);
			
			// Add custom menu items
			_undoItem = new ContextMenuItem("[Undo]"); // for illustration only; not "undo" caption is not allowed 
			_undoItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, undo);
			contextMenu.customItems.push(_undoItem);
			
			_redoItem = new ContextMenuItem("[Redo]");
			_redoItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, redo);
			contextMenu.customItems.push(_redoItem);
			
			_enableSpelling= new ContextMenuItem("[Enable Spelling]");
			_enableSpelling.visible=!spellingEnabled;
			_enableSpelling.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, enableSpelling);
			contextMenu.customItems.push(_enableSpelling);
			
			_disableSpelling= new ContextMenuItem("[Disable Spelling]");
			_disableSpelling.visible=spellingEnabled;
			_disableSpelling.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, disableSpelling);
			contextMenu.customItems.push(_disableSpelling);
			
			return contextMenu;
		}
		
		/** Update the state of the custom menu items before the context menu is displayed */
		private function updateCustomMenuItems(event:ContextMenuEvent):void 
		{
			var removedNum:int = 0;
			var count:uint = contextMenu.customItems.length;
			for (var j:uint=count; j>0; j--) {
				if ( isWordItem(contextMenu.customItems[j-1]) ) {
					contextMenu.customItems.splice(j-1,1);
					removedNum++
				}
			}
			if ( removedNum != suggestionMenuItemList.length ) {
				//trace("internal error");
			}
			
			var undoManager:IUndoManager = (textFlow.interactionManager as IEditManager).undoManager;
			_undoItem.enabled = undoManager.canUndo();
			_redoItem.enabled = undoManager.canRedo();
			//-->>>
			if(!SpellUIForTLF.UITable[textFlow])
			{
				spellingEnabled=false;
				updateVisibility();
			}
			else
			{
				spellingEnabled= SpellUIForTLF.UITable[textFlow].spellingEnabled;
				updateVisibility();
				if(!mWordProcessor)
					mWordProcessor=SpellUIForTLF.getWordProcessor(textFlow);
				if(!mSpellEngine)
					mSpellEngine=SpellUIForTLF.getSpellingService(textFlow);
				if(!mAddToDictionaryFunction)
					mAddToDictionaryFunction= SpellUIForTLF.getAddToDictionaryFunction(textFlow);
				if(!mRemoveFromDictionaryFunction)
					mRemoveFromDictionaryFunction= SpellUIForTLF.getRemoveFromDictionaryFunction(textFlow);
				if(!mGetWordListFunction)
					mGetWordListFunction=SpellUIForTLF.getWordListFunction(textFlow);
				if(mWordProcessor==null || mSpellEngine==null) 
					return;
				  migrateWordsR4();
				(mWordProcessor as TLFWordProcessor).textFlowContainerController = this;
					
					//trace("stageX " +  super.container.stage.mouseX);
					//trace("stageY " +  super.container.stage.mouseY);
					//trace("mouseX " +  super.container.mouseX);
					//trace("mouseY " +  super.container.mouseY);
					_misspelledToken = mWordProcessor.getWordAtPoint(this.container.mouseX, this.container.mouseY);
					if (_misspelledToken==null) return;
					var currentLeaf:FlowLeafElement = this.textFlow.findLeaf(_misspelledToken.first);
					var currentParagraph:ParagraphElement = currentLeaf ? currentLeaf.getParagraph() : null;
					_misspelled = currentParagraph?	currentParagraph.getText().substring(_misspelledToken.first - currentParagraph.getAbsoluteStart(), 
						_misspelledToken.last - currentParagraph.getAbsoluteStart()) : null;
					if ((_misspelled==null) || (_misspelled == "")) return;
					
					_filteredMisspelled= _textFilter.filterWord(_misspelled);
					if (mSpellEngine.checkWord(_filteredMisspelled)==true) return;				
					
					var suseAddToItem:ContextMenuItem = new ContextMenuItem("[Add to Dictionary]");
					suseAddToItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleAddToItemSelect);
					suggestionMenuItemList.push(suseAddToItem);
					contextMenu.customItems.splice(0,0,suseAddToItem);	
					
					suseAddToItem = new ContextMenuItem("[Add to AllLang Dictionary]");
					suseAddToItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleAddAllLanguageWords);
					suggestionMenuItemList.push(suseAddToItem);
					contextMenu.customItems.splice(0,0,suseAddToItem);
					
					suseAddToItem = new ContextMenuItem("[Remove Word]");
					suseAddToItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, removeWord);
					suggestionMenuItemList.push(suseAddToItem);
					contextMenu.customItems.splice(0,0,suseAddToItem);
					
					
					suseAddToItem = new ContextMenuItem("[Trace All Words]");
					suseAddToItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, printTraces);
					suggestionMenuItemList.push(suseAddToItem);
					contextMenu.customItems.splice(0,0,suseAddToItem);	
					
					//var result:Array = mWordProcessor.getSuggestionsAtPoint();
					var resultVector:Vector.<String> = mSpellEngine.getSuggestions(_filteredMisspelled);
					var result:Array = new Array();
					if (resultVector) {
						for each (var w:String in resultVector)
						{
							if(w.length >3) result.push(toInitCap(w));	
						}
						
					}
					if (result!=null) {
						for (var i:int=result.length-1;i>=0;i-- ) {
							var suseMenuItem:ContextMenuItem = new ContextMenuItem(result[i]);
							suseMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleSuseItemSelect);
							suggestionMenuItemList.push(suseMenuItem);
							//_contextMenu.customItems.push(suseMenuItem);
							contextMenu.customItems.splice(0,0,suseMenuItem);
						}
					}
			}
				//--->
		}
		
		private function undo(event:ContextMenuEvent):void 
		{
			(textFlow.interactionManager as IEditManager).undoManager.undo();
		}
		
		private function redo(event:ContextMenuEvent):void 
		{
			(textFlow.interactionManager as IEditManager).undoManager.redo();
		}
		
		private function enableSpelling(event:ContextMenuEvent):void{
			SpellUIForTLF.enableSpelling(textFlow,_language);//TODO: Pass language from main application here...remove hard code
			spellingEnabled= SpellUIForTLF.UITable[textFlow].spellingEnabled;
			updateVisibility();
		}
		
		private function disableSpelling(event:ContextMenuEvent):void{
			SpellUIForTLF.disableSpelling(textFlow);
			setFuncsNull();
			spellingEnabled= false;
			updateVisibility();
		}
		private function updateVisibility():void{
			_enableSpelling.visible=!spellingEnabled;
			_disableSpelling.visible=spellingEnabled;
		}
		
		private function handleAddToItemSelect(event:ContextMenuEvent):void{
			mAddToDictionaryFunction(_misspelled,_language);
			
		}
		

		
		private function printTraces(event:ContextMenuEvent):void{
			var arr:Array=mGetWordListFunction(_language);
			if(!arr) return;
			for each( var k:String in arr)
				trace(k);
		}
		
		private function removeWord(event:ContextMenuEvent):void{
			mRemoveFromDictionaryFunction("woodoo",_language);
		}
		private function handleSuseItemSelect(event:ContextMenuEvent):void
		{
			mWordProcessor.replaceText(_misspelledToken, (event.currentTarget as ContextMenuItem).caption );
			SpellUIForTLF.UITable[textFlow].doSpellingJob();
		}
		private function isWordItem(item:ContextMenuItem):Boolean {
			
			for ( var i:int=0; i<suggestionMenuItemList.length; ++i ) {
				if ( suggestionMenuItemList[i] == item ) return true;
			}
			return false;
		}
		private function toInitCap(w:String):String{
			return w.substr(0,1).toLocaleUpperCase()+w.substr(1);
		}
		private function handleAddAllLanguageWords(event:ContextMenuEvent):void{
			mAddToDictionaryFunction(_misspelled,"lang_neutral");
		}
		
		public function get language():String
		{
			return _language;
		}
		
		public function set language(value:String):void
		{
			_language = value;
		}
		public function setFuncsNull():void
		{
			mAddToDictionaryFunction=null;
			mSpellEngine=null;
			mHighlighter=null;
			mGetWordListFunction=null;
			mRemoveFromDictionaryFunction=null;
			mWordProcessor=null;
		}
		
		private function migrateWordsR4():void{
			var sharedObjectOld:SharedObject= SharedObject.getLocal("Squiggly_v03");
			var vec:Vector.<String> = new Vector.<String>();
			if (sharedObjectOld.data.ud) {
				for each (var w:String in sharedObjectOld.data.ud)
				mAddToDictionaryFunction(w, "lang_neutral");
			}
		}
		private var _undoItem:ContextMenuItem;
		private var _redoItem:ContextMenuItem;
		private var _enableSpelling:ContextMenuItem;
		private var _disableSpelling:ContextMenuItem;
		private var mHighlighter:IHighlighter =null;
		private var mWordProcessor:IWordProcessor=null;
		private var mSpellEngine:SpellingService= null;
		private var mAddToDictionaryFunction:Function=null;
		private var mRemoveFromDictionaryFunction:Function=null;
		private var mGetWordListFunction:Function=null;
		private var _misspelledToken:Token=null;
		private var _misspelled:String;
		private var _filteredMisspelled:String;
		private var suggestionMenuItemList:Array = new Array();
		private var contextMenu:ContextMenu=null;
		private var spellingEnabled:Boolean;
		private var _textFilter:TextFilter=null;
		private var _language:String;
		
	}
}