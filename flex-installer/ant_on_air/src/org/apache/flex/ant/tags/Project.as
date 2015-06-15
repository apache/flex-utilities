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
        
        private var _status:Boolean;
        /**
         *  true if tasks completed successfully.
         *  Do not monitor this property to determine if the project is done executing.
         *  This property is set to true and a failing task sets it to false.
         */
        public function get status():Boolean
        {
            return _status;
        }
        
        public function set status(value:Boolean):void
        {
            if (_status != value)
            {
                _status = value;
                ant.dispatchEvent(new Event("statusChanged"));
            }
        }
        
		private var _failureMessage:String;
		/**
		 *  null if tasks completed successfully.
		 *  if status == false, then this will be
		 *  set if a <fail> message set status to false
		 *  or some other condition set status to false.
		 *  
		 */
		public function get failureMessage():String
		{
			return _failureMessage;
		}
		
		public function set failureMessage(value:String):void
		{
			if (_failureMessage != value)
			{
				_failureMessage = value;
				ant.dispatchEvent(new Event("failureMessageChanged"));
			}
		}
		
        public function get basedir():String
        {
            return getAttributeValue("@basedir");
        }
        
        public function get defaultTarget():String
        {
            return getAttributeValue("@default");
        }
        
        public var refids:Object = {};
        
        private var targets:Array;
        
        override public function execute(callbackMode:Boolean, context:Object):Boolean
        {
            super.execute(callbackMode, context);
            
            this.callbackMode = callbackMode;
            
            status = true;
            
            if (context.targets == null)
                context.targets = defaultTarget;
            
            targets = context.targets.split(",");
            
            // execute all children in order except for targets
            return executeChildren();
        }
        
        private var current:int = 0;
        
        private function executeChildren():Boolean
        {
            if (!status)
            {
                dispatchEvent(new Event(Event.COMPLETE));
                return true;                
            }
            
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
                    if (!task.execute(callbackMode, context))
                    {
                        task.addEventListener(Event.COMPLETE, childCompleteHandler);
                        return false;
                    }
                    if (!status)
                    {
                        dispatchEvent(new Event(Event.COMPLETE));
                        return true;                                        
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
                if (!status)
                {
                    dispatchEvent(new Event(Event.COMPLETE));
                    return true;
                }
                
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
            if (!t.execute(callbackMode, context))
            {
                t.addEventListener(Event.COMPLETE, completeHandler);
                return false;
            }
            return true;
        }
        
        private function completeHandler(event:Event):void
        {
            event.target.removeEventListener(Event.COMPLETE, completeHandler);
            executeTargets();
        }
        
        private function childCompleteHandler(event:Event):void
        {
            event.target.removeEventListener(Event.COMPLETE, childCompleteHandler);
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