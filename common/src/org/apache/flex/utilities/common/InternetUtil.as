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

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;

public class InternetUtil
{

	//--------------------------------------------------------------------------
	//
	//    Class properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//    instance
	//----------------------------------
	
	private static var _instance:InternetUtil;
	
	public static function get instance():InternetUtil
	{
		if (!_instance)
			_instance = new InternetUtil(new SE());
		
		return _instance;
	}
	
	//--------------------------------------------------------------------------
	//
	//    Class methods
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//    getTLDFromURL
	//----------------------------------
	
	public static function getTLDFromURL(url:String):String
	{
		var array:Array;
		
		var result:String = url;
		
		if (result.indexOf(Constants.URL_PREFIX) > -1)
			result = result.split("/")[2];

		array = result.split(".");
		array.shift();

		return array.join(".");;
	}
	
	//--------------------------------------------------------------------------
	//
	//    Constructor
	//
	//--------------------------------------------------------------------------
	
	public function InternetUtil(se:SE) {}
		
	//--------------------------------------------------------------------------
	//
	//    Variables
	//
	//--------------------------------------------------------------------------
	
	private var _callback:Function;
	
	private var _urlLoader:URLLoader;
	
	//--------------------------------------------------------------------------
	//
	//    Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//    errorMessage
	//----------------------------------
	
	private var _errorMessage:String = "";

	public function get errorMessage():String
	{
		return _errorMessage;
	}

	//----------------------------------
	//    errorOccurred
	//----------------------------------
	
	private var _errorOccurred:Boolean;
	
	public function get errorOccurred():Boolean
	{
		return _errorOccurred;
	}
	
	//----------------------------------
	//    result
	//----------------------------------
	
	private var _result:String;
	
	public function get result():String
	{
		return _result;
	}
	
	//--------------------------------------------------------------------------
	//
	//    Methods
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//    fetchResultHandler
	//----------------------------------
	
	private function fetchResultHandler(event:Event):void
	{
		_errorOccurred = event is IOErrorEvent;
		
		if (!_errorOccurred)
			_result = _urlLoader.data;
		else
			_errorMessage = String(IOErrorEvent(event).text);
		
		_callback();
	}
	
	//----------------------------------
	//    fetch
	//----------------------------------
	
	public function fetch(fetchURL:String, fetchCompleteHandler:Function, args:String = null):void
	{
		_callback = fetchCompleteHandler;
		
		_errorMessage = "";
		_errorOccurred = false;
		_result = "";
		
		_urlLoader = new URLLoader();
		_urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
		_urlLoader.addEventListener(Event.COMPLETE, fetchResultHandler);
		_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, fetchResultHandler);
		_urlLoader.load(new URLRequest(fetchURL + ((args) ? "?" + args : "")));
	}
	
}
}

class SE {}