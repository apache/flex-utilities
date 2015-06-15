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
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    
    import mx.core.IFlexModuleFactory;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.TaskHandler;
    import org.apache.flex.xml.ITextTagHandler;
    
    [Mixin]
    public class Echo extends TaskHandler implements ITextTagHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["echo"] = Echo;
        }
        
        public function Echo()
        {
            super();
        }
        
        private var _text:String;
        
        private function get text():String
        {
            if (_text != null)
                return _text;
            
            return getAttributeValue("@message");
        }
        private function get fileName():String
        {
            return getNullOrAttributeValue("@file");
        }
        
        public function setText(text:String):void
        {
            _text = text;    
        }
        
        override public function execute(callbackMode:Boolean, context:Object):Boolean
        {
            super.execute(callbackMode, context);
            if (fileName != null)
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
                
                var fs:FileStream = new FileStream();
                fs.open(f, FileMode.WRITE);
                fs.writeUTFBytes(ant.getValue(text, context));
                fs.close();
            }
            else
                ant.output(ant.formatOutput("echo", ant.getValue(text, context)));
            return true;
        }
    }
}