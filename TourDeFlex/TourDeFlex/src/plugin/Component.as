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
	//import merapi.messages.*;
	
	import mx.collections.ArrayCollection;
	
	[RemoteClass(alias="com.adobe.tourdeflex.core.Component")]
	
	public class Component //extends Message
	{		
		// ---------------------------- variables ---------------------
		private var __id : String;
		private var __name : String;
		private var __description : String;
		private var __author : String;
		
		// ---------------------------- getters & setters ---------------------
		
		public function get id() : String
		{
			return __id;
		}
		public function set id( value : String ) : void
		{
			__id = value;
		}

		public function get name() : String
		{
			return __name;
		}
		public function set name( value : String ) : void
		{
			__name = value;
		}
		public function get description() : String
		{
			return __description;
		}
		public function set description( value : String ) : void
		{
			__description = value;
		}
		public function get author() : String
		{
			return __author;
		}
		public function set author( value : String ) : void
		{
			__author = value;
		}
		
	}
}