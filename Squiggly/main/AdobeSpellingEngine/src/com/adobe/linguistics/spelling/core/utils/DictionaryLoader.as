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



package com.adobe.linguistics.spelling.core.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	public class DictionaryLoader extends EventDispatcher
	{
		private var dataloader:URLLoader;
		private var _data:ByteArray;
		public function DictionaryLoader(request:URLRequest=null)
		{
			dataloader = new URLLoader();
			dataloader.dataFormat = URLLoaderDataFormat.BINARY;
			dataloader.addEventListener(Event.COMPLETE,handleComplete);
			dataloader.addEventListener(IOErrorEvent.IO_ERROR,handleError);
			dataloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleError);
			if (request) { 
				try {
					load(request); 
				}
				catch (error:Error) {
									
				}
			}
			else 
			{
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function get bytesTotal():uint {
			return dataloader.bytesTotal;
		}
		
		public function get data():ByteArray {
			return this._data;
		}

		public function load(request:URLRequest):void {
			_data = null;
			//trace("Before Actual load: "+getTimer()+" "+dataloader.bytesLoaded);
			dataloader.load(request);
			
		}

		private function handleComplete(evt:Event):void {
			// add to-do function.
			this._data = (dataloader.data as ByteArray);
			dispatchEvent(new Event(Event.COMPLETE));
		}

		private function handleError(evt:Event):void {
			bounceEvent(evt);
		}
		
		private function bounceEvent(evt:Event):void {
			dispatchEvent(evt.clone());
		}
		
		public function getData(): ByteArray {
			return this._data;
		}
		

	}
}