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
    import mx.utils.StringUtil;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.TaskHandler;
    import org.apache.flex.xml.ITagHandler;
    import org.apache.flex.xml.XMLTagProcessor;
    
    [Mixin]
    public class Project extends TaskHandler
    {
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
        
        override protected function processAttribute(name:String, value:String):void
        {
            if (name == "basedir")
                _basedir = value;
            else if (name == "default")
                _defaultTarget = value;
            else
                super.processAttribute(name, value);
        }

        override public function execute():void
        {
            if (context.target == null)
                context.target == _defaultTarget;
            
            var targets:Array;
            var targetList:String = context.targets;
            if (targetList.indexOf(',') != -1)
                targets = targetList.split(",");
            else
                targets = [ targetList ];
            
            for each (var target:String in targets)
                executeTarget(target);
        }
        
        public function executeTarget(targetName:String):void
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
                        t.execute();
                        return;
                    }
                }
            }
            
            trace("missing target: ", targetName);
            throw new Error("missing target: " + targetName);
            
        }
    }
}