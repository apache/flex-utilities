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
    
    [Mixin]
    public class Replace extends TaskHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["replace"] = Replace;
        }
        
        public function Replace()
        {
            super();
        }
        
        private function get file():String
        {
            return getAttributeValue("@file");
        }
        
        private function get token():String
        {
            return getNullOrAttributeValue("@token");
        }
        
        private function get value():String
        {
            return getAttributeValue("@value");
        }
        
        override public function execute(callbackMode:Boolean, context:Object):Boolean
        {
            super.execute(callbackMode, context);
            
            try {
                var f:File = File.applicationDirectory.resolvePath(file);
            } 
            catch (e:Error)
            {
                ant.output(file);
                ant.output(e.message);
                if (failonerror)
                    ant.project.status = false;
                return true;							
            }
            
            var fs:FileStream = new FileStream();
            fs.open(f, FileMode.READ);
            var s:String = fs.readUTFBytes(fs.bytesAvailable);
            fs.close();
            var tokens:Vector.<RegExp> = new Vector.<RegExp>();
            var reps:Vector.<String> = new Vector.<String>();
            var regex:RegExp;
            if (token != null)
            {
                regex = new RegExp(token, "g");
                tokens.push(regex);
                reps.push(value);
            }
            if (numChildren > 0)
            {
                for (var i:int = 0; i < numChildren; i++)
                {
                    var rf:ReplaceFilter = getChildAt(i) as ReplaceFilter;
                    rf.setContext(context);
                    regex = new RegExp(rf.token, "g");
                    tokens.push(regex);
                    reps.push(rf.value);
                }
            }
            var n:int = tokens.length;
            for (i = 0; i < n; i++)
            {
                s = s.replace(tokens[i], reps[i]);				
            }
            fs.open(f, FileMode.WRITE);
            fs.writeUTFBytes(s);
            fs.close();
            return true;
        }
    }
}