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
public class AbstractTarget implements ILoggingTarget
{
	private var _usingLevelMaskMode:Boolean;
    public function AbstractTarget(usingLevelMaskMode:Boolean = false)
    {
        super();
        this._usingLevelMaskMode = usingLevelMaskMode;

//        _id = UIDUtil.createUID();
    }

    private var _loggerCount:uint = 0;

    private var _filters:Array = [ "*" ];

    public function get filters():Array
    {
        return _filters;
    }

    public function set filters(value:Array):void
    {
        if (value && value.length > 0)
        {
            // a valid filter value will be fully qualified or have a wildcard
            // in it.  the wild card can only be located at the end of the
            // expression.  valid examples  xx*, xx.*,  *
            var filter:String;
            var index:int;
            var message:String;
            for (var i:uint = 0; i<value.length; i++)
            {
                filter = value[i];
                  // check for invalid characters
                if (Log.hasIllegalCharacters(filter))
                {
                    throw new IllegalOperationError("Please check for invalid characters.");
                }

                index = filter.indexOf("*");
                if ((index >= 0) && (index != (filter.length -1)))
                {
                    throw new IllegalOperationError("Please check for invalid filters.");
                }
            } // for
        }
        else
        {
            // if null was specified then default to all
            value = ["*"];
        }

        if (_loggerCount > 0)
        {
            Log.removeTarget(this);
            _filters = value;
            Log.addTarget(this);
        }
        else
        {
            _filters = value;
        }
    }

    private var _id:String;

     public function get id():String
     {
         return _id;
     }
    
    private var _level:int = LogEventLevel.ALL;

    public function get level():int
    {
        return _level;
    }

    /**
     *  @private
     */
    public function set level(value:int):void
    {
    	if ( this._usingLevelMaskMode == false ) {
	    	if ( !LogEventLevel.isValidLevel(value) ) {
	    		throw new IllegalOperationError("Please set an valid level in the level setter.");
	    	}
	    	
	    	this._mask = LogEventLevel.getUpperMask(value);
    	}else {
	    	if ( !LogEventLevel.isValidMask(value) ) {
	    		throw new IllegalOperationError("Please set an valid mask in the mask setter.");
	    	}
	    	this._mask = value;
    	}
        // A change of level may impact the target level for Log.
        Log.removeTarget(this);
        _level = value;
        Log.addTarget(this);        
    }
    
    
    private var _mask:int = LogEventLevel.ALL;
    public function get mask():int {
    	return this._mask;
    }
    
    
    public function addLogger(logger:ILogger):void
    {
        if (logger)
        {
            _loggerCount++;
            logger.addEventListener(LogEvent.eventID, logHandler);
        }
    }

    public function removeLogger(logger:ILogger):void
    {
        if (logger)
        {
            _loggerCount--;
            logger.removeEventListener(LogEvent.eventID, logHandler);
        }
    }

    public function initialized(document:Object, id:String):void
    {
        _id = id;
        Log.addTarget(this);
    }

    public function logEvent(event:LogEvent):void
    {
    }

    private function logHandler(event:LogEvent):void
    {
        if ( (event.level & mask) != 0)
            logEvent(event);
    }
}

}
