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
    import flash.errors.IOError;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    
    import mx.core.IFlexModuleFactory;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.TaskHandler;
    import org.apache.flex.xml.ITagHandler;
    
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
                if(!f.exists)
                {
                    throw new IOError("File not found: " + f.nativePath);
                }
            } 
            catch (e:Error)
            {
                ant.output(file);
                ant.output(e.message);
                if (failonerror)
				{
					ant.project.failureMessage = e.message;
                    ant.project.status = false;
				}
                return true;							
            }
            
            var fs:FileStream = new FileStream();
            fs.open(f, FileMode.READ);
            var s:String = fs.readUTFBytes(fs.bytesAvailable);
            fs.close();
            var tokens:Vector.<String> = new Vector.<String>();
            var reps:Vector.<String> = new Vector.<String>();
            if (token != null)
            {
                tokens.push(token);
                reps.push(value);
            }
            if (numChildren > 0)
            {
                for (var i:int = 0; i < numChildren; i++)
                {
                    var child:ITagHandler = getChildAt(i);
                    if(child is ReplaceFilter)
                    {
                        var rf:ReplaceFilter = child as ReplaceFilter;
                        rf.setContext(context);
                        tokens.push(rf.token);
                        reps.push(rf.value);
                    }
                    else if(child is ReplaceToken)
                    {
                        var rt:ReplaceToken = child as ReplaceToken;
                        rt.setContext(context);
                        tokens.push(rt.text);
                    }
                    else if(child is ReplaceValue)
                    {
                        var rv:ReplaceValue = child as ReplaceValue;
                        rv.setContext(context);
                        reps.push(rv.text);
                    }
                }
            }
            var n:int = tokens.length;
            var c:int = 0;
            for (i = 0; i < n; i++)
            {
                var cur:int = 0;
                // only look at the portion we haven't looked at yet.
                // otherwise certain kinds of replacements can
                // cause infinite looping, like replacing
                // 'foo' with 'food'
                do
                {
                    c = s.indexOf(tokens[i], cur) 
                    if (c != -1)
                    {
                        var firstHalf:String = s.substr(0, c);
                        var secondHalf:String = s.substr(c);
                        s = firstHalf + secondHalf.replace(tokens[i], reps[i]);
                        cur = c + reps[i].length;
                    }
                } while (c != -1)
            }
            fs.open(f, FileMode.WRITE);
            fs.writeUTFBytes(s);
            fs.close();
            return true;
        }
    }
}