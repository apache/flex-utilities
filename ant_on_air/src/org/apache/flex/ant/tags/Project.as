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
    import mx.utils.StringUtil;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.filesetClasses.Reference;
    import org.apache.flex.ant.tags.supportClasses.TaskHandler;
    import org.apache.flex.xml.ITagHandler;
    import org.apache.flex.xml.XMLTagProcessor;
    
    [Mixin]
    public class Project extends TaskHandler
    {
        /** Message priority of &quot;error&quot;. */
        public static const MSG_ERR:int = 0;
        /** Message priority of &quot;warning&quot;. */
        public static const MSG_WARN:int = 1;
        /** Message priority of &quot;information&quot;. */
        public static const MSG_INFO:int = 2;
        /** Message priority of &quot;verbose&quot;. */
        public static const MSG_VERBOSE:int = 3;
        /** Message priority of &quot;debug&quot;. */
        public static const MSG_DEBUG:int = 4;
        
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["project"] = Project;
        }

        public function Project()
        {
        }
        
        override public function init(xml:XML, context:Object, xmlProcessor:XMLTagProcessor):void
        {
            context.project = this;
            super.init(xml, context, xmlProcessor);
            ant.processChildren(xml, context, this);
        }
        
        private var _basedir:String;
        
        public function get basedir():String
        {
            return _basedir;
        }
        
        private var _defaultTarget:String;
        
        public function get defaultTarget():String
        {
            return _defaultTarget;
        }
        
        private var targets:Array;
        
        override protected function processAttribute(name:String, value:String):void
        {
            if (name == "basedir")
                _basedir = value;
            else if (name == "default")
                _defaultTarget = value;
            else
                super.processAttribute(name, value);
        }

        override public function execute():Boolean
        {
            if (context.targets == null)
                context.targets == _defaultTarget;
            
            targets = context.targets.split(",");
            
            // execute all children in order except for targets
            return executeChildren();
        }
        
        private var current:int = 0;
        
        private function executeChildren():Boolean
        {
            if (current == numChildren)
                return executeTargets();
            
            while (current < numChildren)
            {
                var child:ITagHandler = getChildAt(current++);
                if (child is Target)
                    continue;
                if (child is TaskHandler)
                {
                    var task:TaskHandler = TaskHandler(child);
                    if (!task.execute())
                    {
                        task.addEventListener(Event.COMPLETE, childCompleteHandler);
                        return false;
                    }
                }
            }
            return executeTargets();
        }
        
        private function executeTargets():Boolean
        {
            while (targets.length > 0)
            {
                var targetName:String = targets.shift();
                if (!executeTarget(targetName))
                    return false;                
            }
            if (targets.length == 0)
                dispatchEvent(new Event(Event.COMPLETE));
            
            return true;
        }
        
        public function getTarget(targetName:String):Target
        {
            targetName = StringUtil.trim(targetName);
            var n:int = numChildren;
            for (var i:int = 0; i < n; i++)
            {
                var child:ITagHandler = getChildAt(i);
                if (child is Target)
                {
                    var t:Target = child as Target;
                    if (t.name == targetName)
                    {
                        return t;
                    }
                }
            }
            trace("missing target: ", targetName);
            throw new Error("missing target: " + targetName);
            return null;            
        }
        
        public function executeTarget(targetName:String):Boolean
        {
            var t:Target = getTarget(targetName);
            if (!t.execute())
            {
                t.addEventListener(Event.COMPLETE, completeHandler);
                return false;
            }
            return true;
        }
        
        private function completeHandler(event:Event):void
        {
            executeTargets();
        }
        
        private function childCompleteHandler(event:Event):void
        {
            executeChildren();
        }
        
        private var references:Object = {};
        
        public function addReference(referenceName:String, value:Object):void
        {
            references[referenceName] = value;
        }
        public function getReference(referenceName:String):Reference
        {
            if (references.hasOwnProperty(referenceName))
                return references[referenceName];
            
            return null;
        }
    }
}