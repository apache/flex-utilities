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

import flash.events.Event;

public class LogEvent extends Event
{
    public static const eventID:String = "com.adobe.linguistics.spelling.core.logging.LogEvent";

    public static function getLevelString(value:uint):String
    {
        switch (value)
        {
            case LogEventLevel.INFO:
			{
                return "INFO";
			}

            case LogEventLevel.DEBUG:
			{
                return "DEBUG";
            }

            case LogEventLevel.ERROR:
			{
                return "ERROR";
            }

            case LogEventLevel.WARN:
			{
                return "WARN";
            }

            case LogEventLevel.FATAL:
			{
                return "FATAL";
            }

            case LogEventLevel.ALL:
			{
                return "ALL";
            }
		}

		return "UNKNOWN";
    }

    public function LogEvent(message:String = "",
							 level:int = 31 /* LogEventLevel.ALL */)
    {
        super(LogEvent.eventID, false, false);

        this.message = message;
        this.level = level;
    }

    public var level:int;

    public var message:String;

    override public function clone():Event
    {
        return new LogEvent(message, /*type,*/ level);
    }
}

}