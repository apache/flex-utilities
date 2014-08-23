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
	import air.update.ApplicationUpdaterUI;
	import air.update.events.UpdateEvent;
	
	import flash.desktop.NativeApplication;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import mx.controls.Alert;
	
	public class ApplicationUpdaterManager
	{
		private var appUpdater:ApplicationUpdaterUI = new ApplicationUpdaterUI();
		
		public function ApplicationUpdaterManager()
		{
			appUpdater.updateURL = Config.APP_UPDATER_URL;
			appUpdater.isCheckForUpdateVisible = false;
			//appUpdater.isInstallUpdateVisible = false;
			appUpdater.addEventListener(ErrorEvent.ERROR, appUpdater_error);
			appUpdater.addEventListener(UpdateEvent.INITIALIZED, appUpdater_update);
			appUpdater.initialize();			
		}
		
		private function appUpdater_update(event:UpdateEvent):void 
		{
			appUpdater.checkNow();
		}
		
		private function appUpdater_error(event:ErrorEvent):void
		{
			Alert.show(event.toString());
		}
		
	}
}