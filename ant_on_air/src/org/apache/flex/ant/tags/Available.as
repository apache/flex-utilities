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
    import flash.filesystem.File;
    
    import mx.core.IFlexModuleFactory;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.IValueTagHandler;
    import org.apache.flex.ant.tags.supportClasses.TaskHandler;
    
    [Mixin]
    public class Available extends TaskHandler implements IValueTagHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["available"] = Available;
        }

        public function Available()
        {
            super();
        }
        
        private var _file:String;
        private var _type:String;
        private var _property:String;
        private var _value:String;
        
        public function getValue(context:Object):Object
        {
			processAttributes(xml.attributes(), context);

            if (_file == null) return false;
            
            var file:File = new File(_file);
            if (!file.exists)
                return false;
            
            if (_type == "dir" && !file.isDirectory)
                return false;
            
            return true;
        }

        override public function execute(callbackMode:Boolean, context:Object):Boolean
        {
            super.execute(callbackMode, context);
            var value:Object = getValue(context);
                if (!context.hasOwnProperty(_property))
                    context[_property] = _value != null ? _value : true;
            return true;
        }
        
        override protected function processAttribute(name:String, value:String):void
        {
            if (name == "file")
                _file = value;
            else if (name == "type")
                _type = value;
            if (name == "property")
                _property = value;
            if (name == "value")
                _value = value;
        }
        
    }
}