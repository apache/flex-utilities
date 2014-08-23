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

public class Constants
{

	//--------------------------------------------------------------------------
	//
	//    Class Constants
	//
	//--------------------------------------------------------------------------
	
	public static const APACHE_FLEX_URL:String = "http://flex.apache.org/";
	
	public static const ARCHIVE_EXTENSION_MAC:String = ".tar.gz";
	public static const ARCHIVE_EXTENSION_WIN:String = ".zip";
	
	public static const APPLICATION_EXTENSION_MAC:String = ".dmg";
	public static const APPLICATION_EXTENSION_WIN:String = ".exe";
	public static const APPLICATION_EXTENSION_LINUX:String = ".deb";
	
	public static const CONFIG_XML_NAME:String = "installer/sdk-installer-config-4.0.xml";
	public static const DISCLAIMER_PATH:String = "about-binaries.html";
	public static const INSTALLER_TRACK_SUCCESS:String = "track-installer.html";
	public static const INSTALLER_TRACK_FAILURE:String = "track-installer.html?failure=true";
	
	
	public static const SDK_BINARY_FILE_NAME_PREFIX:String = "apache-flex-sdk-";
	
	public static const URL_PREFIX:String = "http://";
	public static const FILE_PREFIX:String = "file://";
    public static const HTTPS_PREFIX:String = "https://";
	
	public static const SOURCEFORGE_DL_URL:String = ".dl.sourceforge.net/project/";
	public static const SOURCEFORGE_DOWNLOAD_URL:String = "http://downloads.sourceforge.net/project/" +
		"";
	
	//--------------------------------------------------------------------------
	//
	//    Class properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//    instance
	//----------------------------------
	
	private static var _instance:Constants;
	
	public static function get instance():Constants
	{
		if (!_instance)
			_instance = new Constants(new SE());
		
		return _instance;
	}
	
	//--------------------------------------------------------------------------
	//
	//    Constructor
	//
	//--------------------------------------------------------------------------
	
	public function Constants(se:SE) {}
	
}
}

class SE {}