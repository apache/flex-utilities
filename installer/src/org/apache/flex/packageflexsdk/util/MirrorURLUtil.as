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

package org.apache.flex.packageflexsdk.util
{
import mx.collections.ArrayCollection;

import org.apache.flex.packageflexsdk.resource.ViewResourceConstants;

public class MirrorURLUtil
{

	//--------------------------------------------------------------------------
	//
	//    Class properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//    instance
	//----------------------------------
	
	private static var _instance:MirrorURLUtil;
	
	public static function get instance():MirrorURLUtil
	{
		if (!_instance)
			_instance = new MirrorURLUtil(new SE());
		
		return _instance;
	}
	
	//--------------------------------------------------------------------------
	//
	//    Constructor
	//
	//--------------------------------------------------------------------------
	
	public function MirrorURLUtil(se:SE) 
	{
		_internetUtil = InternetUtil.instance;
		
		_constants = ViewResourceConstants.getInstance();
	}
		
	//--------------------------------------------------------------------------
	//
	//    Constants
	//
	//--------------------------------------------------------------------------
	
	private const FIRST:String = "first";
	private const SECOND:String = "second";
	
	//--------------------------------------------------------------------------
	//
	//    Variables
	//
	//--------------------------------------------------------------------------
	
	private var _callback:Function;
	private var _internetUtil:InternetUtil;
	private var _log:ArrayCollection;
	private var _mirrorFetchStep:String;
	private var _constants:ViewResourceConstants;
	private var _userCountryCode:String;
	
	//--------------------------------------------------------------------------
	//
	//    Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//    url
	//----------------------------------
	
	private var _url:String;

	public function get url():String
	{
		return _url;
	}

	//--------------------------------------------------------------------------
	//
	//    Methods
	//
	//--------------------------------------------------------------------------
	
	private function addLogLine(line:String):void
	{
		_log.addItem(line);
	}
	
	//----------------------------------
	//    fetchGeoIPResult
	//----------------------------------
	
	private function fetchGeoIPResult():void
	{
		if (!_internetUtil.errorOccurred)
		{
			addLogLine(_constants.FETCH_GEO_IP_DONE);
			
			_userCountryCode = _internetUtil.result.toLowerCase();
			
			addLogLine(_constants.FETCH_MIRROR_LIST);
			
			_internetUtil.fetch(ViewResourceConstants.URL_FETCH_MIRROR_LIST, fetchMirrorListResult);
		}
		else
		{
			addLogLine(_constants.FETCH_GEO_IP_ERROR);
			
			addLogLine(_constants.ERROR_MIRROR_FETCH + _internetUtil.errorMessage);
			
			_callback(true, _log);
		}
	}
	
	//----------------------------------
	//    fetchMirrorListResult
	//----------------------------------
	
	private function fetchMirrorListResult():void
	{
		var abort:Boolean;
		
		if (!_internetUtil.errorOccurred)
		{
			addLogLine(_constants.FETCH_MIRROR_LIST_DONE);
			
			var mirrorListArrayFiltered:Array = [];
			var mirrorListArrayRaw:Array = _internetUtil.result.split("\n");
			
			var i:int;
			var n:int = mirrorListArrayRaw.length;
			var mirrorArray:Array;
			for (i = n - 1; i > -1; i--)
			{
				mirrorArray = mirrorListArrayRaw[i].split(" ");
				if (mirrorArray[0] == "http" && mirrorArray[1] == _userCountryCode)
				{
					mirrorListArrayFiltered.push(mirrorArray[2]);
				}
			}
			
			n = mirrorListArrayFiltered.length;
			i = Math.floor(Math.random() * n);
			
			_url = mirrorListArrayFiltered[i];
			
			addLogLine(_constants.FETCH_MIRROR_LIST_PARSED + "'" + _url + "'");
		}
		else
		{
			addLogLine(_constants.ERROR_MIRROR_FETCH + _internetUtil.errorMessage);

			abort = true;
		}
		
		_callback(abort, _log);
	}
	
	//----------------------------------
	//    fetchMirrorFromCGIResult
	//----------------------------------
	
	private function fetchMirrorFromCGIResult():void 
	{
		if (!_internetUtil.errorOccurred)
		{
			addLogLine(_constants.FETCH_MIRROR_CGI_DONE);
			
			var result:String = _internetUtil.result;
			if(result.search("<p>") != -1)
			{
				result = result.substring(3,result.length-4);
			}
			
			_url = result;
			
			_callback(false, _log);
		}
		else
		{
			addLogLine(_constants.FETCH_MIRROR_CGI_ERROR);
			
			addLogLine(_constants.FETCH_GEO_IP);
			
			_internetUtil.fetch(ViewResourceConstants.URL_FETCH_GEO_IP, fetchGeoIPResult);
		}
	}
	
	//----------------------------------
	//    getMirrorURL
	//----------------------------------
	
	public function getMirrorURL(callback:Function):void
	{
		_callback = callback;
	
		_log = new ArrayCollection();
		
		addLogLine(_constants.FETCH_MIRROR_CGI);

		_internetUtil.fetch(ViewResourceConstants.URL_FETCH_MIRROR_CGI, fetchMirrorFromCGIResult);
	}
	
}
}

class SE {}