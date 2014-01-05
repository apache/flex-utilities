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
    import flash.system.Capabilities;
    import flash.utils.IDataInput;
    
    import mx.core.IFlexModuleFactory;
    import mx.utils.StringUtil;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.TaskHandler;
    
    [Mixin]
    public class Exec extends TaskHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["exec"] = Exec;
        }
        
        public function Exec()
        {
        }
        
        override public function execute(callbackMode:Boolean, context:Object):Boolean
        {
            super.execute(callbackMode, context);
            
            var thisOS:String = Capabilities.os.toLowerCase();
            var osArr:Array = osFamily.split(",");
            var ok:Boolean = false;
            for each (var p:String in osArr)
            {
                if (p.toLowerCase() == "windows")
                    p = "win";
                if (thisOS.indexOf(p.toLowerCase()) != -1)
                {
                    ok = true;
                    break;
                }
            }
            if (!ok) return true;
            
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
            if (numChildren > 0)
            {
                var cmdline:String = fileName;
                for (var i:int = 0; i < numChildren; i++)
                {
                    var arg:Arg = getChildAt(i) as Arg;
                    arg.setContext(context);
                    cmdline += " " + quoteIfNeeded(arg.value);
                }
                args.push(cmdline);
            }
            else
                args.push(fileName);
            nativeProcessStartupInfo.arguments = args;
            if (dir)
            {
                var wd:File;
                wd = File.applicationDirectory;
                wd = wd.resolvePath(dir);
                nativeProcessStartupInfo.workingDirectory = wd;
            }
            
            process = new NativeProcess();
            process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData); 
            process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onOutputErrorData); 
            process.start(nativeProcessStartupInfo);
            process.addEventListener(NativeProcessExitEvent.EXIT, exitHandler);
            
            return false;
        }
        
        private function get dir():String
        {
            return getNullOrAttributeValue("@dir");
        }
        
        private function get fileName():String
        {
            return getAttributeValue("@executable");
        }
        
        private function get osFamily():String
        {
            return getAttributeValue("@osfamily");
        }
        
        private function get outputProperty():String
        {
            return getAttributeValue("@outputproperty");
        }
        
        private var process:NativeProcess;
        
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
            if (outputProperty)
                context[outputProperty] = StringUtil.trim(data);
        }
      
        private function quoteIfNeeded(s:String):String
        {
            // has spaces but no quotes
            if (s.indexOf(" ") != -1 && s.indexOf('"') == -1)
                return '"' + s + '"';
            return s;
        }
    } 
}