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
            
            if (name && (value || location || refid) && !context.hasOwnProperty(name))
            {
                if (value)
                    context[name] = value;
                else if (refid)
                    context[name] = context[ant.project.refids[refid]];
                else
                    context[name] = location;
            }
            else if (fileName != null)
            {
                try {
                    var f:File = new File(fileName);
                } 
                catch (e:Error)
                {
                    ant.output(fileName);
                    ant.output(e.message);
                    if (failonerror)
					{
						ant.project.failureMessage = e.message;
                        ant.project.status = false;
					}
                    return true;							
                }
                
                if (f.exists)
                {
                    var fs:FileStream = new FileStream();
                    fs.open(f, FileMode.READ);
                    var data:String = fs.readUTFBytes(fs.bytesAvailable);
                    var propLines:Array = data.split("\n");
                    var collectingParts:Boolean;
                    var val:String;
                    var key:String;
                    for each (var line:String in propLines)
                    {
                        if (line.charAt(line.length - 1) == "\r")
                            line = line.substr(0, line.length - 1);
                        if (collectingParts)
                        {
                            if (line.charAt(line.length - 1) == "\\")
                                val += line.substr(0, line.length - 1);
                            else
                            {
                                collectingParts = false;
                                val += line;
                                val = StringUtil.trim(val);
                                val = val.replace(/\\n/g, "\n");
                                if (!context.hasOwnProperty(key))
                                    context[key] = ant.getValue(val, context);
                            }
                            continue;
                        }
                        var parts:Array = line.split("=");
                        if (parts.length >= 2)
                        {
                            key = StringUtil.trim(parts[0]);
                            if (parts.length == 2)
                                val = parts[1];
                            else
                            {
                                parts.shift();
                                val = parts.join("=");
                            }
                            if (val.charAt(val.length - 1) == "\\")
                            {
                                collectingParts = true;
                                val = val.substr(0, val.length - 1);
                            }
                            else if (!context.hasOwnProperty(key))
                                context[key] = ant.getValue(StringUtil.trim(val), context);
                        }
                        
                    }
                    fs.close();                
                }
            }
            else if (envPrefix != null)
            {
                requestEnvironmentVariables();
                return false;
            }
            return true;
        }
        
        private function get fileName():String
        {
            return getNullOrAttributeValue("@file");
        }
        
        private function get refid():String
        {
            return getNullOrAttributeValue("@refid");
        }
        
        private function get value():String
        {
            return getNullOrAttributeValue("@value");
        }
        
        private function get location():String
        {
            return getNullOrAttributeValue("@location");
        }
        
        private function get envPrefix():String
        {
            return getNullOrAttributeValue("@environment");
        }
        
        private var process:NativeProcess;
        
        public function requestEnvironmentVariables():void
        {
            var file:File = File.applicationDirectory;
            if (Capabilities.os.toLowerCase().indexOf('win') == -1)
                file = new File("/bin/bash");
            else
                file = file.resolvePath("C:\\Windows\\System32\\cmd.exe");
            var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
            nativeProcessStartupInfo.executable = file;
            var args:Vector.<String> = new Vector.<String>();
            if (Capabilities.os.toLowerCase().indexOf('win') == -1)
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
            var prefix:String = envPrefix;
            for each (var line:String in propLines)
            {
                var parts:Array = line.split("=");
                if (parts.length >= 2)
                {
                    var key:String = envPrefix + "." + StringUtil.trim(parts[0]);
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