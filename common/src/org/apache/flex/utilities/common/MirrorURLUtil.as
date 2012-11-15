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

import mx.collections.ArrayCollection;

import org.apache.flex.utilities.common.vo.LogMessagesVO;
import org.apache.flex.utilities.common.interfaces.ILog;

public class MirrorURLUtil implements ILog
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
	}
		
	//--------------------------------------------------------------------------
	//
	//    Constants
	//
	//--------------------------------------------------------------------------
	
	private const ACTION:String = "action";
	private const ERROR:String = "error";
	private const SUCCESS:String = "success";
	
	//--------------------------------------------------------------------------
	//
	//    Variables
	//
	//--------------------------------------------------------------------------
	
	private var _callback:Function;
	private var _internetUtil:InternetUtil;
	private var _mirrorFetchStep:String;
	private var _userCountryCode:String;
	
	//--------------------------------------------------------------------------
	//
	//    Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//    errorOccurred
	//----------------------------------
	
	private var _errorOccurred:Boolean;
	
	public function get errorOccurred():Boolean
	{
		return _errorOccurred;
	}
	
	//----------------------------------
	//    log
	//----------------------------------
	
	private var _log:ArrayCollection;

	public function get log():ArrayCollection
	{
		return _log;
	}

	//----------------------------------
	//    logMessages
	//----------------------------------
	
	private var _logMessages:LogMessagesVO;

	public function get logMessages():LogMessagesVO
	{
		return _logMessages;
	}

	public function set logMessages(value:LogMessagesVO):void
	{
		_logMessages = value;
	}

	//----------------------------------
	//    mirrorURL
	//----------------------------------
	
	private var _mirrorURL:String;

	public function get mirrorURL():String
	{
		return _mirrorURL;
	}
	
	//--------------------------------------------------------------------------
	//
	//    Methods
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//    addLogItem
	//----------------------------------
	
	private function addLogItem(messageType:String):void 
	{
		if (_logMessages)
		{
			switch (messageType)
			{
				case ACTION :
				{
					_log.addItem(_logMessages.action);
					
					break;
				}
					
				case ERROR :
				{
					_log.addItem(_logMessages.error);
					
					break;
				}
					
				case SUCCESS :
				{
					_log.addItem(_logMessages.success);
					
					break;
				}
			}
		}
	}
	
	//----------------------------------
	//    fetchMirrorFromCGIResult
	//----------------------------------
	
	private function fetchMirrorFromCGIResult():void 
	{
		_errorOccurred = _internetUtil.errorOccurred;
		
		if (!_errorOccurred)
		{
			addLogItem(SUCCESS);
			
			var result:String = _internetUtil.result;
			
			_mirrorURL = (result.search("<p>") != -1) ? 
				result.substring(3, result.length - 4) : 
				result;
		}
		else
		{
			addLogItem(ERROR);
		}
		
		_callback();
	}
	
	//----------------------------------
	//    getMirrorURL
	//----------------------------------
	
	public function getMirrorURL(fetchURL:String, callback:Function):void
	{
		_callback = callback;
	
		_log = new ArrayCollection();
		
		//_log.addItem(ACTION);

		_internetUtil.fetch(fetchURL, fetchMirrorFromCGIResult);
	}
	
}
}

class SE {}
