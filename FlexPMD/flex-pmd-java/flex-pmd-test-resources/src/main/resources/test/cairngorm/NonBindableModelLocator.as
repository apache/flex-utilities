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
package com.adobe.ac.sample.model
{
	import com.adobe.ac.sample.view.common.model.UsersManagementPresentationModel;
	import com.adobe.cairngorm.model.IModelLocator;

	private class ModelLocator implements IModelLocator
	{
		private static var _instance : ModelLocator;
		protected var myProtected : int;
		[Bindable]
		public var usersManager : UsersManagementPresentationModel;
		
		public function ModelLocator( enforcer : SingletonEnforcer )
		{
			usersManager = new UsersManagementPresentationModel();
		}
		
		public static function get instance() : ModelLocator
		{
			if ( _instance == null )
			{
				foo();
				_instance = new ModelLocator( new SingletonEnforcer() );
			}
			return _instance;
		}
		
		[Bindable]
		public function get height() : int
		{
			return 0;
		}
	}
}

class SingletonEnforcer{}