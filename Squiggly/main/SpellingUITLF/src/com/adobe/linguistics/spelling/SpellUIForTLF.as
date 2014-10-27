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
	import com.adobe.linguistics.spelling.framework.ui.IHighlighter;
	import com.adobe.linguistics.spelling.framework.ui.IWordProcessor;
	import com.adobe.linguistics.spelling.framework.ui.TLFHighlighter;
	import com.adobe.linguistics.spelling.framework.ui.TLFWordProcessor;
	import com.adobe.linguistics.utils.TextTokenizer;
	import com.adobe.linguistics.utils.Token;
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.compose.StandardFlowComposer;
	import flashx.textLayout.compose.TextFlowLine;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.elements.FlowLeafElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.CompositionCompleteEvent;
	
	import flashx.textLayout.tlf_internal;
	
	
	use namespace tlf_internal;	
	/**
	 * <p>A comprehensive convenience class that bundles a context menu UI, 
	 * the spelling engine, the dictionary loader, and user dictionary support 
	 * to enable a single-line integration of spell checking functionality into 
	 * any custom UI component built around TLF TextFlow.  </p>
	 * 
	 *
	 * <p>For advanced text editing applications, more complex features are likely required.
	 *	For those applications, we recommend bypassing this class and utilizing the <code>SpellChecker</code> class directly.</p>
	 *
	 * In order to display Squiggly custom right-click context menu, SpellUIForTLF extends TLF <code>ContainerController</code> class and overrides createContextMenu() method 
	 * of <code>ContainerController</code>. This could have the following side-effects for a Squiggly client:
	 * <ul>
	 * 		<li>In case the Squiggly client application uses a derived controller that inherits from ContainerController class in order to show custom context menu items, Squiggly
	 * 			context menu will override that. That essentially means that after SpellUIForTLF.enableSpelling() is called, client's own custom right-click menu items, if any, will not be
	 * 			accessible. </li>
	 * 		<li>Incase any ContainerController api needs to be called after SpellUIForTLF.enableSpelling() has been called, the client application will need to get the controller objects afresh 
	 * 			from the TextFlow's FlowComposer. This is needed since SpellUIForTLF replaces ContainerController objects with new SquigglyCustomContainerController(derived from ContainerController) objects. </li> 
	 * </ul>
	 * 
	 * 
	 * <p><code>SpellUIForTLF</code> uses the SpellingConfig.xml file to lookup corresponding resource files for a given locale.
	 * The default location of SpellingConfig.xml is [yourapplicationDirectory]/SpellingConfig.xml. This could be customized using 
	 * <code>spellingConfigUrl</code> property of <code>SpellUI</code>. You don't have to change the content of this file. However,
	 * if you want to add a new language, to use an alternative dictionary or to customize the location for your dictionaries, you can modify it. 
	 * There's an known issue with IIS web server when loading dictionary files with unknown extensions, in which case you can modify the XML to work around it.</p><p>
	 * A sample SpellingConfig.xml will look as follows:
	 * <listing version="3.0">
	 * <pre class="preWrapper">
	 * &lt;?xml version=&quot;1.0&quot; encoding='UTF-8'?&gt;
	 * &lt;SpellingConfig&gt;
	 *   	&lt;LanguageResource language=&quot;English&quot; 	  languageCode=&quot;en_US&quot; ruleFile=&quot;dictionaries/en_US/en_US.aff&quot; dictionaryFile=&quot;dictionaries/en_US/en_US.dic&quot;/&gt;
	 *    	&lt;LanguageResource language=&quot;Spanish&quot;    languageCode=&quot;es_ES&quot; ruleFile=&quot;dictionaries/es_ES/es_ES.aff&quot; dictionaryFile=&quot;dictionaries/es_ES/es_ES.dic&quot;/&gt;
	 *   	&lt;LanguageResource language=&quot;Portuguese&quot; languageCode=&quot;pt_PT&quot; ruleFile=&quot;dictionaries/pt_PT/pt_PT.aff&quot; dictionaryFile=&quot;dictionaries/pt_PT/pt_PT.dic&quot;/&gt;
	 *  	 &lt;LanguageResource language=&quot;Italian&quot; 	  languageCode=&quot;it_IT&quot; ruleFile=&quot;dictionaries/it_IT/it_IT.aff&quot; dictionaryFile=&quot;dictionaries/it_IT/it_IT.dic&quot;/&gt;
	 * &lt;/SpellingConfig&gt;</pre>
	 *
	 * </listing>
	 * Note: The languageCode can be an arbitrary value, as long as you are consistent when passing them to the Squiggly classes. 
	 * However, we highly encourage you to follow the two part Unicode language identifier format. 
	 * For more information, please consult the latest Unicode Technical Standard that can be found at: http://unicode.org/reports/tr35/.</p>
	 * 
	 * @playerversion Flash 10
	 * @langversion 3.0
	 */
	public class SpellUIForTLF
	{
		private var hh:IHighlighter;
		private var hw:IWordProcessor;
		
		private var _checkLastWord:Boolean = true;
		private var _spellingEnabled:Boolean;
		
		private var _actualParent:*;
		

        //New Added below
		private var mTextFlow:TextFlow;
		
		
		private var _dictname:String = new String();			

		private var _userdict:UserDictionary = null;
		private var _sharedobj:SharedObject = null;
		private var scm:SpellingContextMenuForTLF;
		
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
		 * Enables the spell checking feature for a TLF TextFlow. Once a TextFlow is spell checking enabled, misspelled words will be highlighted with a squiggly line. Users can 
		 * right click on a misspelled word to see the suggestions in the context menu.
		 * 
		 * @param comp	A TLF TextFlow object
		 * @param lang	The language code used for spell checking, for example <code>en_US</code>. it will lookup the SpellingConfig.xml file to access corresponding resource files.
		 * SpellingConfig.xml should located at the same folder as your main mxml source file. You don't have to change the content of this file. However,
		 * if you want to add a new language, to use an alternative dictionary or to customize the location for your dictionaries, you can modify it. There's an known issue with
		 * IIS web server when loading dictionary files with unknown extensions, in which case you can modify the XML to work around it.
		 * 
		 * 
		 * @includeExample Examples/ActionScript/SquigglyTLFExample/src/SquigglyTLFExample.as
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */

		public static function enableSpelling(comp:TextFlow, lang:String):void
		{
			if ( lang == null ) return;
			if ( comp==null || _UITable[comp]!=undefined )
				return;	
			
			// TODO: dangerous, is garbage collection going to clear this?
			_UITable[comp]=new SpellUIForTLF(comp, lang);
			_parentTable[comp] = comp;
			_cacheDictTable[comp]=lang;			
		}	
	
		/**
		 * Set the spelling context menu entries. This uses the ActionScript Object class as an associative array for extensibility. 
		 * <code>entries</code> should have all the customized contextMenu entries including <code>enable (spelling), 
		 * disable (spelling) and add (to dictionary)</code>. To ensure a consistent contextMenu within your application, 
		 * the spelling context menu entries you provide here are applied to all UI components. We recommend you use this API
		 * to localize the context menu strings.
		 *  
		 * @param entries A Object that looks like <code>entries:Object = {enable:"Enable Spelling", disable:"Disable Spelling", 
		 * add:"Add to dictionary"}</code>. If you don't customize the contextMenu, the default contextMenu in English will be used.
		 * 
		 * @return <code>True</code> if the spelling menu is successfully customized, <code>false</code> if it fails. Possible failure 
		 * reasons include passing the wrong object or missing some required entries. If the function fails, the contextMenu is left unchanged.
		 * 
		 * 
		 * @IncludeExample Examples/Flex/CustomContextMenu/src/CustomContextMenu.mxml
		 * @IncludeExample Examples/Flex/ContextMenuWithResource/src/ContextMenuWithResource.mxml
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
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
		 * @return A actionScript <code>Object</code> containing the spelling context menu entries. If you haven't customized the entries, you get the default associative array <code>{enable:"Enable Spelling", disable:"Disable Spelling", add:"Add to dictionary"}</code>
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
		 * SpellUIForTLF.spellingConfigUrl = "./config/MySpellingConfig.xml";
		 * SpellUIForTLF.enableSpelling(textFlow, "en_US");
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
		 * Disable the spell checking feature for a TLF TextFlow.
		 * 
		 * @param comp	TLF TextFlow object on which to disable spell check.
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public static function disableSpelling(comp:TextFlow):void{
			if ( _UITable[comp] == undefined )
				return;
			var _ui:SpellUIForTLF = _UITable[comp];
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
		
				
		/**
		 * Constructs a SpellUI object.
		 *  @private
		 *	@param	textFiled	A Flex UI component to include spell-check capability
		 *	@param	dict		A URL for Squiggly spelling dictionary.
		 *
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */			
		public function SpellUIForTLF(textModel:TextFlow, lang:String)
		{		
		
			_actualParent = textModel;
			mTextFlow = textModel;					
			
			mTextFlow.addEventListener(flashx.textLayout.events.CompositionCompleteEvent.COMPOSITION_COMPLETE, spellCheckScreen,false, 0,true);
			//mTextFlow.addEventListener(flashx.textLayout.events.StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE, spellCheckScreen);
			
			_dictname = lang;			
			loadConfig();			
		}
		
		private function spellCheckScreen(event:Event):void
		{
			doSpellingJob();
		}
		
				
		/**
		 @private
		 (This property is for Squiggly Developer use only.)
		 */		
		public function doSpellingJob():void
		{
			if (_spellingEnabled == false) return;
			
			hh.clearSquiggles();
			for (var idx:int = 0; idx < mTextFlow.flowComposer.numControllers; idx++)
			{
				var testController:ContainerController = mTextFlow.flowComposer.getControllerAt(idx); 
				//if (getValidFirstWordIndexTLF(testController) != -1) 
					spellCheckRangeTLF(getValidFirstWordIndexTLF(testController), getValidLastWordIndexTLF(testController));
			}
			
		}
			
		
		private function spellCheckRangeTLF(start:uint, end:uint):void {
			var tokenizer:TextTokenizer;
			//hh.clearSquiggles();
			var tt:TextFlow = mTextFlow;
			//var currentLeaf:FlowLeafElement = tt.getFirstLeaf();
			var currentLeaf:FlowLeafElement = tt.findLeaf(start);
			var currentParagraph:ParagraphElement = currentLeaf ? currentLeaf.getParagraph() : null;
			while (currentParagraph) { // iterate over all paragraphs in the text flow
				var paraStart:uint = currentParagraph.getAbsoluteStart();
				if (paraStart > end)
					break; 
				
				//var offsetPoint:Point = new Point(currentParagraph.paddingLeft, currentParagraph.paddingTop); 
				//hh.offsetPoint = offsetPoint;
				tokenizer = new TextTokenizer(currentParagraph.getText().substring());
				//var tokens:Vector.<Token> = new Vector.<Token>();
				
				for ( var token:Token = tokenizer.getFirstToken(); token != tokenizer.getLastToken(); token= tokenizer.getNextToken(token) ) {
					var result:Boolean=_spellingservice.checkWord(currentParagraph.getText().substring(token.first, token.last));					
					if (!result){
						//if (_checkLastWord || (token.last+paraStart != currentParagraph.getText().length))
							//hh.highlightWord(token.first+start, token.last+start-1);
							//tokens.push(new Token(token.first+start, token.last+start-1));
							hh.drawSquiggleAt(new Token(token.first+paraStart, token.last+paraStart-1));
					}
					
				}
				currentParagraph = currentParagraph.getNextParagraph();
				
			}
			//hh.postSpellCheckRange(start, end);
			//hh.offsetPoint = offsetPoint;
			//hh.drawSquiggles(tokens);
		}
		private function getValidFirstWordIndexTLF(containerController:ContainerController):int{			
			var index:int;
					
			// Check for computeSelectionIndexInContainer which throws when lineindex == 0
			try {
				//index = SelectionManager.computeSelectionIndex(mTextFlow, containerController.container, containerController.container, 0 + containerController.horizontalScrollPosition, 0 + containerController.verticalScrollPosition);
				// SelectionManager.computeSelectionIndex() sometimes gives index as -1. in the same scenarios below logic works better 
				var tl:TextFlowLine = containerController.getFirstVisibleLine();
				var firstVisiblePosition:int = tl.absoluteStart;
				index = firstVisiblePosition;
				
			} catch (err:Error)
			{
				//TODO: report error
				index = 0;
			}
				
			return index;
		}
		
		private function getValidLastWordIndexTLF(containerController:ContainerController):int{			
			var index:int;
			
			// Check for computeSelectionIndexInContainer which throws when lineindex == 0
			try {
				//index = SelectionManager.computeSelectionIndex(mTextFlow, containerController.container, containerController.container, containerController.container.width+containerController.horizontalScrollPosition, containerController.container.height+containerController.verticalScrollPosition);
				var tl:TextFlowLine = containerController.getLastVisibleLine();
				var lastVisiblePosition:int = tl.absoluteStart + tl.textLength;
				index = lastVisiblePosition;
			} catch (err:Error)
			{
				//TODO: report error
				index = 0;
			}
				
			return index;
		}
		

		private function loadConfig():void{
			_resource_locale = SpellingConfiguration.resourceTable.getResource(_dictname);
			
			if ((_resource_locale != null) || (SpellUIForTLF._configXML != null)) 
				loadConfigComplete(null);
			else {	
				SpellUIForTLF._configXMLLoader.addEventListener(Event.COMPLETE, loadConfigComplete);
			
				if (SpellUIForTLF._configXMLLoading == false)
				{
					SpellUIForTLF._configXMLLoader.load(new URLRequest(_spellingConfigUrl));
					SpellUIForTLF._configXMLLoading = true;
				}
			}
		}
		
		private function loadConfigComplete(evt:Event):void{
			if (_resource_locale == null) {
			if (SpellUIForTLF._configXML == null)
				SpellUIForTLF._configXML= new XML(evt.target.data);
			
				SpellingConfiguration.resourceTable.setResource(_dictname,{rule:SpellUIForTLF._configXML.LanguageResource.(@languageCode==_dictname).@ruleFile, 
																		dict:SpellUIForTLF._configXML.LanguageResource.(@languageCode==_dictname).@dictionaryFile});
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
			if ((SpellUIForTLF._cache["Squiggly_UD"] as UserDictionary) == null)
			{
				_sharedobj = SharedObject.getLocal("Squiggly_v03");
				var vec:Vector.<String> = new Vector.<String>();
				if (_sharedobj.data.ud) {
					for each (var w:String in _sharedobj.data.ud)
					vec.push(w);
				}
				_userdict = new UserDictionary(vec);
				
				SpellUIForTLF._cache["Squiggly_SO"] = _sharedobj;
				SpellUIForTLF._cache["Squiggly_UD"] = _userdict;
			}
			else 
			{
				_sharedobj = SpellUIForTLF._cache["Squiggly_SO"];
				_userdict = SpellUIForTLF._cache["Squiggly_UD"];
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
			
			hh = new TLFHighlighter( _actualParent);
			hw = new TLFWordProcessor( _actualParent);	
						
			scm =  new SpellingContextMenuForTLF(hh, hw, _spellingservice, _actualParent, addWordToUserDictionary); 
			//scm.setIgnoreWordCallback( addWordToUserDictionary );
			
			// Halo need this
			//if (_actualParent.contextMenu == null)
			//{
				//_actualParent.contextMenu = scm.contextMenu;
			//}
			
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
			
			mTextFlow.removeEventListener(flashx.textLayout.events.CompositionCompleteEvent.COMPOSITION_COMPLETE, spellCheckScreen);
			//mTextFlow.removeEventListener(flashx.textLayout.events.StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE, spellCheckScreen);
		}
		
	}
}
