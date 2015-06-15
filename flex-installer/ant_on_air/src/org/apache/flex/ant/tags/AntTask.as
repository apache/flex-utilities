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
    import flash.events.KeyboardEvent;
    import flash.events.ProgressEvent;
    import flash.filesystem.File;
    
    import mx.core.IFlexModuleFactory;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.TaskHandler;
    
    [Mixin]
    public class AntTask extends TaskHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["ant"] = AntTask;
        }
        
        public function AntTask()
        {
            super();
        }
        
        private function get file():String
        {
            return getAttributeValue("@antfile");
        }
        
        private function get dir():String
        {
            return getAttributeValue("@dir");
        }
        
        private function get target():String
        {
            return getAttributeValue("@target");
        }
        
        private var subant:Ant;
        
        override public function execute(callbackMode:Boolean, context:Object):Boolean
        {
            super.execute(callbackMode, context);
            
            // I think properties set in the sub-script to not affect the main script
            // so clone the properties here
            var subContext:Object = {};
            for (var p:String in context)
                subContext[p] = context[p];
            if (subContext.hasOwnProperty("targets"))
                delete subContext["targets"];
            if (target)
                subContext["targets"] = target;
            
            subant = new Ant();
            subant.parentAnt = ant;
            subant.output = ant.output;
            var file:File = File.applicationDirectory;
            try {
                file = file.resolvePath(dir + File.separator + this.file);
            } 
            catch (e:Error)
            {
                ant.output(dir + File.separator + this.file);
                ant.output(e.message);
                if (failonerror)
				{
					ant.project.failureMessage = e.message;
                    ant.project.status = false;
				}
                return true;							
            }
            
            if (!subant.processXMLFile(file, subContext, true))
            {
                subant.addEventListener("statusChanged", statusHandler);
                subant.addEventListener(Event.COMPLETE, completeHandler);
                subant.addEventListener(ProgressEvent.PROGRESS, progressEventHandler);
                // redispatch keyboard events off of ant so input task can see them
                ant.addEventListener(KeyboardEvent.KEY_DOWN, ant_keyDownHandler);
                return false;
            }
            else
                completeHandler(null);
            return true;
        }
        
        private function completeHandler(event:Event):void
        {
            event.target.removeEventListener("statusChanged", statusHandler);
            event.target.removeEventListener(Event.COMPLETE, completeHandler);
            event.target.removeEventListener(ProgressEvent.PROGRESS, progressEventHandler);
            ant.removeEventListener(KeyboardEvent.KEY_DOWN, ant_keyDownHandler);
            
            dispatchEvent(event);
        }
        
        private function statusHandler(event:Event):void
        {
            event.target.removeEventListener("statusChanged", statusHandler);
            event.target.removeEventListener(Event.COMPLETE, completeHandler);
            event.target.removeEventListener(ProgressEvent.PROGRESS, progressEventHandler);
            ant.removeEventListener(KeyboardEvent.KEY_DOWN, ant_keyDownHandler);
            ant.project.status = subant.project.status;
            ant.project.failureMessage = subant.project.failureMessage;
            dispatchEvent(new Event(Event.COMPLETE));
        }
        
        private function progressEventHandler(event:ProgressEvent):void
        {
            ant.dispatchEvent(event);
        }
        
        private function ant_keyDownHandler(event:KeyboardEvent):void
        {
            subant.dispatchEvent(event);
        }
        
    }
}