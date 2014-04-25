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
  
  
package com.adobe.linguistics.spelling.framework
{
	
	
	import flash.errors.IllegalOperationError;
	import com.adobe.linguistics.spelling.core.env.InternalConstants;
	import com.adobe.linguistics.spelling.framework.ResourceTable;
	
	/**
	 * The SpellingConfiguration is for setting and getting the configuration for the spell checker.
	 * 
	 * @includeExample ../Examples/Flex/ConfigExample/src/ConfigExample.mxml -noswf
	 * @playerversion Flash 10
	 * @langversion 3.0
	 */
	
	public class SpellingConfiguration
	{
		

		private static var _resourceTable:ResourceTable = null;
		private static var _enableDictionarySplit:Boolean=false;//static value so can be initialised here
		private static var _wordsPerDictionarySplit:int=InternalConstants.WORDS_PER_SPLIT;
		
		/**
		 * The resourceTable is used for mapping the language to resources.
		 */
		public static function get resourceTable():ResourceTable
		{
			// Lazy initialization for the default value
			if (_resourceTable == null) {
				_resourceTable = new ResourceTable();
				//_resourceTable.setResource("en_US", {rule:"data/en_US.aff", dict:"data/en_US.dic"});
			}
			return _resourceTable;	
		}
		
		public static function set resourceTable(resourceTable:ResourceTable):void
		{
			_resourceTable = resourceTable;
		}
		
		/**
		 * This is a flag that enables/disables loading of dictionary in splits.
		 * By default this flag is set to <code>false</code>. In case the initial loading time of dictionaries is found slow, this flag should be set to <code>true</code>. By enabling this, squiggly will load dictionary in splits with each split having <code>wordsPerDictionarySplit</code> number of words.
		 * <p>NOTE: This property, if used, should be set before calling <code>SpellUI.enableSpeliing</code>. Once <code>SpellUI.enableSpeliing</code> is called dictionaries will be loaded according to default values, and this property will not be used. </p>
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public static function get enableDictionarySplit():Boolean
		{
			return _enableDictionarySplit;	
		}
		
		public static function set enableDictionarySplit(enableDictionarySplit:Boolean):void
		{
			_enableDictionarySplit = enableDictionarySplit;
		}
		
		/**
		 * This property defines the number of words in one dictionary split.
		 * By default the value of this property is set to 20000 words. This property is used only if <code>enableDictionarySplit</code> is set to <code>true</code>. If <code>enableDictionarySplit</code> is set to <code>flase</code> this property turns void.
		 * <p>NOTE: This property, if used, should be defined before calling <code>SpellUI.enableSpeliing</code>. Once <code>SpellUI.enableSpeliing</code> is called dictionaries will be loaded according to default values, and this property will not be used.</p>
		 * @playerversion Flash 10
		 * @langversion 3.0
		 */
		public static function get wordsPerDictionarySplit():int
		{
			
			return _wordsPerDictionarySplit;	
		}
		
		public static function set wordsPerDictionarySplit(wordsPerDictionarySplit:int):void
		{
			if(wordsPerDictionarySplit<=0){
				//Do error Handling
				throw new IllegalOperationError("wordsPerDictionarySplit should be a positive non-zero value.");
			}
			_wordsPerDictionarySplit = wordsPerDictionarySplit;
		}
	}
}