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
    import mx.core.IFlexModuleFactory;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.IValueTagHandler;
    import org.apache.flex.ant.tags.supportClasses.TaskHandler;
    
    [Mixin]

    public class Condition extends TaskHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["condition"] = Condition;
        }

        public function Condition()
        {
            super();
        }
        
        override public function execute(callbackMode:Boolean, context:Object):Boolean
        {
            super.execute(callbackMode, context);
            
            // if the property is not already set
            if (property && !context.hasOwnProperty(property))
            {
                var val:Object = computedValue;
                if (val == "true" || val == true)
                {
                    // set it if we should
                    if (value != null)
                        val = value;
                    context[property] = val;
                }            
            }
            return true;
        }

        public function get computedValue():Object
        {
            // get the value from the children
            var val:Object = IValueTagHandler(getChildAt(0)).getValue(context);
            return val;
        }
        
        private function get property():String
		{
			return getNullOrAttributeValue("@property");
		}
		
        private function get value():Object
		{
			return getNullOrAttributeValue("@value");
		}
                
    }
}