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
package com.adobe.linguistics.extensions
{
	import flash.events.EventDispatcher;
	import flash.external.ExtensionContext;

	
	public class HunspellNativeExtension extends EventDispatcher
	{
		
		private static var isInstantiated:Boolean = false;
		private static var context:ExtensionContext;
		
		private static const HUNSPELL_INIT_FAIL:int= -1
		private static const RESOURCE_FILES_MISSING:int= -2
		private static const HUNSPELL_INIT_SUCCESS:int= 1
		
		/**
		 * Initialize the Hunspell Native Extension
		 * 
		 * @playerversion Flash 11.1
		 * @langversion 3.0
		 */
		
		public function HunspellNativeExtension()
		{
			super();
			
			if (isInstantiated)
				return;
			
			try
			{
				context = ExtensionContext.createExtensionContext("com.adobe.linguistics.extensions.HunspellNativeExtension", ""); 
				isInstantiated = true;
			}
			catch (e:Error)
			{
			}
		}
		
		public function talkBack(message:String):*
		{
			
			return context.call("talkBack", message);
		}
		
		/**
		 * Initialize the Hunspell Object of ANE
		 * 
		 * @param locale The locale <code>String</code> for which spell checker is constructed. eg: "en_US"
		 * @param dictionaryPath The URL <code>String</code> specifying the third party resource location 
		 * @return <code>int</code> value. HUNSPELL_INIT_SUCCESS for success. HUNSPELL_INIT_FAIL, RESOURCE_FILES_MISSING for error. 
		 * @playerversion Flash 11.1
		 * @langversion 3.0
		 */
		
		public function initHunspellObject(locale:String, dictionaryPath:String):int
		{
			var rv:int=context.call("initHunspellObject", locale, dictionaryPath) as int;
			//trace(rv);
			return rv;
		}

		/**
		 * Check the input word. Return true or false depending on whether the word is correct or incorrect.
		 * 
		 * @param inpWord The input word <code>String</code>.
		 * @param locale The locale <code>String</code> for which spell checker is constructed. eg: "en_US"
		 * @return <code>Boolean</code> value. <code>True</code> for correct word. <code>False</code> for incorrect. 
		 * @playerversion Flash 11.1
		 * @langversion 3.0
		 */
		
		public function checkWord(inpWord:String, locale:String):Boolean
		{
			var rv:int=1;
			rv= context.call("checkWord", inpWord, locale) as int;
			return (rv?true:false);
		}
		
		/**
		 * Return an <code>Array</code> of suggestions for input word. 
		 * 
		 * @param inpWord The input word <code>String</code>.
		 * @param locale The locale <code>String</code> for which spell checker is constructed. eg: "en_US"
		 * @return <code>Array</code> of suggestions. Returns null array for correct word.
		 * @playerversion Flash 11.1
		 * @langversion 3.0
		 */
		public function getSuggestions(inpWord:String, locale:String):Array
		{	
			return context.call("getSuggestions", inpWord, locale) as Array;
		}
		
		/**
		 * A de-initialize function which disposes the loaded ANE.
		 * 
		 * @playerversion Flash 11.1
		 * @langversion 3.0
		 */
		
		public function deInitHunspellNativeExtension():void
		{
			if(!isInstantiated) return;
			isInstantiated=false;
			return context.dispose();
		}
		
	}
}