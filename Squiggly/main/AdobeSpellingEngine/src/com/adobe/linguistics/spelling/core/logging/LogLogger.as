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


package com.adobe.linguistics.spelling.core.logging
{
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
public class LogLogger extends EventDispatcher implements ILogger
{
	public function LogLogger(category:String)
	{
		super();

		_category = category;
	}

	/**
	 *  @private
	 *  Storage for the category property.
	 */
	private var _category:String;

	/**
	 *  The category this logger send messages for.
	 *  
	 */	
	public function get category():String
	{
		return _category;
	}
	
	public function log(level:int, msg:String, ... rest):void
	{
		dispatchLoggerEvent( level, msg, rest);
	}

	public function debug(msg:String, ... rest):void
	{
		dispatchLoggerEvent( LogEventLevel.DEBUG, msg, rest);
	}

	public function error(msg:String, ... rest):void
	{
		dispatchLoggerEvent( LogEventLevel.ERROR, msg, rest);
	}

	public function fatal(msg:String, ... rest):void
	{
		dispatchLoggerEvent( LogEventLevel.FATAL, msg, rest);
	}

	public function info(msg:String, ... rest):void
	{
		dispatchLoggerEvent( LogEventLevel.INFO, msg, rest);
	}

	public function warn(msg:String, ... rest):void
	{
		dispatchLoggerEvent( LogEventLevel.WARN, msg, rest);
	}
	
	private function dispatchLoggerEvent(level:int, msg:String, options:Array):void {
		// we don't want to allow people to log messages at the 
		// Log.Level.ALL level, so throw a RTE if they do
		if ( !LogEventLevel.isValidLevel( level ) )
		{
			throw new IllegalOperationError("Please check for level permit.");
		}
        	
		if (hasEventListener(LogEvent.eventID))
		{
			// replace all of the parameters in the msg string
			for (var i:int = 0; i < options.length; i++)
			{
				msg = msg.replace(new RegExp("\\{"+i+"\\}", "g"), options[i]);
			}

			dispatchEvent(new LogEvent(msg, level));
		}
		
	}
	
}

}
