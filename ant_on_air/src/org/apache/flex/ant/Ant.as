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
package org.apache.flex.ant
{
    
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    
    import org.apache.flex.ant.tags.Project;
    import org.apache.flex.xml.XMLTagProcessor;
    
    /**
     *  An XMLTagProcessor that tries to emulate Apache Ant
     */
    public class Ant extends XMLTagProcessor
    {
        /**
         *  Constructor 
         */
        public function Ant()
        {
            super();
            ant = this;
        }
        
        /**
         *  @private
         *  The file being processed.  Used to determine basedir. 
         */
        private var file:File;
        
        /**
         *   Open a file, read the XML, create ITagHandlers for every tag, then process them.
         *   When finished, check the project's status property.  If it is true then all
         *   tasks completed successfully
         *   @param file File The file to open.
         *   @param context Object An object containing an optional targets property listing the targets to run.
         *   @return true if XML file was processed synchronously.  If false, then add listener for Event.COMPLETE.
         */
        public function processXMLFile(file:File, context:Object = null, callbackMode:Boolean = true):Boolean
        {
			Ant.ants.push(this);
            this.file = file;
            var fs:FileStream = new FileStream();
            fs.open(file, FileMode.READ);
            var s:String = fs.readUTFBytes(fs.bytesAvailable);
            var xml:XML = XML(s);
            fs.close();

            tagMap = antTagProcessors;
            if (!context)
                context = {};
            this.context = context;
            var project:Project = processXMLTag(xml) as Project;
            var basedir:String = project.basedir;
            if (basedir == "")
                basedir = ".";
            try {
                basedir = file.parent.resolvePath(basedir).nativePath;
            } 
            catch (e:Error)
            {
                ant.output(basedir);
                ant.output(e.message);
				ant.project.failureMessage = e.message;
                ant.project.status = false;
                return true;							
            }
            
            context.basedir = basedir;
            this.project = project;
            if (!project.execute(callbackMode, context))
            {
                project.addEventListener(Event.COMPLETE, completeHandler);
                return false;                
            }
			if (Ant.ants.length > 1)
			{
				var status:Boolean = ant.project.status;
				var failureMessage:String = ant.project.failureMessage;
				Ant.ants.pop();
				if (!status)
				{
					currentAnt.project.status = status;
					currentAnt.project.failureMessage = failureMessage;
				}
			}
            return true;
        }
    
		private var _functionToCall:Function;
		
        /**
         *  Set by various classes to defer processing in callbackMode
         */
        public function set functionToCall(value:Function):void
		{
			if (parentAnt)
				parentAnt.functionToCall = value;
			else
				_functionToCall = value;
		}
        
		public function get functionToCall():Function
		{
			return _functionToCall;
		}
		
        /**
         *  If you set callbackMode = true, you must call this method until you receive
         *  the Event.COMPLETE 
         */
        public function doCallback():void   
        {
            if (functionToCall != null)
            {
                var f:Function = functionToCall;
                functionToCall = null;
                f();
            }
        }
        
        /** 
         * the instance of the class dispatching progress events
         */
        public var progressClass:Object;
        
        private var context:Object;
		public var parentAnt:Ant;
        public var ant:Ant;
        public var project:Project;
		
		// the stack of ant instances (ant can call <ant/>)
		public static var ants:Array = [];
		
		public static function get currentAnt():Ant
		{
			if (ants.length == 0)
				return null;
			return ants[ants.length - 1] as Ant;
		}
		
        private function completeHandler(event:Event):void
        {
			if (Ant.ants.length > 1)
			{
				var status:Boolean = ant.project.status;
				var failureMessage:String = ant.project.failureMessage;
				Ant.ants.pop();
				if (!status)
				{
					currentAnt.project.status = status;
					currentAnt.project.failureMessage = failureMessage;
				}
			}
            event.target.removeEventListener(Event.COMPLETE, completeHandler);
            dispatchEvent(event);
        }
        
        /**
         *  The map of XML tags to classes
         */
        public static var antTagProcessors:Object = {};
        
        /**
         *  Adds a class to the map.
         *  
         *  @param tagQName String The QName.toString() of the tag
         *  @param processor Class The class that will process the tag. 
         */
        public static function addTagProcessor(tagQName:String, processor:Class):void
        {
            antTagProcessors[tagQName] = processor;
        }

        /**
         *  Does string replacements based on properties in the context object.
         * 
         *  @param input String The input string.
         *  @param context Object The object of property values.
         *  @return String The input string with replaced values.
         */
        public function getValue(input:String, context:Object):String
        {
            var i:int = input.indexOf("${");
            while (i != -1)
            {
                if (i == 0 || (i > 0 && input.charAt(i - 1) != "$"))
                {
                    var c:int = input.indexOf("}", i);
                    if (c != -1)
                    {
                        var token:String = input.substring(i + 2, c);
                        if (context.hasOwnProperty(token))
                        {
                            var rep:String = context[token];
                            input = input.replace("${" + token + "}", rep);
                            i += rep.length - token.length - 3;
                        }
                    }
                }
                else if (i > 0 && input.charAt(i - 1) == "$")
                {
                    input = input.substring(0, i - 1) + input.substring(i);
                    i++;
                }                    
                i++;
                i = input.indexOf("${", i);
            }
            return input;
        }
		
		public static const spaces:String = "           ";
		
		public function formatOutput(tag:String, data:String):String
		{
			var s:String = spaces.substr(0, Math.max(spaces.length - tag.length - 2, 0)) +
				"[" + tag + "] " + data;
			return s;
		}
        
		public static function log(s:String, level:int):void
		{
			currentAnt.output(s);	
		}
		
        /**
         *  Output for Echo.  Defaults to trace().
         */
        public var output:Function = function(s:String):void { trace(s) };
        
    }
}