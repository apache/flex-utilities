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
    
    [Mixin]
    public class AntCall extends TaskHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["antcall"] = AntCall;
        }
        
        public function AntCall()
        {
            super();
        }
        
        private function get target():String
        {
            return getAttributeValue("@target");
        }
        
        override public function execute(callbackMode:Boolean, context:Object):Boolean
        {
            super.execute(callbackMode, context);
            
            // I think properties set in the sub-script to not affect the main script
            // so clone the properties here
            var subContext:Object = {};
            for (var p:String in context)
                subContext[p] = context[p];
            
            if (numChildren > 0)
            {
                for (var i:int = 0; i < numChildren; i++)
                {
                    var param:Param = getChildAt(i) as Param;
                    param.setContext(context);
                    subContext[param.name] = param.value;
                }
            }
            var t:Target = ant.project.getTarget(target);
            if (!t.execute(callbackMode, subContext))
            {
                t.addEventListener(Event.COMPLETE, completeHandler);
                return false;
            }
            return true;
        }
        
        private function completeHandler(event:Event):void
        {
            event.target.removeEventListener(Event.COMPLETE, completeHandler);
            dispatchEvent(event);
        }
    }
}