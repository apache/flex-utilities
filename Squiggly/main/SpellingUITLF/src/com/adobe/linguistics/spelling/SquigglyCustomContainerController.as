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
	import com.adobe.linguistics.spelling.SpellUIForTLF;
	import com.adobe.linguistics.spelling.framework.SpellingService;
	import com.adobe.linguistics.spelling.framework.ui.IHighlighter;
	import com.adobe.linguistics.spelling.framework.ui.IWordProcessor;
	import com.adobe.linguistics.spelling.framework.ui.TLFHighlighter;
	import com.adobe.linguistics.spelling.framework.ui.TLFWordProcessor;
	import com.adobe.linguistics.utils.TextTokenizer;
	import com.adobe.linguistics.utils.Token;
	
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import flashx.textLayout.compose.StandardFlowComposer;
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.elements.FlowLeafElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.CompositionCompleteEvent;
	import flashx.textLayout.events.StatusChangeEvent;
	import flashx.textLayout.tlf_internal;
	
	/** Custom container controller for populating context menu and hanlding menu item selection  */
	internal class SquigglyCustomContainerController extends ContainerController
	{
		private var disableMenuItem:ContextMenuItem = new ContextMenuItem("Disable spell checking",true);
		private var enableMenuItem:ContextMenuItem = new ContextMenuItem("Enable spell checking");		
		
		private var controlMenuItemList:Array = new Array();
		private var suggestionMenuItemList:Array = new Array();
		private var _spellingEnabled:Boolean;
		private var _contextMenu:ContextMenu;
		private var mTextHighlighter:IHighlighter;
		private var mWordProcessor:IWordProcessor;
		private var mSpellEngine:SpellingService;
		private var mTextFlow:TextFlow;
		private var _ignoreWordFunctionProcessor:Function;
		private var _misspelledToken:Token;
		private var _misspelled:String;
		
		public function SquigglyCustomContainerController(container:Sprite,textHighlighter:IHighlighter, wordProcessor:IWordProcessor, engine:SpellingService,
														  func:Function, compositionWidth:Number=100,compositionHeight:Number=100)
		{
			super (container, compositionWidth, compositionHeight);
			mTextHighlighter = textHighlighter;
			mWordProcessor = wordProcessor;
			mSpellEngine = engine;
			_ignoreWordFunctionProcessor = func;
			
			spellingEnabled = true;
		}
		
		/** Overridden to add custom items to the context menu */
		override protected function createContextMenu():ContextMenu
		{
			// Get the default context menu used by TLF for editable flows
			_contextMenu = super.container.contextMenu;
			if (_contextMenu == null)
				_contextMenu = super.createContextMenu();
				
			
			enableMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleEnableSpellCheck);
			disableMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleDisableSpellCheck);
			controlMenuItemList.push(enableMenuItem);
			controlMenuItemList.push(disableMenuItem);
			
			_contextMenu.customItems.push(disableMenuItem);
			_contextMenu.customItems.push(enableMenuItem);
			
			// Listen for menu selection
			_contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, updateCustomMenuItems);
			
			return _contextMenu;
		}
		
		/** Update the state of the custom menu items before the context menu is displayed */
		private function updateCustomMenuItems(event:ContextMenuEvent):void 
		{
			/* Clear the context menu */
			//spellingEnabled= mTextHighlighter.spellingEnabled;
			//SpellUI.doSpelling1();
			var removedNum:int = 0;
			var count:uint = _contextMenu.customItems.length;
			for (var j:uint=count; j>0; j--) {
				if ( isWordItem(_contextMenu.customItems[j-1]) ) {
					_contextMenu.customItems.splice(j-1,1);
					removedNum++
				}
			}
			if ( removedNum != suggestionMenuItemList.length ) {
				trace("internal error");
			}
			
			
			suggestionMenuItemList = new Array();
			
			// localized entries
			var entries:Object = SpellUIForTLF.getSpellingMenuEntries();
			disableMenuItem.caption = entries.disable;
			enableMenuItem.caption = entries.enable;				
			
			if (spellingEnabled == true) {
				(mWordProcessor as TLFWordProcessor).textFlowContainerController = this;
				
				//trace("stageX " +  super.container.stage.mouseX);
				//trace("stageY " +  super.container.stage.mouseY);
				//trace("mouseX " +  super.container.mouseX);
				//trace("mouseY " +  super.container.mouseY);
				_misspelledToken = mWordProcessor.getWordAtPoint(this.container.mouseX, this.container.mouseY);
				if (_misspelledToken==null) return;
				var currentLeaf:FlowLeafElement = this.textFlow.findLeaf(_misspelledToken.first);
				var currentParagraph:ParagraphElement = currentLeaf ? currentLeaf.getParagraph() : null;
				_misspelled = 	currentParagraph.getText().substring(_misspelledToken.first - currentParagraph.getAbsoluteStart(), 
																		_misspelledToken.last - currentParagraph.getAbsoluteStart());
				if ((_misspelled==null) || (_misspelled == "")) return;
				
				if (mSpellEngine.checkWord(_misspelled)==true) return;				
				
				var suseAddToItem:ContextMenuItem = new ContextMenuItem(entries.add);
				suseAddToItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleAddToItemSelect);
				suggestionMenuItemList.push(suseAddToItem);
				_contextMenu.customItems.splice(0,0,suseAddToItem);	
				//var result:Array = mWordProcessor.getSuggestionsAtPoint();
				var resultVector:Vector.<String> = mSpellEngine.getSuggestions(_misspelled);
				var result:Array = new Array();
				if (resultVector) {
					for each (var w:String in resultVector)
					result.push(w);
				}
				if (result!=null) {
					for (var i:int=result.length-1;i>=0;i-- ) {
						var suseMenuItem:ContextMenuItem = new ContextMenuItem(result[i]);
						suseMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleSuseItemSelect);
						suggestionMenuItemList.push(suseMenuItem);
						//_contextMenu.customItems.push(suseMenuItem);
						_contextMenu.customItems.splice(0,0,suseMenuItem);
					}
				}
			}
		}
		
		private function handleAddToItemSelect(event:ContextMenuEvent):void
		{
			if ( _ignoreWordFunctionProcessor == null ) return;
			
			/*
			var menuEntry:String = (event.currentTarget as ContextMenuItem).caption;
			var start:uint = 5;
			var end:uint = menuEntry.length - 15;
			var word:String = menuEntry.substring(start, end);
			*/
			_ignoreWordFunctionProcessor(_misspelled);
			SpellUIForTLF.UITable[SpellUIForTLF.parentComp[super.textFlow]].doSpellingJob();
		}
		
		private function handleSuseItemSelect(event:ContextMenuEvent):void
		{
			mWordProcessor.replaceText(_misspelledToken, (event.currentTarget as ContextMenuItem).caption );
			SpellUIForTLF.UITable[SpellUIForTLF.parentComp[super.textFlow]].doSpellingJob();
		}
			
		private function set spellingEnabled(value:Boolean) :void {
			_spellingEnabled = value;
			disableMenuItem.visible=spellingEnabled;
			enableMenuItem.visible=!spellingEnabled;
		}
		private function get spellingEnabled():Boolean {
			return this._spellingEnabled;
		}
		
		private function isWordItem(item:ContextMenuItem):Boolean {
			
			for ( var i:int=0; i<suggestionMenuItemList.length; ++i ) {
				if ( suggestionMenuItemList[i] == item ) return true;
			}
			return false;
		}
		
		private function isControlItem(item:ContextMenuItem):Boolean {
			for (var i:int=0; i<controlMenuItemList.length; ++i) {
				if ( controlMenuItemList[i] == item) return true;
			}
			return false;
		}
		
		private function handleEnableSpellCheck(event:ContextMenuEvent):void
		{
			spellingEnabled= true;
			//mTextHighlighter.spellingEnabled= spellingEnabled;
			//SpellUI.doSpellingJob();
			//dispatchEvent(new Event(Event.RENDER));
			
			SpellUIForTLF.UITable[SpellUIForTLF.parentComp[this.textFlow]].spellingEnabled = spellingEnabled;
			SpellUIForTLF.UITable[SpellUIForTLF.parentComp[this.textFlow]].doSpellingJob();
			//spellCheckRange(getValidFirstWordIndex(), getValidLastWordIndex());
		}
		private function handleDisableSpellCheck(event:ContextMenuEvent):void
		{
			spellingEnabled= false;
			SpellUIForTLF.UITable[SpellUIForTLF.parentComp[this.textFlow]].spellingEnabled = spellingEnabled;
			mTextHighlighter.clearSquiggles();
		}
		
		public function cleanUpContextMenu():void
		{
			mTextHighlighter=null;
			mWordProcessor=null;
			spellingEnabled = false;
			_ignoreWordFunctionProcessor=null;
			
			_contextMenu.removeEventListener(ContextMenuEvent.MENU_SELECT, updateCustomMenuItems);
			
			var removedNum:int = 0;
			var count:uint = _contextMenu.customItems.length;
			for (var j:uint=count; j>0; j--) {
				if ( isWordItem(_contextMenu.customItems[j-1]) || isControlItem(_contextMenu.customItems[j-1]) ) {
					_contextMenu.customItems.splice(j-1,1);
					removedNum++
				}
			}
			if ( removedNum != suggestionMenuItemList.length + controlMenuItemList.length ) {
				trace("internal error");
			}
			
			suggestionMenuItemList = null;
			controlMenuItemList = null;
		}
		
	}
}