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
	import com.adobe.linguistics.spelling.UserDictionary;
	import com.adobe.linguistics.spelling.framework.ResourceTable;
	import com.adobe.linguistics.spelling.framework.SpellingConfiguration;
	import com.adobe.linguistics.spelling.framework.SpellingService;
    import com.adobe.linguistics.spelling.framework.ui.HaloHighlighter;
    import com.adobe.linguistics.spelling.framework.ui.IHighlighter;
    import com.adobe.linguistics.spelling.framework.ui.SparkHighlighter;
    import com.adobe.linguistics.spelling.framework.ui.HaloWordProcessor;
    import com.adobe.linguistics.spelling.framework.ui.IWordProcessor;
    import com.adobe.linguistics.spelling.framework.ui.SparkWordProcessor;
	import com.adobe.linguistics.utils.TextTokenizer;
	import com.adobe.linguistics.utils.Token;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import mx.controls.RichTextEditor;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.ScrollEvent;
	
	import spark.components.RichEditableText;
	import spark.components.TextArea;
	import spark.components.TextInput;
	
	import flashx.textLayout.tlf_internal;
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.elements.TextFlow;
	
	use namespace mx_internal;
	
	use namespace tlf_internal;	
	/**
	 * UI implementation for spelling.
	 *
	 * <p>This class is a simple UI for some standard Flex UI components.
	 *	It is not intended to address a complete user interface.
	 *	Instead, it presents a basic user interface for some commonly used Flex UI components.</p>
	 *
	 * <p>For advanced text editing applications, more complex features are likely required.
	 *	For those applications, we recommend bypassing this class and utilizing the <code>SpellChecker</code> class directly.</p>
	 *
	 * @playerversion Flash 10
	 * @langversion 3.0
	 */
	public class SpellUI
	{
		private var hh:IHighlighter;
		private var hw:IWordProcessor;
		
		private var _checkLastWord:Boolean = true;
		private var _spellingEnabled:Boolean;
		
		private var _actualParent:*;
		private var isHaloComponent:Boolean;
		private var isSparkComponent:Boolean;

        //New Added below
		private var mTextField:*;
		
		//private var mTextField:RichEditableText;

		private var _dictname:String = new String();			
		private var _hundict:HunspellDictionary = new HunspellDictionary();		
		private var _userdict:UserDictionary = null;
		private var _sharedobj:SharedObject = null;
		private var scm:SpellingContextMenu;
		
		private var _newchecker:SpellChecker = null;
		private var _resource_locale:Object = null;
		private var _spellingservice:SpellingService = null;

		private static var _contextMenuEntries:Object = {enable:"Enable Spelling", disable:"Disable Spelling", add:"Add to dictionary"};		
		private static var _spellingConfigUrl:String = "SpellingConfig.xml";
		private static var _UITable:Dictionary= new Dictionary();
		private static var _parentTable:Dictionary= new Dictionary();
		private static var _cacheDictTable:Dictionary= new Dictionary();
		
		private static var _configXML:XML = null;
		private static var _configXMLLoading:Boolean = false;
		private static var _configXMLLoader:URLLoader = new URLLoader();
		
		// Work around for the memory usage problem, ideally a better fix is to provide a dicitonary unload function
		private static var _cache:Object = new Object();

		/**
		 * Enables the spell checking feature for a UI component.
		 * 
		 * <p>Note: This version provides only enabling function but no disabling function.</p>
		 *
		 * @param comp	A text editing Flex UI component.
		 				It can be a <code>TextArea</code>, <code>TextInput</code> or <code>RichTextEditor</code>.
		 * @param dict	A URL for the dictionary to be used with the <code>SpellChecker.</code>
		 *
		 * @includeExample Examples/Flex/SquigglyUIExample/src/SquigglyUIExample.mxml
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public static function enableSpelling(comp:UIComponent, lang:String):void
		{
			if ( lang == null ) return;
		 	// TODO: Change dict parameter type to a SpellCheck class or a URL string.
			var txt:* = getComponentTextModel(comp);
			/*var comp1:UIComponent = txt.parent;
			var comp2:UIComponent = txt.owner;
			var comp3:UIComponent = txt.parentApplication;
			var comp4:UIComponent = txt.parentDocument;
			var comp5:UIComponent = txt.parentDocument.hostComponent; <--spark parent UICOmponent*/
			if ( txt==null || _UITable[comp]!=undefined )
				return;	
			
			// TODO: dangerous, is garbage collection going to clear this?
			_UITable[comp]=new SpellUI(txt, lang);
			_parentTable[txt] = comp;
			_cacheDictTable[comp]=lang;
		}

		// Customize the spelling related entry in spelling contextMenu
		public static function setSpellingMenuEntries(entries:Object):Boolean
		{
			if (entries.enable && entries.disable && entries.add && (entries.enable != "") && (entries.disable != "") && (entries.add != ""))
			{
				_contextMenuEntries = entries;
				return true;
			}
			else
				return false;
		}
		
		/**
		 * Get the spelling context menu entries. 
		 * 
		 * @return A flex <code>Object</code> containing the spelling context menu entries. If you haven't customized the entries, you get the default associative array <code>{enable:"Enable Spelling", disable:"Disable Spelling", add:"Add to dictionary"}</code>
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */		
		public static function getSpellingMenuEntries():Object
		{
			return _contextMenuEntries;
		}
		
		/**
		 * The URL for the spelling config xml file. If you haven't specify it, the default URL is [applicationDirectory]/SpellingConfig.xml. Note that we don't validate the URL, if the file doesn't exist, you will get an error when calling enableSpelling() function.
		 *
		 * @example The following code customize the spellingConfigUrl before enabling spell checking.
		 * <listing version="3.0">
		 * SpellUI.spellingConfigUrl = "./config/MySpellingConfig.xml";
		 * SpellUI.enableSpelling(textArea, "en_US");
		 * </listing>
		 */
		public static function get spellingConfigUrl():String
		{
			return _spellingConfigUrl;
		}
		
		public static function set spellingConfigUrl(url:String):void
		{
			if (url == null) throw new Error("URL can't be null");
			_spellingConfigUrl = url;
		}
		

		
		/**
		 * Disable the spell checking feature for a UI component.
		 * 
		 * @param comp	A text editing Flex UI component.
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public static function disableSpelling(comp:UIComponent):void{
			if ( _UITable[comp] == undefined )
				return;
			var _ui:SpellUI = _UITable[comp];
			if ( _ui != null) _ui.cleanUp();
			var dictName:String = _cacheDictTable[comp];
			var cleanUPDictionaryCount:int = 0;
			for each ( var _dictName:String in _cacheDictTable ) {
				if ( _dictName == dictName  )
					cleanUPDictionaryCount++;
			}
			if ( cleanUPDictionaryCount == 1 ) {
				_cache[dictName] = undefined;
			}
			delete _UITable[comp];
			delete _cacheDictTable[comp];
			
		}
		
		/**
		 @private
		 (This property is for Squiggly Developer use only.)
		 */
		public static function get UITable():Dictionary {
			return _UITable;
		}
		
		/**
		 @private
		 (This property is for Squiggly Developer use only.)
		 */
		public function set spellingEnabled(value:Boolean):void {
			_spellingEnabled = value;
		}
		
		/**
		 @private
		 (This property is for Squiggly Developer use only.)
		 */
		public static function get parentComp():Dictionary {
			return _parentTable;
		}
		
		private static function getComponentTextModel(comp:UIComponent):* {
			var txt:TextField = null;
			var txt2:RichEditableText = null;
			if ( (comp == null) || !( (comp is mx.controls.TextArea) || (comp is mx.controls.TextInput) || (comp is RichTextEditor) 
								|| (comp is spark.components.TextArea) || (comp is spark.components.TextInput) || (comp is spark.components.RichEditableText)) )
				return null;
			if ((comp as RichTextEditor) != null) {
				txt = (comp as RichTextEditor).textArea.getTextField() as TextField;
			}
			else if ((comp as mx.controls.TextArea) != null){
				txt = (comp as mx.controls.TextArea).getTextField() as TextField;
			}
			else if ((comp as mx.controls.TextInput) != null) {
				txt = (comp as mx.controls.TextInput).getTextField() as TextField;
			}
			else if ((comp as spark.components.TextArea) != null) {
                if ((comp as spark.components.TextArea).textDisplay is TextField)
                    txt = (comp as spark.components.TextArea).textDisplay as TextField;
                else
    				txt2 = (comp as spark.components.TextArea).textDisplay as RichEditableText;
			}
			else if ((comp as spark.components.TextInput) != null) {
                if ((comp as spark.components.TextInput).textDisplay is TextField)
                    txt = (comp as spark.components.TextInput).textDisplay as TextField;
                else
    				txt2 = (comp as spark.components.TextInput).textDisplay as RichEditableText;
			}
			else if ((comp as spark.components.RichEditableText) !=null) {
				txt2 = comp as RichEditableText;
			}
			else {
				// do nothing if it's not a valid text component
				return null;
			}
			if (txt != null) 
				return txt;
			else 
				return txt2;
		}
		
		/**
		 * Constructs a SpellUI object.
		 *
		 *	@param	textFiled	A Flex UI component to include spell-check capability
		 *	@param	dict		A URL for Squiggly spelling dictionary.
		 *
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */			
		public function SpellUI(textModel:*, lang:String)
		{		
			// TODO: Consider making this method invisible to user, only expose the static function.
			if ( textModel is TextField ) {
				isHaloComponent=true;
				//New Added below -- check if text field needs to be extracted from textModel
				//mTextField = textModel;
			}else if (textModel is RichEditableText ) {
				isSparkComponent=true;
				textModel.setFocus();
				textModel.selectRange(textModel.text.length, textModel.text.length);
				//New Added below -- check if text field needs to be extracted from textModel
				//mTextField = textModel ;
			}else {
				// do nothing, we only accept textField and TextFlow here....
				return;
			}
			_actualParent = textModel;
			mTextField = textModel ;
									
			mTextField.addEventListener(FocusEvent.FOCUS_OUT, handleFocusOut);
			mTextField.addEventListener(FocusEvent.FOCUS_IN, handleFocusIn);
			mTextField.addEventListener(ScrollEvent.SCROLL, spellCheckScreen);
			mTextField.parent.addEventListener(Event.RENDER, spellCheckScreen);
			mTextField.parent.addEventListener(Event.CHANGE, handleChangeEvent);
			_dictname = lang;			
			loadConfig();
			
		}
		
		private function spellCheckScreen(event:Event):void
		{
			doSpellingJob();
		}
		
		private function handleFocusOut(event:FocusEvent):void
		{
			_checkLastWord = true;
			doSpellingJob();
		}
						
		private function handleFocusIn(event:FocusEvent):void
		{
			_checkLastWord = false;
			doSpellingJob();
		}
		
		private function handleChangeEvent( event:Event ) :void {
			_checkLastWord = false;
			spellCheckScreen(event);
		}
		
		/*private function doSpelling():void
		{
			_checkLastWord = true;
			doSpellingJob();
		}*/
				
		/**
		 @private
		 (This property is for Squiggly Developer use only.)
		 */		
		public function doSpellingJob():void
		{
			if (_spellingEnabled == false) return;
			spellCheckRange(getValidFirstWordIndex(), getValidLastWordIndex());
		}
		
		private function spellCheckRange(start:uint, end:uint):void {
			//hh.preSpellCheckRange(start, end);
			hh.clearSquiggles();
			if ( isHaloComponent ) {
				//if (end <= start) return;
				var firstLine:int = mTextField.getLineIndexOfChar(start);
				var rect:Rectangle = mTextField.getCharBoundaries(start);
				var counter:uint = start;
				var numLines:Number = 0;
				
				/* mTextField.getCharBoundaries returns null for blank lines and for end of line characters. Placing this workaround
				to count line heights until a non-null bounding rectangle is found */
				while (rect == null) {
					if (++counter > end) {
						rect = new Rectangle(0,0,0,0);
						break;
					}
					numLines += mTextField.getLineMetrics(firstLine).height;
					firstLine++;
					rect = mTextField.getCharBoundaries(counter);
				}
				
				var yoffset:Number = rect.y - numLines;	
				var pleft:uint = (mTextField.parent as UIComponent).getStyle("paddingLeft");
				var ptop:uint = (mTextField.parent as UIComponent).getStyle("paddingTop");
				
				var offsetPoint:Point = new Point(pleft, ptop-yoffset); 
								
				hh.offsetPoint = offsetPoint;
			}
			
			var tokenizer:TextTokenizer = new TextTokenizer(mTextField.text.substring(start,end));
			var tokens:Vector.<Token> = new Vector.<Token>();
			
			for ( var token:Token = tokenizer.getFirstToken(); token != tokenizer.getLastToken(); token= tokenizer.getNextToken(token) ) {
				var result:Boolean=_spellingservice.checkWord(mTextField.text.substring(token.first+start, token.last+start));					
				if (!result){
					if (_checkLastWord || (token.last+start != mTextField.text.length))
						//hh.highlightWord(token.first+start, token.last+start-1);
						//tokens.push(new Token(token.first+start, token.last+start-1));
						hh.drawSquiggleAt(new Token(token.first+start, token.last+start-1));
				}
				
			}
			//hh.postSpellCheckRange(start, end);
			//hh.offsetPoint = offsetPoint;
			//hh.drawSquiggles(tokens);
		}
		
		
		
		private function getValidFirstWordIndex():int{			
			var index:int;
			if ( mTextField is TextField ) {
				index = mTextField.getLineOffset(mTextField.scrollV-1);
			}else if (mTextField is RichEditableText ) {			
				// Check for computeSelectionIndexInContainer which throws when lineindex == 0
				try {
					index = SelectionManager.computeSelectionIndex(mTextField.textFlow, mTextField, mTextField, 0 + mTextField.horizontalScrollPosition, 0 + mTextField.verticalScrollPosition);
				
				} catch (err:Error)
				{
					//TODO: report error
					index = 0;
				}
			}
			return index;
		}
		
		private function getValidLastWordIndex():int{			
			var index:int;
			if ( mTextField is TextField ) {
				index = mTextField.getLineOffset(mTextField.bottomScrollV-1)+mTextField.getLineLength(mTextField.bottomScrollV-1);
			}else if (mTextField is RichEditableText ) {	
				// Check for computeSelectionIndexInContainer which throws when lineindex == 0
				try {
					index = SelectionManager.computeSelectionIndex(mTextField.textFlow, mTextField, mTextField, mTextField.width+mTextField.horizontalScrollPosition, mTextField.height+mTextField.verticalScrollPosition);
				} catch (err:Error)
				{
					//TODO: report error
					index = 0;
				}
			}				
			return index;
		}

			private function loadConfig():void{
			_resource_locale = SpellingConfiguration.resourceTable.getResource(_dictname);
			
			if ((_resource_locale != null) || (SpellUI._configXML != null)) 
				loadConfigComplete(null);
			else {	
				SpellUI._configXMLLoader.addEventListener(Event.COMPLETE, loadConfigComplete);
			
				if (SpellUI._configXMLLoading == false)
				{
					SpellUI._configXMLLoader.load(new URLRequest(_spellingConfigUrl));
					SpellUI._configXMLLoading = true;
				}
			}
		}
		
		private function loadConfigComplete(evt:Event):void{
			if (_resource_locale == null) {
			if (SpellUI._configXML == null)
				SpellUI._configXML= new XML(evt.target.data);
			
				SpellingConfiguration.resourceTable.setResource(_dictname,{rule:SpellUI._configXML.LanguageResource.(@languageCode==_dictname).@ruleFile, 
																		dict:SpellUI._configXML.LanguageResource.(@languageCode==_dictname).@dictionaryFile});
		}
                //New Added
			_spellingservice = new SpellingService(_dictname);
			_spellingservice.addEventListener(Event.COMPLETE, loadDictComplete);
			_spellingservice.init();
		}
		
				
				
		
		private function loadDictComplete(evt:Event):void
		{					
			//_newchecker = new SpellChecker(_hundict);
			
			// Lazy loading the UD only when the main dict is loaded successfully
			if ((SpellUI._cache["Squiggly_UD"] as UserDictionary) == null)
			{
				_sharedobj = SharedObject.getLocal("Squiggly_v03");
				var vec:Vector.<String> = new Vector.<String>();
				if (_sharedobj.data.ud) {
					for each (var w:String in _sharedobj.data.ud)
					vec.push(w);
				}
				_userdict = new UserDictionary(vec);
				
				SpellUI._cache["Squiggly_SO"] = _sharedobj;
				SpellUI._cache["Squiggly_UD"] = _userdict;
			}
			else 
			{
				_sharedobj = SpellUI._cache["Squiggly_SO"];
				_userdict = SpellUI._cache["Squiggly_UD"];
			}
			_spellingservice.addUserDictionary(_userdict);
			
			
			// Add the context menu, this might be not successful
			scm = null;
			try {
				addContextMenu(null);
			}
			catch (err:Error)
			{
				// TODO: error handling here
			}
			_actualParent.addEventListener(Event.ADDED_TO_STAGE, addContextMenu);
		}
		
		
		private function addContextMenu(event:Event):void
		{
			if ( scm != null ) return;
			if ( isHaloComponent ) {
				hh= new HaloHighlighter( _actualParent);
				hw= new HaloWordProcessor( _actualParent );
			}else if ( isSparkComponent ){
				hh = new SparkHighlighter( _actualParent);
				hw = new SparkWordProcessor( _actualParent);
			} else {
				trace("error now, later will be true");
			}
		
			scm =  new SpellingContextMenu(hh, hw, _spellingservice, _actualParent, _actualParent.contextMenu); 
			scm.setIgnoreWordCallback( addWordToUserDictionary );
			
			// Halo need this
			if (_actualParent.contextMenu == null)
			{
				_actualParent.contextMenu = scm.contextMenu;
			}
			
			//hh.spellingEnabled=true;
			_spellingEnabled = true;
			try {
				doSpellingJob();
			}
			catch (err:Error)
			{
				// If it fails here, it should later triggered by the render event, so no need to do anything
			}
		}
		
		private function addWordToUserDictionary(word:String):void
		{
			_userdict.addWord(word);
		
			// TODO: serialization here might affect ther performance
			_sharedobj.data.ud = _userdict.wordList;
			
		}
		/**
		 *	@private
		 */
		private function cleanUp():void {
			hh.clearSquiggles();
			scm.cleanUp();
			_actualParent.removeEventListener(Event.ADDED_TO_STAGE, addContextMenu);
			
			mTextField.removeEventListener(ScrollEvent.SCROLL, spellCheckScreen);
			mTextField.parent.removeEventListener(Event.RENDER, spellCheckScreen);
			mTextField.parent.removeEventListener(Event.CHANGE, handleChangeEvent);
			mTextField.removeEventListener(FocusEvent.FOCUS_OUT, handleFocusOut);
			mTextField.removeEventListener(FocusEvent.FOCUS_IN, handleFocusIn);
		}
		
	}
}
