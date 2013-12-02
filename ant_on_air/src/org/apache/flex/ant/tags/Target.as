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
        
        private function processDepends():void
        {
            if (!_depends)
                return;
            
            var dependsList:Array = _depends.split(",");
            for each (var d:String in dependsList)
                project.executeTarget(d);
        }
        
        override public function execute():void
        {
            processDepends();
            ant.processChildren(xml, context, this);
            processSteps();
        }
        
        private function processSteps():void
        {
            var n:int = numChildren;
            for (var i:int = 0; i < n; i++)
            {
                var step:TaskHandler = getChildAt(i) as TaskHandler;
                step.execute();
            }
        }

    }
}