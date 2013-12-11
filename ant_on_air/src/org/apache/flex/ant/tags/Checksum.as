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
    import com.adobe.crypto.MD5Stream;
    
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.ByteArray;
    
    import mx.core.IFlexModuleFactory;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.TaskHandler;

    [Mixin]
    public class Checksum extends TaskHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["checksum"] = Checksum;
        }

        public function Checksum()
        {
            super();
        }
        
        private var file:String;
        private var toDir:String;
        private var fileExt:String = ".md5";
        private var verifyproperty:String;
        private var readbuffersize:int = 8192;
        
        override protected function processAttribute(name:String, value:String):void
        {
            if (name == "file")
                file = value;
            else if (name == "todir")
                toDir = value;
            else if (name == "fileext")
                fileExt = value;
            else if (name == "verifyproperty")
                verifyproperty = value;
            else if (name == "readbuffersize")
                verifyproperty = value;
            else
                super.processAttribute(name, value);
        }
        
        private var md5:MD5Stream;
        private var fs:FileStream;
        
        override public function execute(callbackMode:Boolean):Boolean
        {
            super.execute(callbackMode);
         
            var f:File = File.applicationDirectory.resolvePath(file);
            fs = new FileStream();
            fs.open(f, FileMode.READ);
            md5 = new MD5Stream();
            md5.resetFields();
            getSum();
            return false;
        }
        
        private function getSum():void
        {
            if (fs.bytesAvailable == 0)
            {
                sumComplete();
                return;
            }
            var ba:ByteArray = new ByteArray();
            fs.readBytes(ba, 0, Math.max(readbuffersize, fs.bytesAvailable));
            md5.update(ba);
            ant.functionToCall = getSum;
            ant.progressClass = this;
            ant.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, 
                fs.position, fs.position + fs.bytesAvailable));
        }
        
        private var sum:String;
        
        private function sumComplete():void
        {
            sum = md5.complete();
            var sumFile:File = getSumFile();
            var fs:FileStream = new FileStream();
            if (verifyproperty)
            {
                fs.open(sumFile, FileMode.READ);
                var expected:String = fs.readUTFBytes(fs.bytesAvailable);
                fs.close();                
                if (sum != expected)
                    context[verifyproperty] = "false";
                else
                    context[verifyproperty] = "true";
            }
            else
            {
                fs.open(sumFile, FileMode.WRITE);
                fs.writeUTFBytes(sum);
                fs.close();                
            }
            
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        private function getSumFile():File
        {
            var sumFile:File = File.applicationDirectory.resolvePath(toDir);
            if (sumFile.isDirectory)
            {
                var fileName:String = file + fileExt;
                var c:int = fileName.indexOf("?");
                if (c != -1)
                    fileName = fileName.substring(0, c);
                c = fileName.lastIndexOf("/");
                if (c != -1)
                    fileName = fileName.substr(c + 1);
                sumFile = sumFile.resolvePath(fileName);
            }
            return sumFile;
       }
    }
}