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
    public class PropertyFile extends TaskHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["propertyfile"] = PropertyFile;
        }

        public function PropertyFile()
        {
        }
        
        override public function execute(callbackMode:Boolean, context:Object):Boolean
        {
            super.execute(callbackMode, context);
			
            var f:File = new File(fileName);
            var fs:FileStream = new FileStream();
            fs.open(f, FileMode.WRITE);
            var n:int = numChildren;
            for (var i:int = 0; i < n; i++)
            {
                var entry:Entry = getChildAt(i) as Entry;
                if (entry)
                {
                    var s:String = entry.key + "=" + entry.value + "\n";
                    fs.writeUTFBytes(s);
                }
            }
            fs.close();
            return true;
        }
        
        private var fileName:String;
        
        override protected function processAttribute(name:String, value:String):void
        {
            if (name == "file")
            {
                fileName = value;
            }
            else
                super.processAttribute(name, value);
        }
        

    } 
}