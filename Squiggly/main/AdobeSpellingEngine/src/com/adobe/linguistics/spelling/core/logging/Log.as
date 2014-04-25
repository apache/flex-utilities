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
public class Log
{

    private static var _targetLevel:int = LogEventLevel.NONE;
        // Initialize target level to a value out of range.

    private static var _loggers:Array;

    private static var _targets:Array = [];

	
    public static function isFatal():Boolean
    {
        return (_targetLevel & LogEventLevel.FATAL) ? true : false;
    }
    
    public static function isError():Boolean
    {
        return (_targetLevel & LogEventLevel.ERROR) ? true : false;
    }
    
    public static function isWarn():Boolean
    {
        return (_targetLevel & LogEventLevel.WARN) ? true : false;
    }

    public static function isInfo():Boolean
    {
        return (_targetLevel & LogEventLevel.INFO) ? true : false;
    }
    
    public static function isDebug():Boolean
    {
        return (_targetLevel & LogEventLevel.DEBUG) ? true : false;
    }

    public static function addTarget(target:ILoggingTarget):void
    {
        if (target)
        {
            var filters:Array = target.filters;
            var logger:ILogger;
            // need to find what filters this target matches and set the specified
            // target as a listener for that logger.
            for (var i:String in _loggers)
            {
                if (categoryMatchInFilterList(i, filters))
                    target.addLogger(ILogger(_loggers[i]));
            }
            // if we found a match all is good, otherwise we need to
            // put the target in a waiting queue in the event that a logger
            // is created that this target cares about.
            _targets.push(target);
            
            if (_targetLevel == LogEventLevel.NONE)
                _targetLevel = target.mask;
            else{
            	_targetLevel = _targetLevel | target.mask;
            }
        }
        else
        {
            throw new IllegalOperationError("addTarget function did not receive null object.");
        }
    }

    public static function removeTarget(target:ILoggingTarget):void
    {
        if (target)
        {
            var filters:Array = target.filters;
            var logger:ILogger;
            // Disconnect this target from any matching loggers.
            for (var i:String in _loggers)
            {
                if (categoryMatchInFilterList(i, filters))
                {
                    target.removeLogger(ILogger(_loggers[i]));
                }                
            }
            // Remove the target.
            for (var j:int = 0; j<_targets.length; j++)
            {
                if (target == _targets[j])
                {
                    _targets.splice(j, 1);
                    j--;
                }
            }
            resetTargetLevel();
        }
        else
        {
            throw new IllegalOperationError("addHandle function did not receive null object.");
        }
    }

    public static function getLogger(category:String):ILogger
    {
        checkCategory(category);
        if (!_loggers)
            _loggers = [];
		var newFlag:Boolean = false;
        // get the logger for the specified category or create one if it
        // doesn't exist
        var result:ILogger = _loggers[category];
        if (result == null)
        {
            result = new LogLogger(category);
            _loggers[category] = result;
            newFlag = true;
        }

        // check to see if there are any targets waiting for this logger.
        var target:ILoggingTarget;
        for (var i:int = 0; (i < _targets.length)&&(newFlag); i++)
        {
            target = ILoggingTarget(_targets[i]);
            if (categoryMatchInFilterList(category, target.filters))
                target.addLogger(result);
        }

        return result;
    }

    public static function flush():void
    {
        _loggers = [];
        _targets = [];
        _targetLevel = LogEventLevel.NONE;
    }

    public static function hasIllegalCharacters(value:String):Boolean
    {
        return value.search(/[\[\]\~\$\^\&\\(\)\{\}\+\?\/=`!@#%,:;'"<>\s]/) != -1;
    }

    private static function categoryMatchInFilterList(category:String, filters:Array):Boolean
    {
        var result:Boolean = false;
        var filter:String;
        var index:int = -1;
        for (var i:uint = 0; i < filters.length; i++)
        {
            filter = filters[i];
            // first check to see if we need to do a partial match
            // do we have an asterisk?
            index = filter.indexOf("*");

            if (index == 0)
                return true;

            index = index < 0 ? index = category.length : index -1;

            if (category.substring(0, index) == filter.substring(0, index))
                return true;
        }
        return false;
    }

    private static function checkCategory(category:String):void
    {
        var message:String;
        
        if (category == null || category.length == 0)
        {
            throw new IllegalOperationError("checkCategory function did not receive null object.");
        }

        if (hasIllegalCharacters(category) || (category.indexOf("*") != -1))
        {
            throw new IllegalOperationError("checkCategory function did not receive invalid characters.");
        }
    }
    
    private static function resetTargetLevel():void
    {	
    	var res:int = 0;
        for (var i:int = 0; i < _targets.length; i++)
        {
            res = ( res | (_targets[i].mask) );
        }
        _targetLevel = res;
    }
}

}
