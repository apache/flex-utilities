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
public final class LogEventLevel
{
	    public static const FATAL:int = 16;
	
	    public static const ERROR:int = 8;
	    
	    public static const WARN:int = 4;
	    
	    public static const INFO:int = 2;
	    
	    public static const DEBUG:int = 1;
	    
	    public static const ALL:int = (DEBUG | INFO | WARN | ERROR | FATAL);
	
	    public static const NONE:int = 0;
	    
	    public static const LoggerLevelList:Array = [DEBUG, INFO, WARN, ERROR, FATAL, ALL];
    
		public static function isValidLevel(level:int) :Boolean {
			for ( var i:int = 0; i < LoggerLevelList.length ; ++i ) {
				if ( (LoggerLevelList[i] == level) )
					return true;
			}
			return false;
		}
		
		public static function isValidMask(mask:int ):Boolean {
			var allMask:int = 0;
			for ( var i:int = 0; i< LoggerLevelList.length; ++i ) {
				allMask = (allMask | (LoggerLevelList[i]));
			}
			if ( (allMask | mask ) == allMask ) return true;
			return false;
		}
		
		public static function getUpperMask(level:int ) :int {
			var result:int = 0;
			if ( !isValidLevel(level) ) {
				throw new IllegalOperationError("Please input an valid level for getUpperMask.");
			} 
			if ( level == ALL) return level;
			for ( var i:int =0; i< LoggerLevelList.length; ++i ) {
				if ( (LoggerLevelList[i] >= level) && (LoggerLevelList[i] < ALL) ) {
					result =result | LoggerLevelList[i];
				}
			}
			return result;
		}


}

}
