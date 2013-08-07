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

package org.apache.flex.utilities.common
{

import flash.system.Capabilities;

import mx.controls.Alert;

public class Tools
{

	//--------------------------------------------------------------------------
	//
	//    Class constants
	//
	//--------------------------------------------------------------------------
	
	private static const PLATFORM_MAC:String = "Mac";
	private static const PLATFORM_WIN:String = "Windows";
	private static const PLATFORM_LINUX:String = "Linux";
	
	//--------------------------------------------------------------------------
	//
	//    Class properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//    instance
	//----------------------------------
	
	private static var _instance:Tools;
	
	public static function get instance():Tools
	{
		if (!_instance)
			_instance = new Tools(new SE());
		
		return _instance;
	}
	
	//--------------------------------------------------------------------------
	//
	//    Class methods
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//    warnPlatformNotSupported
	//----------------------------------
	
	public static function getApplicationExtension():String
	{
		var platform:String = Capabilities.os.split(" ")[0];
		
		if (platform == PLATFORM_WIN)
			return Constants.APPLICATION_EXTENSION_WIN;
		else if (platform == PLATFORM_MAC)
			return Constants.APPLICATION_EXTENSION_MAC;
		else if (platform == PLATFORM_LINUX)
			return Constants.APPLICATION_EXTENSION_LINUX;
		else
			throw(new Error("PlatformNotSupported"));
	}
	
	//--------------------------------------------------------------------------
	//
	//    Constructor
	//
	//--------------------------------------------------------------------------
	
	public function Tools(se:SE) {}
	
}
}

class SE {}
