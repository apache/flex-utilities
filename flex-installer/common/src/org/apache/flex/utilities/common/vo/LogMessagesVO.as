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

package org.apache.flex.utilities.common.vo
{

public final class LogMessagesVO
{

	//--------------------------------------------------------------------------
	//
	//    Constructor
	//
	//--------------------------------------------------------------------------
	
	public function LogMessagesVO(action:String, success:String, error:String) 
	{
		_action = action;
		_success = success;
		_error = error;
	}
	
	//--------------------------------------------------------------------------
	//
	//    Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//    action
	//----------------------------------
	
	private var _action:String;

	public function get action():String

	{
		return _action;
	}

	//----------------------------------
	//    success
	//----------------------------------
	
	private var _success:String;

	public function get success():String

	{
		return _success;
	}

	//----------------------------------
	//    error
	//----------------------------------
	
	private var _error:String;

	public function get error():String

	{
		return _error;
	}

}
}
