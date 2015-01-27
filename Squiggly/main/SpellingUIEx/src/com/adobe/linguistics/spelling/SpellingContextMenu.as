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
	import com.adobe.linguistics.spelling.SpellUI;
	import com.adobe.linguistics.spelling.framework.SpellingService;
	import com.adobe.linguistics.spelling.framework.ui.*;
	import com.adobe.linguistics.utils.Token;
	import com.adobe.linguistics.utils.TextTokenizer;
	
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import flash.text.TextField;
	import mx.core.UIComponent;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class SpellingContextMenu
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
		private var mParentTextField:*;
		private var _ignoreWordFunctionProcessor:Function;
		private var _misspelledToken:Token;
		private var _misspelled:String;
		public function SpellingContextMenu(textHighlighter:IHighlighter, wordProcessor:IWordProcessor, engine:SpellingService, actualParent:*, contextMenu:ContextMenu=null)
		{
			
			if ( textHighlighter == null || wordProcessor == null ||  engine == null) throw new Error("illegal argument."); 
			mTextHighlighter = textHighlighter;
			mWordProcessor = wordProcessor;
			mSpellEngine = engine;
			mParentTextField = actualParent;
			if (contextMenu != null) {
				_contextMenu =contextMenu;
			}else {
				_contextMenu = new ContextMenu();
			}
			enableMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleEnableSpellCheck);
			disableMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, handleDisableSpellCheck);
			controlMenuItemList.push(enableMenuItem);
			controlMenuItemList.push(disableMenuItem);
			
			_contextMenu.customItems.push(disableMenuItem);
			_contextMenu.customItems.push(enableMenuItem);
			spellingEnabled = true; //default value
			//spellingEnabled= mTextHighlighter.spellingEnabled;
			_contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, handleContextMenuSelect);
			_ignoreWordFunctionProcessor=null;
		}
		
		public function cleanUp():void
		{
			mTextHighlighter=null;
			mWordProcessor=null;
			spellingEnabled = false;
			_ignoreWordFunctionProcessor=null;
			
			_contextMenu.removeEventListener(ContextMenuEvent.MENU_SELECT, handleContextMenuSelect);
			
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
		
		public function get contextMenu():ContextMenu {
			return this._contextMenu;
		}

		private function handleContextMenuSelect(event:ContextMenuEvent):void
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
			var entries:Object = SpellUI.getSpellingMenuEntries();
			disableMenuItem.caption = entries.disable;
			enableMenuItem.caption = entries.enable;				

			if (spellingEnabled == true) {
				_misspelledToken = mWordProcessor.getWordAtPoint(mParentTextField.mouseX, mParentTextField.mouseY);
				if (_misspelledToken==null) return;
				_misspelled = 	mParentTextField.text.substring(_misspelledToken.first, _misspelledToken.last);
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
		
		public function setIgnoreWordCallback(func:Function ) :void {
			if ( func != null )
			_ignoreWordFunctionProcessor = func;
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
			//SpellUI.UITable[SpellUI.parentComp[mParentTextField]].doSpellingJob();
			//now implicitly calling dospelling on all text areas
			for each (var tempUIComponent:SpellUI in SpellUI.UITable)
			{
				tempUIComponent.doSpellingJob();
			}
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

		private function handleSuseItemSelect(event:ContextMenuEvent):void
		{
			mWordProcessor.replaceText(_misspelledToken, (event.currentTarget as ContextMenuItem).caption );
			SpellUI.UITable[SpellUI.parentComp[mParentTextField]].doSpellingJob();
		}

		
		private function set spellingEnabled(value:Boolean) :void {
			_spellingEnabled = value;
			disableMenuItem.visible=spellingEnabled;
			enableMenuItem.visible=!spellingEnabled;
		}
		private function get spellingEnabled():Boolean {
			return this._spellingEnabled;
		}
		private function handleEnableSpellCheck(event:ContextMenuEvent):void
		{
			spellingEnabled= true;
			//mTextHighlighter.spellingEnabled= spellingEnabled;
			//SpellUI.doSpellingJob();
			//dispatchEvent(new Event(Event.RENDER));
			
			SpellUI.UITable[SpellUI.parentComp[mParentTextField]].spellingEnabled = spellingEnabled;
			SpellUI.UITable[SpellUI.parentComp[mParentTextField]].doSpellingJob();
			//spellCheckRange(getValidFirstWordIndex(), getValidLastWordIndex());
		}
		private function handleDisableSpellCheck(event:ContextMenuEvent):void
		{
			spellingEnabled= false;
			SpellUI.UITable[SpellUI.parentComp[mParentTextField]].spellingEnabled = spellingEnabled;
			mTextHighlighter.clearSquiggles();
		}
				
	}
}