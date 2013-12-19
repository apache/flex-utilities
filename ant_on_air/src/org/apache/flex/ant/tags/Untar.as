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
    
    import mx.core.IFlexModuleFactory;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.TaskHandler;
    
    [Mixin]
    public class Untar extends TaskHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["untar"] = Untar;
        }

        public function Untar()
        {
            super();
        }
        
        private var src:String;
        private var dest:String;
        private var overwrite:Boolean;
        
        override protected function processAttribute(name:String, value:String):void
        {
            if (name == "src")
                src = value;
            else if (name == "dest")
                dest = value;
            else if (name == "overwrite")
                overwrite = value == "true";
            else
                super.processAttribute(name, value);
        }
        
        private var destFile:File;
        
        override public function execute(callbackMode:Boolean, context:Object):Boolean
        {
            super.execute(callbackMode, context);
         
            var srcFile:File = File.applicationDirectory.resolvePath(src);
            destFile = File.applicationDirectory.resolvePath(dest);

            untar(srcFile);
            return false;
        }
        
        private var _process:NativeProcess;
        
        private function untar(source:File):void 
        {
            var tar:File;
            var startupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
            var arguments:Vector.<String> = new Vector.<String>();
            
            if (Capabilities.os.indexOf("Linux") != -1)
                tar = new File("/bin/tar");
            else
                tar = new File("/usr/bin/tar");	
            
            arguments.push("xf");
            arguments.push(source.nativePath);
            arguments.push("-C");
            arguments.push(destFile.nativePath);
            
            startupInfo.executable = tar;
            startupInfo.arguments = arguments;
            
            _process = new NativeProcess();
            _process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, unTarFileProgress);
            _process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, unTarError);
            _process.addEventListener(NativeProcessExitEvent.EXIT, unTarComplete);
            _process.start(startupInfo);
        }
        
        private function unTarError(event:Event):void {
            var output:String = _process.standardError.readUTFBytes(_process.standardError.bytesAvailable);
            ant.output(output);
            if (failonerror)
                ant.project.status = false;
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        private function unTarFileProgress(event:Event):void {
            var output:String = _process.standardOutput.readUTFBytes(_process.standardOutput.bytesAvailable);
            ant.output(output);
        }
        
        private function unTarComplete(event:NativeProcessExitEvent):void {
            _process.closeInput();
            _process.exit(true);
            dispatchEvent(new Event(Event.COMPLETE));
        }

    }
}