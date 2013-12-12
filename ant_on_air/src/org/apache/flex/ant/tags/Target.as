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
    
    import mx.core.IFlexModuleFactory;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.TaskHandler;
    import org.apache.flex.xml.XMLTagProcessor;
    
    [Mixin]
    public class Target extends TaskHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["target"] = Target;
        }
        
        public function Target()
        {
        }
        
        override public function init(xml:XML, context:Object, xmlProcessor:XMLTagProcessor):void
        {
            this.xml = xml;
            project = context.project as Project;
            super.init(xml, context, xmlProcessor);
        }
        
        private var project:Project;
        
        private var _depends:String;
        
        public function get depends():String
        {
            return _depends;
        }
                
        override protected function processAttribute(name:String, value:String):void
        {
            if (name == "depends")
                _depends = value;
            else
                super.processAttribute(name, value);
        }
        
        override protected function processAttributes(xmlList:XMLList, context:Object):void
        {
            super.processAttributes(xmlList, context);
            context.currentTarget = this;
        }
        
        private var dependsList:Array;
        
        private function processDepends():Boolean
        {
            if (dependsList.length == 0)
            {
                continueOnToSteps();
                return true;
            }

            while (dependsList.length > 0)
            {
                var depend:String = dependsList.shift();
                var t:Target = project.getTarget(depend);
                if (!t.execute(callbackMode))
                {
                    t.addEventListener(Event.COMPLETE, dependCompleteHandler);
                    return false;
                }
            }
            
            return continueOnToSteps();
        }
        
        private function dependCompleteHandler(event:Event):void
        {
            processDepends();
        }
        
        private var inExecute:Boolean;
        
        override public function execute(callbackMode:Boolean):Boolean
        {
            inExecute = true;
            this.callbackMode = callbackMode;
            if (_depends)
            {
                dependsList = _depends.split(",");
                if (!processDepends())
                {
                    inExecute = false;
                    return false;
                }
            }
            
            var ok:Boolean = continueOnToSteps();
            inExecute = false;
            return ok;
        }
        
        private function continueOnToSteps():Boolean
        {
            if (!Ant.project.status)
                return true;
            ant.processChildren(xml, context, this);
            return processSteps();
        }
        
        private var current:int = 0;
        
        private function processSteps():Boolean
        {
            if (current == numChildren)
            {
                dispatchEvent(new Event(Event.COMPLETE));
                return true;
            }
            
            while (current < numChildren)
            {
                var step:TaskHandler = getChildAt(current++) as TaskHandler;
                if (step.ifProperty != null)
                    if (!context.hasOwnProperty(step.ifProperty))
                        continue;
                if (step.unlessProperty != null)
                    if (context.hasOwnProperty(step.unlessProperty))
                        continue;
                if (!step.execute(callbackMode))
                {
                    step.addEventListener(Event.COMPLETE, completeHandler);
                    return false;
                }
                if (!Ant.project.status)
                {
                    if (!inExecute)
                        dispatchEvent(new Event(Event.COMPLETE));
                    return true;
                }
                if (callbackMode)
                {
                    ant.functionToCall = processSteps;
                    return false;
                }
            }
            dispatchEvent(new Event(Event.COMPLETE));
            return true;
        }

        private function completeHandler(event:Event):void
        {
            if (!Ant.project.status)
            {
                dispatchEvent(new Event(Event.COMPLETE));
                return;                
            }
            if (callbackMode)
                ant.functionToCall = processSteps;
            else
                processSteps();
        }
    }
}