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
        
        public var failonerror:Boolean = true;
        
        protected var callbackMode:Boolean;
        
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
			processAttributes(xml.attributes(), context);
            ant.processChildren(xml, this);
            return true;
        }
        
        override protected function processAttribute(name:String, value:String):void
        {
            if (name == "failonerror")
                failonerror = value == "true";
            else
                super.processAttribute(name, value);
        }
    }
}