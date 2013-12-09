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
    import org.apache.flex.xml.ITextTagHandler;
    
    [Mixin]
    public class Fail extends TaskHandler implements ITextTagHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["fail"] = Fail;
        }

        public function Fail()
        {
            super();
        }
        
        private var text:String;
        
        public function setText(text:String):void
        {
            this.text = text;    
        }
        
        override protected function processAttribute(name:String, value:String):void
        {
            if (name == "message")
                text = value;
            else
                super.processAttribute(name, value);
        }

        override public function execute():Boolean
        {
            super.execute();
            if (numChildren == 1)
            {
                var child:Condition = getChildAt(0) as Condition;
                if (child)
                {
                    child.execute();
                    var val:Object = child.computedValue;
                    if (!(val == "true" || val == true))
                    {
                        return true;
                    }
                }
            }
            if (text)
                ant.output(ant.getValue(text, context));
            Ant.project.status = false;
            return true;
        }
    }
}