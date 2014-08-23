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
package classes
{
	/********************************
	 * This class has been deprecated	
	*********************************/
	
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	public class LocalQuickStart
	{
		
		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------			
		public static var url:String = "quickstart.html";
		
		private static var cookieName:String = "TourDeFlex";
		private static var onlineVersion:String = "";
		private static var localLanguage:String = "en";
		private static var onlineVersionUrl:String = "";
		
		
		//--------------------------------------------------------------------------
		//  Load/setup
		//--------------------------------------------------------------------------	
		public function LocalQuickStart()
		{
		}
		
		public static function update():void
		{						
			var staticContainerPath:String = "data/";
			var updatableFile:File = File.applicationStorageDirectory.resolvePath(url);
			var staticFile:File = File.applicationDirectory.resolvePath(staticContainerPath + url);	
					
			localLanguage = Capabilities.language.toLowerCase();
			//localLanguage = "jp";
			
			if(localLanguage != "en")
			{
				var newUrl:String = Config.appendLanguage(url, localLanguage);
				var newStaticFile:File = File.applicationDirectory.resolvePath(staticContainerPath + newUrl);
				if(newStaticFile.exists)
					staticFile = newStaticFile;
			}

			if(Config.isAppFirstTimeRun() || !updatableFile.exists)
				staticFile.copyTo(updatableFile, true);
				
			url = updatableFile.url;
			
			checkForNewLocalQuickStart();
		}
		
		//--------------------------------------------------------------------------
		//  Helper/shared functions
		//--------------------------------------------------------------------------		
		private static function checkForNewLocalQuickStart():void
		{
			var loader:URLLoader = new URLLoader(new URLRequest(Config.QUICK_START_LOCAL_UPDATER_URL));
			loader.addEventListener(Event.COMPLETE, updaterXmlLoaded);
			loader.addEventListener(IOErrorEvent.IO_ERROR, updaterXmlLoadedError);
		}
		
		private static function updaterXmlLoadedError(event:IOErrorEvent):void
		{
		}
				
		private static function updaterXmlLoaded(event:Event):void
		{
			var loader:URLLoader = URLLoader(event.target);
			var updaterXml:XML = new XML(loader.data);
			
			var currentVersion:String = "0";
			var cookie:SharedObject = SharedObject.getLocal(cookieName);			
			if(cookie.data.localQuickStartVersion != null)
				currentVersion = cookie.data.localQuickStartVersion;
			
			onlineVersion = updaterXml.version;
			var onlineVersionDescription:String = updaterXml.description;			
			
			if(onlineVersion > currentVersion)
			{
				onlineVersionUrl = updaterXml.url;
				downloadNewVersion(onlineVersionUrl);
				if(onlineVersionDescription.length > 0)
				{
					// Only show notice if a description was provided, otherwise, silent install
					//Alert.show(onlineVersionDescription, "Updated to Version " + onlineVersion);
				}
			}
		}
		
		private static function downloadNewVersion(path:String):void
		{
			if(localLanguage != "en")
				path = Config.appendLanguage(path, localLanguage);
			
			var loader:URLLoader = new URLLoader(new URLRequest(path));
			loader.addEventListener(Event.COMPLETE, updatedVersionLoaded);	
			loader.addEventListener(IOErrorEvent.IO_ERROR, updatedVersionLoadingError);
		}
		
		private static function updatedVersionLoadingError(event:IOErrorEvent):void
		{
			var loader:URLLoader = new URLLoader(new URLRequest(onlineVersionUrl));
			loader.addEventListener(Event.COMPLETE, updatedVersionLoaded);	
			loader.addEventListener(IOErrorEvent.IO_ERROR, updatedVersionLoadingError);			
		}
		
		private static function updatedVersionLoaded(event:Event):void
		{
			var file:File = File.applicationStorageDirectory;
			file = file.resolvePath(url);
			if(file.exists)
				file.deleteFile();

			var loader:URLLoader = URLLoader(event.target);

			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(loader.data);
			fileStream.close();		
			
			var cookie:SharedObject = SharedObject.getLocal(cookieName);
			cookie.data.localQuickStartVersion = onlineVersion;
			cookie.flush();		
		}		
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------	
	}
}