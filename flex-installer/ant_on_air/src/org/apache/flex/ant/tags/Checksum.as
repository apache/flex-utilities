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
    import org.apache.flex.crypto.MD5Stream;
    
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.ByteArray;
    
    import mx.core.IFlexModuleFactory;
    import mx.utils.StringUtil;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.TaskHandler;
    
    [Mixin]
    public class Checksum extends TaskHandler
    {
		private static var DEFAULT_READBUFFER_SIZE:int = 2 * 1024 * 1024;
		
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["checksum"] = Checksum;
        }
        
        public function Checksum()
        {
            super();
        }
        
        private function get file():String
        {
            return getAttributeValue("@file");
        }
        
        private function get toDir():String
        {
            return getNullOrAttributeValue("@todir");
        }
        
        private function get fileExt():String
        {
            var val:String = getNullOrAttributeValue("@fileext");
            return val == null ? ".md5" : val;
        }
        
        private function get property():String
        {
            return getNullOrAttributeValue("@property");
        }
        
        private function get verifyproperty():String
        {
            return getNullOrAttributeValue("@verifyproperty");
        }
        
        private function get readbuffersize():int
        {
            var val:String = getNullOrAttributeValue("@readbuffersize");
            return val == null ? DEFAULT_READBUFFER_SIZE : int(val);
        }
        
        private var md5:MD5Stream;
        private var fs:FileStream;
        private var totalLength:int;
        
        override public function execute(callbackMode:Boolean, context:Object):Boolean
        {
            super.execute(callbackMode, context);
            
            try {
                var f:File = File.applicationDirectory.resolvePath(this.file);
            } 
            catch (e:Error)
            {
                ant.output(this.file);
                ant.output(e.message);
                if (failonerror)
				{
					ant.project.failureMessage = e.message;
                    ant.project.status = false;
				}
                dispatchEvent(new Event(Event.COMPLETE));
                return true;							
            }
            
            if (!f.exists)
                return true;
            
            fs = new FileStream();
            fs.open(f, FileMode.READ);
            totalLength = fs.bytesAvailable;
            md5 = new MD5Stream();
            md5.resetFields();
            return getSum();
        }
        
        private function getSum():Boolean
        {
            if (fs.bytesAvailable < DEFAULT_READBUFFER_SIZE)
            {
                sumComplete();
                return true;
            }
            md5.update(fs, DEFAULT_READBUFFER_SIZE);
            ant.functionToCall = getSum;
            ant.progressClass = this;
            ant.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, 
                fs.position, fs.position + fs.bytesAvailable));
            return false;
        }
        
        private var sum:String;
        
        private function sumComplete():void
        {
            sum = md5.complete(fs, totalLength);
            fs.close();
            if (verifyproperty && property)
            {
                if (sum == property)
                    context[verifyproperty] = "true";
                else
                    context[verifyproperty] = "false";
            }
            else if (!toDir && property)
            {
                context[property] = sum;				
            }
            else
            {
                var sumFile:File = getSumFile();
                if (sumFile)
                {
                    var fs:FileStream = new FileStream();
                    if (verifyproperty)
                    {
                        fs.open(sumFile, FileMode.READ);
                        var expected:String = fs.readUTFBytes(fs.bytesAvailable);
                        expected = StringUtil.trim(expected);
                        fs.close();                
                        if (sum != expected)
                            context[verifyproperty != null ? verifyproperty : property] = "false";
                        else
                            context[verifyproperty != null ? verifyproperty : property] = "true";
                    }
                    else
                    {
                        fs.open(sumFile, FileMode.WRITE);
                        fs.writeUTFBytes(sum);
                        fs.close();                
                    }
                }            
            }
            ant.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, 
                totalLength, totalLength));
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        private function getSumFile():File
        {
            try {
                var sumFile:File;
				if (toDir)
					sumFile = File.applicationDirectory.resolvePath(toDir);
				else
				{
					var f:File = File.applicationDirectory.resolvePath(this.file);
					sumFile = f.parent;
				}
            } 
            catch (e:Error)
            {
                ant.output(toDir);
                ant.output(e.message);
                if (failonerror)
				{					
					ant.project.failureMessage = e.message;
                    ant.project.status = false;
				}				
                return null;							
            }
            
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