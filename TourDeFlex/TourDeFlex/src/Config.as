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
package
{
	import classes.LocalQuickStart;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.Capabilities;
	
	public class Config
	{
		[Bindable] public static var PROGRAM_TITLE:String = "Tour de Flex";
		[Bindable] public static var APP_VERSION:String = "0";
		[Bindable] public static var OBJECTS_FILE_VERSION:String = "0";	
		[Bindable] public static var OBJECTS_TOTAL:int = 0;	
		[Bindable] public static var ABOUT_MENU_LIST:XMLList;
		[Bindable] public static var IS_ONLINE:Boolean = false;
		[Bindable] public static var USE_SPLASH:Boolean = true;		

		//public static var SETTINGS_FILE:String = "settings.xml";
		//public static function get SETTINGS_URL():String {return "data/" + SETTINGS_FILE;}
		//public static var settingsXml:XML;
		
		[Bindable] public static var ABOUT_MENU_TITLE:String = "Flex Resources";
		
		[Bindable] public static var SPLASH_URL:String = "data/assets/intro.flv";
		[Bindable] public static var QUICK_START_REMOTE_URL:String = "http://tourdeflex.blogspot.com";		
		[Bindable] public static var QUICK_START_LOCAL_URL:String = "data/quickstart.html";
		
		public static var OBJECTS_FILE:String = "objects-desktop2.xml";
		public static function get OBJECTS_URL():String {return "data/" + OBJECTS_FILE;}	
		public static var LOCAL_OBJECTS_ROOT_PATH:String = "objects/";		
		
		public static var OBJECTS_UPDATER_FILE:String = "objects-desktop2-update.xml";	
		public static function get OBJECTS_UPDATER_URL():String {return "http://tourdeflex.adobe.com/download/" + OBJECTS_UPDATER_FILE;}
		public static var APP_UPDATER_URL:String = "http://tourdeflex.adobe.com/download/update4.xml";
		
		public static var ONLINE_STATUS_URL:String = "http://tourdeflex.adobe.com/ping.html";
		public static var OFFLINE_URL:String = "data/offline.html";
		
		private static var BASE_URL:String = "http://tourdeflex.adobe.com/server/";				
		[Bindable] public static var DATA_EXCHANGE_URL:String = BASE_URL + "main.php";

		private static var COMENTS_URL_QUERY_STRING:String = "main.php?Request=GetComments&ObjectId=";
		public static var COMMENTS_URL:String = BASE_URL + COMENTS_URL_QUERY_STRING;		
			
		public static var HEADER_GRADIENT_IMAGE:String = "images/header_gradient.png";
		public static var HEADER_IMAGE:String = "images/header_logo.png";		
		
		public static var TREE_NO_ICON:String = "images/tree_noIcon.png";
		
		public function Config()
		{
		}
		
		/*		
		public static function loadSettings():void
		{
			setLocalization();
			
			var loader:URLLoader = new URLLoader(new URLRequest(Config.SETTINGS_URL));
			loader.addEventListener(Event.COMPLETE, settingsXmlLoaded);	
			
			var appXml:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = appXml.namespace();
			APP_VERSION = appXml.ns::version;					
		}		
		*/
		
		public static function setLocalization():void
		{
			//var localLanguage:String = Capabilities.languages[0].toString().toLowerCase(); //for 'en-us'
			var localLanguage:String = Capabilities.language.toLowerCase(); //for 'en'
 			trace("LANG=" + localLanguage);
 			//localLanguage = "jp"; //for testing
 			//trace(localLanguage);

			if(localLanguage != "en" && localLanguage != "en-us")
			{				
				//Config.QUICK_START_REMOTE_URL = appendLanguage(Config.QUICK_START_REMOTE_URL, localLanguage);
				//Config.QUICK_START_LOCAL_URL = appendLanguage(Config.QUICK_START_LOCAL_URL, localLanguage);
				
				var localizedObjectFile:String = "objects-desktop_" + localLanguage + ".xml";
				var staticObjectFile:File = File.applicationDirectory.resolvePath("data/" + localizedObjectFile);
				if(staticObjectFile.exists)
				{
					OBJECTS_FILE = localizedObjectFile;
					Config.OBJECTS_UPDATER_FILE = "objects-desktop-update_" + localLanguage + ".xml";
					//SETTINGS_FILE = "settings_" + localLanguage + ".xml";
				}
			} 
		}		
		
		public static function appendLanguage(oldPath:String, lang:String):String
		{
			var newPath:String = oldPath;
			
			var pos:int = oldPath.lastIndexOf(".");
			if(pos > 0)
			{
				var ext:String = oldPath.substring(pos, oldPath.length);
				newPath = oldPath.substring(0, pos);
				newPath += "_" + lang + ext;
			}
			
			return newPath;
		}

		/*
		private static function settingsXmlLoaded(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			settingsXml = new XML(loader.data);
			PROGRAM_TITLE = settingsXml.@title;
			ABOUT_MENU_LIST = settingsXml.AboutMenu.Item;
			ABOUT_MENU_TITLE = settingsXml.AboutMenu.@title;
		}
		*/
		
		public static function isAppFirstTimeRun():Boolean
		{
			var isFirstTime:Boolean = false;
			var appFirstTimeRunFile:File = File.applicationStorageDirectory.resolvePath("versions/" + APP_VERSION);
			
			if(!appFirstTimeRunFile.exists)
			{
				var fileStream:FileStream = new FileStream();
				fileStream.open(appFirstTimeRunFile, FileMode.WRITE);
				fileStream.writeUTFBytes(APP_VERSION);
				fileStream.close();
				
				isFirstTime = true;
			}
			
			return isFirstTime;
		}

	}
}