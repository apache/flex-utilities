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
package plugin
{
	import merapi.messages.*;
	
	import mx.collections.ArrayCollection;
	
	[RemoteClass(alias="com.adobe.tourdeflex.core.TDFPluginTransferObject")]
	
	public class TDFPluginTransferObject extends Message
	{		
		// ---------------------------- variables ---------------------
		private var __components : ArrayCollection;
		private var __pluginDownloadPath : String;
		private var __selectedComponentId : String;

		// ---------------------------- constructor ---------------------
		public function TDFPluginTransferObject() : void
		{
			
		}

		// ---------------------------- getters & setters ---------------------
		public function get components() : ArrayCollection
		{
			return __components;
		}
		public function set components( value : ArrayCollection ) : void
		{
			__components = value;
		}
		public function get pluginDownloadPath() : String
		{
			return __pluginDownloadPath;
		}
		public function set pluginDownloadPath( value : String ) : void
		{
			__pluginDownloadPath = value;
		}
	public function get selectedComponentId() : String
		{
			return __selectedComponentId;
		}
		public function set selectedComponentId( value : String ) : void
		{
			__selectedComponentId = value;
		}
	}
}