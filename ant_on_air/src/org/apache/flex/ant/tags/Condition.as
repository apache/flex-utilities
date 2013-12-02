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
    import org.apache.flex.ant.tags.supportClasses.ParentTagHandler;
    import org.apache.flex.xml.XMLTagProcessor;
    
    [Mixin]

    public class Condition extends ParentTagHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["condition"] = Condition;
        }

        public function Condition()
        {
            super();
        }
        
        override public function init(xml:XML, context:Object, xmlProcessor:XMLTagProcessor):void
        {
            // process attributes
            super.init(xml, context, xmlProcessor);
            // create child nodes
            ant.processChildren(xml, context, this);
            // if the property is not already set
            if (_property && _value != null && !context.hasOwnProperty(_property))
            {
                // get the value from the children
                var val:Object = IValueTagHandler(getChildAt(0)).value;
                if (val == "true" || val == true)
                {
                    // set it if we should
                    if (_value != null)
                        val = _value;
                    context[_property] = val;
                }
            }
        }

        private var _property:String;
        private var _value:Object;
        
        override protected function processAttribute(name:String, value:String):void
        {
            if (name == "property")
                _property = value;
            else if (name == "value")
                _value = value;
        }
        
    }
}