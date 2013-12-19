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
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    
    import mx.core.IFlexModuleFactory;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.TaskHandler;
    import org.apache.flex.xml.ITagHandler;
    
    [Mixin]
    public class Get extends TaskHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["get"] = Get;
        }

        public function Get()
        {
            super();
        }
        
        private var src:String;
        private var dest:String;
        private var skipexisting:Boolean;
        
        override protected function processAttribute(name:String, value:String):void
        {
            if (name == "src")
                src = value;
            else if (name == "dest")
                dest = value;
            else if (name == "skipexisting")
                skipexisting = value == "true";
            else
                super.processAttribute(name, value);
        }
        
        private var urlLoader:URLLoader;
        
        override public function execute(callbackMode:Boolean, context:Object):Boolean
        {
            super.execute(callbackMode, context);
         
            if (skipexisting)
            {
                var destFile:File = getDestFile();
                if (destFile.exists)
                    return true;
            }
            
            urlLoader = new URLLoader();
            urlLoader.load(new URLRequest(src));
            urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
            urlLoader.addEventListener(Event.COMPLETE, completeHandler);
            urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler);
            urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            return false;
        }
        
        private function ioErrorEventHandler(event:IOErrorEvent):void
        {
            ant.project.status = false;
            dispatchEvent(new Event(Event.COMPLETE));
            event.preventDefault();
        }
            
        private function securityErrorHandler(event:SecurityErrorEvent):void
        {
            ant.project.status = false;
            dispatchEvent(new Event(Event.COMPLETE));
            event.preventDefault();
        }
        
        private function progressHandler(event:ProgressEvent):void
        {
            ant.progressClass = this;
            ant.dispatchEvent(event);
        }
        
        private function completeHandler(event:Event):void
        {
            var destFile:File = getDestFile();
            var fs:FileStream = new FileStream();
            fs.open(destFile, FileMode.WRITE);
            fs.writeBytes(urlLoader.data as ByteArray);
            fs.close();
            
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        private function getDestFile():File
        {
            var destFile:File = File.applicationDirectory.resolvePath(dest);
            if (destFile.isDirectory)
            {
                var fileName:String = src;
                var c:int = fileName.indexOf("?");
                if (c != -1)
                    fileName = fileName.substring(0, c);
                c = fileName.lastIndexOf("/");
                if (c != -1)
                    fileName = fileName.substr(c + 1);
                destFile = destFile.resolvePath(fileName);
            }
            return destFile;
       }
    }
}