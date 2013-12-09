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
package org.apache.flex.ant.tags.supportClasses
{
    import flash.filesystem.File;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.FileSet;
    
    /**
     *  The base class for ITagHandlers that do work with filesets
     */
    public class FileSetTaskHandler extends TaskHandler
    {
        public function FileSetTaskHandler()
        {
        }
        
        /**
         *  Do the work.
         *  TaskHandlers lazily create their children so
         *  super.execute() should be called before
         *  doing any real work. 
         */
        override public function execute():Boolean
        {
            ant.processChildren(this.xml, context, this);
            var n:int = numChildren;
            for (var i:int = 0; i < n; i++)
            {
                var fs:FileSet = getChildAt(i) as FileSet;
                if (fs)
                {
                    try
                    {
                        var list:Vector.<String> = fs.value as Vector.<String>;
                        if (list)
                        {
                            var dir:File = new File(fs.dir);
                            for each (var fileName:String in list)
                            {
                                actOnFile(dir.nativePath, fileName);
                            }
                        }
                    }
                    catch (e:Error)
                    {
                        if (failonerror)
                        {
                            Ant.project.status = false;
                            return true;
                        }
                    }
                }
            }
            return true;
        }
        
        protected function actOnFile(dir:String, fileName:String):void
        {
            
        }
    }
}