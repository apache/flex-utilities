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
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.filesystem.File;
    
    import org.apache.flex.ant.tags.FileSet;
    
    /**
     *  The base class for ITagHandlers that do work with filesets
     */
    public class FileSetTaskHandler extends TaskHandler
    {
        public function FileSetTaskHandler()
        {
        }
        
        private var current:int = 0;
        private var currentFile:int;
        private var currentList:Vector.<String>;
        private var currentDir:File;
        private var totalFiles:int;
        private var thisFile:int;
        
        /**
         *  Do the work.
         *  TaskHandlers lazily create their children
         *  and attributes so
         *  super.execute() should be called before
         *  doing any real work. 
         */
        override public function execute(callbackMode:Boolean, context:Object):Boolean
        {
            super.execute(callbackMode, context);
            totalFiles = 0;
            thisFile = 0;
            for (var i:int = 0; i < numChildren; i++)
            {
                var fs:FileSet = getChildAt(i) as FileSet;
                if (fs)
                {
                    try
                    {
                        var list:Vector.<String> = fs.getValue(context) as Vector.<String>;
                        if (list)
                        {
                            totalFiles += list.length;
                        }
                    }
                    catch (e:Error)
                    {
                        if (failonerror)
                        {
							ant.project.failureMessage = e.message;
                            ant.project.status = false;
                            return true;
                        }
                    }
                }
            }
            if (numChildren)
                outputTotal(totalFiles);
            actOnFileSets();
            return !callbackMode;
        }
        
        protected function outputTotal(total:int):void
        {
            
        }
        
        private function actOnFileSets():void
        {
            if (current == numChildren)
            {
                dispatchEvent(new Event(Event.COMPLETE));
                return;
            }
            
            while (current < numChildren)
            {
                var fs:FileSet = getChildAt(current++) as FileSet;
                if (fs)
                {
                    var list:Vector.<String> = fs.getValue(context) as Vector.<String>;
                    if (list)
                    {
                        try {
                            currentDir = new File(fs.dir);
                        } 
                        catch (e:Error)
                        {
                            ant.output(fs.dir);
                            ant.output(e.message);
							if (failonerror)
							{
								ant.project.failureMessage = e.message;
								ant.project.status = false;
							}
                            dispatchEvent(new Event(Event.COMPLETE));
                            return;							
                        }
                        currentFile = 0;
                        currentList = list;
                        actOnList();
                        if (callbackMode)
                            return;
                    }
                }
            }
            
            if (current == numChildren)
            {
                dispatchEvent(new Event(Event.COMPLETE));
                return;
            }
        }
        
        private function actOnList():void
        {
            if (currentFile == currentList.length)
            {
                ant.functionToCall = actOnFileSets;
                ant.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, thisFile, totalFiles));
                return;
            }
            
            while (currentFile < currentList.length)
            {
                ant.progressClass = this;
                var fileName:String = currentList[currentFile++];
                ant.dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, false, false, thisFile, totalFiles));
                actOnFile(currentDir.nativePath, fileName);
                thisFile++;
                if (callbackMode)
                {
                    ant.functionToCall = actOnList;
                    return;
                }
            }
        }
        
        protected function actOnFile(dir:String, fileName:String):void
        {
            
        }
    }
}