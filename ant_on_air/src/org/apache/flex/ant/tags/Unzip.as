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
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.ByteArray;
    
    import mx.core.IFlexModuleFactory;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.TaskHandler;
    import org.as3commons.zip.Zip;
    import org.as3commons.zip.ZipEvent;
    import org.as3commons.zip.ZipFile;
    
    [Mixin]
    public class Unzip extends TaskHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["unzip"] = Unzip;
        }

        public function Unzip()
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

            unzip(srcFile);
            return true;
        }
        
        private function unzip(fileToUnzip:File):void {
            var zipFileBytes:ByteArray = new ByteArray();
            var fs:FileStream = new FileStream();
            var fzip:Zip = new Zip();
            
            fs.open(fileToUnzip, FileMode.READ);
            fs.readBytes(zipFileBytes);
            fs.close();
            
            fzip.addEventListener(ZipEvent.FILE_LOADED, onFileLoaded);
            fzip.addEventListener(Event.COMPLETE, onUnzipComplete, false, 0, true);
            fzip.addEventListener(ErrorEvent.ERROR, onUnzipError, false, 0, true);

            // synchronous, so no progress events
            fzip.loadBytes(zipFileBytes);
        }
        
        private function isDirectory(f:ZipFile):Boolean {
            if (f.filename.substr(f.filename.length - 1) == "/" || f.filename.substr(f.filename.length - 1) == "\\") {
                return true;
            }
            return false;
        }
        
        private function onFileLoaded(e:ZipEvent):void {
            try {
                var fzf:ZipFile = e.file;
                var f:File = destFile.resolvePath(fzf.filename);
                var fs:FileStream = new FileStream();
                
                if (isDirectory(fzf)) {
                    // Is a directory, not a file. Dont try to write anything into it.
                    return;
                }
                
                fs.open(f, FileMode.WRITE);
                fs.writeBytes(fzf.content);
                fs.close();
                
            } catch (error:Error) {
                if (failonerror)
                    ant.project.status = false;
            }
        }
        
        private function onUnzipComplete(event:Event):void {
            var fzip:Zip = event.target as Zip;
            fzip.close();
            fzip.removeEventListener(ZipEvent.FILE_LOADED, onFileLoaded);
            fzip.removeEventListener(Event.COMPLETE, onUnzipComplete);            
            fzip.removeEventListener(ErrorEvent.ERROR, onUnzipError);            
        }

        private function onUnzipError(event:Event):void {
            var fzip:Zip = event.target as Zip;
            fzip.close();
            fzip.removeEventListener(ZipEvent.FILE_LOADED, onFileLoaded);
            fzip.removeEventListener(Event.COMPLETE, onUnzipComplete);            
            fzip.removeEventListener(ErrorEvent.ERROR, onUnzipError);
            if (failonerror)
                ant.project.status = false;
        }
    }
}