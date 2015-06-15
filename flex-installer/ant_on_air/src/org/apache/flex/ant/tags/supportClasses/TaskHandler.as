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
    
    /**
     *  The base class for ITagHandlers that do work
     */
    public class TaskHandler extends NamedTagHandler
    {
        public function TaskHandler()
        {
        }
        
        public function get failonerror():Boolean
		{
			var val:String = getNullOrAttributeValue("@failonerror");
			return val == null ? true : val == "true";
		}
        
        protected var callbackMode:Boolean;
        
        protected var processedChildren:Boolean;
        
        /**
         *  Do the work.
         *  TaskHandlers lazily create their children so
         *  super.execute() should be called before
         *  doing any real work. 
         */
        public function execute(callbackMode:Boolean, context:Object):Boolean
        {
            this.callbackMode = callbackMode;
			this.context = context;
            if (!processedChildren)
            {
                ant.processChildren(xml, this);
                processedChildren = true;
            }
            return true;
        }
        
    }
}