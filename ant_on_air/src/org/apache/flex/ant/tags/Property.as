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
package org.apache.flex.ant.tags
{
    import flash.desktop.NativeProcess;
    import flash.desktop.NativeProcessStartupInfo;
    import flash.events.Event;
    import flash.events.NativeProcessExitEvent;
    import flash.events.ProgressEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.system.Capabilities;
    import flash.utils.IDataInput;
    
    import mx.core.IFlexModuleFactory;
    import mx.utils.StringUtil;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.TaskHandler;
    
    [Mixin]
    public class Property extends TaskHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["property"] = Property;
        }

        public function Property()
        {
        }
        
        override public function execute(callbackMode:Boolean, context:Object):Boolean
        {
			super.execute(callbackMode, context);
			
            if (name && value && !context.hasOwnProperty(name))
                context[name] = value;
            else if (fileName != null)
            {
                var f:File = new File(fileName);
                var fs:FileStream = new FileStream();
                fs.open(f, FileMode.READ);
                var data:String = fs.readUTFBytes(fs.bytesAvailable);
                var propLines:Array = data.split("\n");
                for each (var line:String in propLines)
                {
                    var parts:Array = line.split("=");
                    if (parts.length >= 2)
                    {
                        var key:String = StringUtil.trim(parts[0]);
                        var val:String;
                        if (parts.length == 2)
                            val = parts[1];
                        else
                        {
                            parts.shift();
                            val = parts.join("=");
                        }
                        if (!context.hasOwnProperty(key))
                            context[key] = val;
                    }
                    
                }
                fs.close();                
            }
            else if (envPrefix != null)
            {
                requestEnvironmentVariables();
                return false;
            }
            return true;
        }
        
        private var fileName:String;
        private var value:String;
        private var envPrefix:String;
        
        override protected function processAttribute(name:String, value:String):void
        {
            if (name == "file")
            {
                fileName = value;
            }
            else if (name == "value")
            {
                this.value = value;
            }
            else if (name == "environment")
            {
                envPrefix = value;
            }
            else
                super.processAttribute(name, value);
        }
        
        private var process:NativeProcess;
        
        public function requestEnvironmentVariables():void
        {
            var file:File = File.applicationDirectory;
            if (Capabilities.os.indexOf('Mac OS') > -1)
                file = new File("/bin/bash");
            else
                file = file.resolvePath("C:\\Windows\\System32\\cmd.exe");
            var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
            nativeProcessStartupInfo.executable = file;
            var args:Vector.<String> = new Vector.<String>();
            if (Capabilities.os.indexOf('Mac OS') > -1)
                args.push("-c");
			else
				args.push("/c");
            args.push("set");
            nativeProcessStartupInfo.arguments = args;
            process = new NativeProcess();
            process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData); 
            process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onOutputErrorData); 
            process.start(nativeProcessStartupInfo);
            process.addEventListener(NativeProcessExitEvent.EXIT, exitHandler);
        }
         
        private function exitHandler(event:NativeProcessExitEvent):void
        {
            dispatchEvent(new Event(Event.COMPLETE));
        }

        private function onOutputErrorData(event:ProgressEvent):void 
        { 
            var stdError:IDataInput = process.standardError; 
            var data:String = stdError.readUTFBytes(process.standardError.bytesAvailable); 
            trace("Got Error Output: ", data); 
        }
        
        private function onOutputData(event:ProgressEvent):void 
        { 
            var stdOut:IDataInput = process.standardOutput; 
            var data:String = stdOut.readUTFBytes(process.standardOutput.bytesAvailable); 
            trace("Got: ", data); 
            var propLines:Array;
			if (Capabilities.os.indexOf('Mac OS') > -1)
				propLines = data.split("\n");
			else
				propLines = data.split("\r\n");
            for each (var line:String in propLines)
            {
                var parts:Array = line.split("=");
                if (parts.length >= 2)
                {
                    var key:String = StringUtil.trim(parts[0]);
                    var val:String;
                    if (parts.length == 2)
                        val = parts[1];
                    else
                    {
                        parts.shift();
                        val = parts.join("=");
                    }
                    if (!context.hasOwnProperty(key))
                        context[key] = val;
                }
            }
        }

    } 
}