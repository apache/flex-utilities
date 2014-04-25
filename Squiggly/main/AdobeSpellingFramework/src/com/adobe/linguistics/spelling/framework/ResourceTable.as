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
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	
	[RemoteClass(alias='com.adobe.linguistics.spelling.framework.ResourceConfig')]
		
	/**
	 * The ResourceTable class contains a table mapping language to the spelling resources. Resources here imply the URL of rule file and dict file to be used for the language.
	 * 
	 * @includeExample ../Examples/Flex/ConfigExample/src/ConfigExample.mxml -noswf
	 * @playerversion Flash 10
	 * @langversion 3.0
	 */
	public class ResourceTable implements IExternalizable
	{
		private var _resources:Object;
		
		/**
		 * Constructs a new ResourceTable object that performs language to resource mapping. 
		 */
		public function ResourceTable()
		{
			_resources = new Object();
		}

		/**
		 * A list of languages supported in this ResourceTable
		 */
		public function get availableLanguages():Vector.<String>
		{
			var result:Vector.<String> = new Vector.<String>();
			for (var i:String in _resources)
			{
				result.push(i);
			}
			return result;
		}
		
		/**
		 * Set the resource for the specified language.
		 * 
		 * @param language The language that you want to assign spelling resources to.
		 * @param resource A <code>Object</code> that behave as an associated array, it 
		 * contains the path(s) to the resource file(s). For the time being, the only 
		 * supported resource is hunspell dictionary, which contains a rule file (.aff) and a 
		 * dictionary file (.dic). 
		 * 
		 * @example The following code sets the resource for American English language.
		 * <listing version="3.0">
		 * var resourceTable:ResourceTable = new ResourceTable();
		 * resourceTable.setResource("en_US", {rule:"en_US.aff", dict:"en_US.dic"});
		 * </listing>
		 */
		public function setResource(language:String, resource:Object):void
		{
			_resources[language] = resource;
		}
		
		/**
		 * Get the resource for the specified language.
		 * 
		 * @param language The language associated with the resource you are looking for.
		 * @return An <code>Object</code> that stores the resource file URL(s).
		 * @example The following code gets and uses the resource for American English language.
		 * <listing version="3.0">
		 * var resource_en_US:Object = SpellingConfiguration.resourceTable.getResource("en_US");
		 * trace("rule file:" + resource_en_US["rule"] + ", dictionary file:" + resource_en_US.dict);
		 * </listing>
		 */
		public function getResource(language:String):Object
		{
			return _resources[language];
		}
		
		/**
		 * Overwrite toString() for debug purpose.
		 * @private
		 */
		public function toString():String
		{
			var result:String = new String();
			for (var i:String in _resources)
			{
				result += i;
				result += ": ";
				result += "[";
				for (var j:String in getResource(i))
				{
					result += j + ":" + getResource(i)[j] + " "
				}
				result += "]";
				result += "; ";
			}
			return result;
		}
		
		/**
		 * Implement this IExternalizable API so that it can be serialized to an ByteArray.
		 * @private
		 */
		public function readExternal(input:IDataInput):void {
			_resources = input.readObject();
		}
		
		/**
		 * Implement this IExternalizable API so that it can be serialized to an ByteArray.
		 * @private
		 */
		public function writeExternal(output:IDataOutput):void {
			output.writeObject(_resources);
		}
	}
}