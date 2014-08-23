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
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class Preferences
	{
		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		private static var filePath:String = "preferences.xml";
		[Bindable] public static var preferencesXml:XML = <Preferences />;
		
		//--------------------------------------------------------------------------
		//  Loading/setup
		//--------------------------------------------------------------------------
		public function Preferences()
		{

		}
		
		public static function load():void
		{
			var preferencesFile:File = File.applicationStorageDirectory.resolvePath(filePath);
			if(preferencesFile.exists)
			{
				var fileStream:FileStream = new FileStream();
				fileStream.open(preferencesFile, FileMode.READ);
				preferencesXml = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
				fileStream.close();
			}
		}
		
		//--------------------------------------------------------------------------
		//  Saving
		//--------------------------------------------------------------------------		
		public static function save():void
		{			
			var preferencesFile:File = File.applicationStorageDirectory.resolvePath(filePath);
			var fileStream:FileStream = new FileStream();
			fileStream.open(preferencesFile, FileMode.WRITE);
			fileStream.writeUTFBytes(preferencesXml.toXMLString());
			fileStream.close();
		}
		
		//--------------------------------------------------------------------------
		//--------------------------------------------------------------------------
	}
}