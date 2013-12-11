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
    import org.apache.flex.xml.XMLTagProcessor;
    
    [Mixin]
    public class LoadProperties extends TaskHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["loadproperties"] = LoadProperties;
        }

        public function LoadProperties()
        {
        }
        
        override public function init(xml:XML, context:Object, xmlProcessor:XMLTagProcessor):void
        {
            super.init(xml, context, xmlProcessor);
        }
        
        override public function execute(callbackMode:Boolean):Boolean
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
            return true;
        }
        
        private var fileName:String;
        
        override protected function processAttribute(name:String, value:String):void
        {
            if (name == "srcFile")
            {
                fileName = value;
            }
            else
                super.processAttribute(name, value);
        }
        

    } 
}