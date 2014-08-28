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


package com.adobe.linguistics.spelling.core.logging.targets
{
	import com.adobe.linguistics.spelling.core.logging.*;
	public class CollectionTarget extends AbstractTarget
	{
	    public var fieldSeparator:String = " ";
	
	    public var includeCategory:Boolean;
	
	    public var includeDate:Boolean;
	
	    public var includeLevel:Boolean;
	
	    public var includeTime:Boolean;

	    protected var date:String = "";
	    protected var time:String = "";
	    protected var levelString:String = "";
	    protected var category:String = "";
		
		public function CollectionTarget(usingLevelMaskMode:Boolean = false)
		{
	        super(usingLevelMaskMode);
	        includeTime = false;
	        includeDate = false;
	        includeCategory = false;
	        includeLevel = false;
		}

	    override public function logEvent(event:LogEvent):void
	    {
	    	date = "";
	    	time = "";
	    	levelString = "";
	    	category = "";
	        if (includeDate || includeTime)
	        {
	            var d:Date = new Date();
	            if (includeDate)
	            {
	                date = Number(d.getMonth() + 1).toString() + "/" +
	                       d.getDate().toString() + "/" + 
	                       d.getFullYear();
	            }   
	            if (includeTime)
	            {
	                time += padTime(d.getHours()) + ":" +
	                        padTime(d.getMinutes()) + ":" +
	                        padTime(d.getSeconds()) + "." +
	                        padTime(d.getMilliseconds(), true);
	            }
	        }
	        
	        if (includeLevel)
	        {
	            levelString = LogEvent.getLevelString(event.level);
	        }
	
	        category = includeCategory ? ILogger(event.target).category:"";
	
	        internalLog(event.message,event.level);
	    }
	    
	    private function padTime(num:Number, millis:Boolean = false):String
	    {
	        if (millis)
	        {
	            if (num < 10)
	                return "00" + num.toString();
	            else if (num < 100)
	                return "0" + num.toString();
	            else 
	                return num.toString();
	        }
	        else
	        {
	            return num > 9 ? num.toString() : "0" + num.toString();
	        }
	    }
	
	    public function internalLog(message:String, level:int):void
	    {
	        // override this method to perform the redirection to the desired output
	    }

	}
}