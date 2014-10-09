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
	import com.adobe.linguistics.spelling.SquigglyCustomContainerController;
	import com.adobe.linguistics.spelling.framework.SpellingService;
	import com.adobe.linguistics.spelling.framework.ui.IHighlighter;
	import com.adobe.linguistics.spelling.framework.ui.IWordProcessor;
	import com.adobe.linguistics.spelling.framework.ui.TLFHighlighter;
	import com.adobe.linguistics.spelling.framework.ui.TLFWordProcessor;
	import com.adobe.linguistics.utils.TextTokenizer;
	import com.adobe.linguistics.utils.Token;
	
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
		
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
	
	
	use namespace tlf_internal;	
	
	public class SpellingContextMenuForTLF
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
		public function SpellingContextMenuForTLF(textHighlighter:IHighlighter, wordProcessor:IWordProcessor, engine:SpellingService, actualParent:*, func:Function)
		{
			
			if ( textHighlighter == null || wordProcessor == null ||  engine == null) throw new Error("illegal argument."); 
			mTextHighlighter = textHighlighter;
			mWordProcessor = wordProcessor;
			mSpellEngine = engine;
			mTextFlow = actualParent;
			
			
			var numControllers:int = mTextFlow.flowComposer.numControllers;
			for (var idx:int = 0; idx < numControllers; idx++)
			{	
				var containerController:ContainerController = mTextFlow.flowComposer.getControllerAt(idx);
				var squigglyContainerController:SquigglyCustomContainerController = new SquigglyCustomContainerController(containerController.container, mTextHighlighter, mWordProcessor, 
																								mSpellEngine, func, containerController.compositionWidth, containerController.compositionHeight);	
				copyObject(containerController, squigglyContainerController);
				mTextFlow.flowComposer.removeController(containerController);
				containerController = null; // make it null so that the associated memory is garbage collected
				mTextFlow.flowComposer.addControllerAt(squigglyContainerController, idx);
				
			}
			mTextFlow.flowComposer.updateAllControllers();
			
			
			spellingEnabled = true; //default value
			//spellingEnabled= mTextHighlighter.spellingEnabled;
			
			_ignoreWordFunctionProcessor=null;
		}
		
		/**
		 * copies a source object to a destination object
		 * @param sourceObject the source object
		 * @param destinationObject the destination object
		 *
		 */
		private function copyObject(sourceObject:ContainerController, destinationObject:SquigglyCustomContainerController):void
		{
			// check if the objects are not null
			if((sourceObject) && (destinationObject)) {
				try
				{
					//retrive information about the source object via XML
					var sourceInfo:XML = describeType(sourceObject);
					var objectProperty:XML;
					var propertyName:String;
					
					// loop through the properties
					for each(objectProperty in sourceInfo.variable)
					{
						propertyName = objectProperty.@name;
						if(sourceObject[objectProperty.@name] != null)
						{
							if(destinationObject.hasOwnProperty(objectProperty.@name)) {
								destinationObject[objectProperty.@name] = sourceObject[objectProperty.@name];
							}
						}
					}
					//loop through the accessors
					for each(objectProperty in sourceInfo.accessor) {
						if(objectProperty.@access == "readwrite") {
							propertyName = objectProperty.@name;
							if(sourceObject[objectProperty.@name] != null)
							{
								if(destinationObject.hasOwnProperty(objectProperty.@name)) {
									destinationObject[objectProperty.@name] = sourceObject[objectProperty.@name];
								}
							}
						}
					}
				}
				catch (err:*) {
					;
				}
			}
		}
		
		public function cleanUp():void
		{
			mTextHighlighter=null;
			mWordProcessor=null;
			spellingEnabled = false;
			_ignoreWordFunctionProcessor=null;
			
			var numControllers:int = mTextFlow.flowComposer.numControllers;
			for (var idx:int = 0; idx < numControllers; idx++)
			{	
				 //if (getQualifiedClassName(mTextFlow.flowComposer.getControllerAt(idx)) == "SquigglyCustomContainerController"){
					 var containerController:ContainerController = mTextFlow.flowComposer.getControllerAt(idx);
					 //Use try-catch incase some controller not of type SquigglyCustomContainerController comes across
					 try {
					 (containerController as SquigglyCustomContainerController).cleanUpContextMenu();
					 }
					 catch (err:Error)
					 {
						 // TODO: error handling here
					 }
				 //}
				
			}
			
		}
		
		public function get contextMenu():ContextMenu {
			return this._contextMenu;
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
			SpellUIForTLF.UITable[SpellUIForTLF.parentComp[mTextFlow]].doSpellingJob();
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
			SpellUIForTLF.UITable[SpellUIForTLF.parentComp[mTextFlow]].doSpellingJob();
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
			
			SpellUIForTLF.UITable[SpellUIForTLF.parentComp[mTextFlow]].spellingEnabled = spellingEnabled;
			SpellUIForTLF.UITable[SpellUIForTLF.parentComp[mTextFlow]].doSpellingJob();
			//spellCheckRange(getValidFirstWordIndex(), getValidLastWordIndex());
		}
		private function handleDisableSpellCheck(event:ContextMenuEvent):void
		{
			spellingEnabled= false;
			SpellUIForTLF.UITable[SpellUIForTLF.parentComp[mTextFlow]].spellingEnabled = spellingEnabled;
			mTextHighlighter.clearSquiggles();
		}
				
	}
}
