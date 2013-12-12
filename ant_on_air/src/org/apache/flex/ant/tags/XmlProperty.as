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
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    
    import mx.core.IFlexModuleFactory;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.TaskHandler;
    import org.apache.flex.xml.XMLTagProcessor;
    
    [Mixin]
    public class XmlProperty extends TaskHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["xmlproperty"] = XmlProperty;
        }

        public function XmlProperty()
        {
        }
        
        override public function init(xml:XML, context:Object, xmlProcessor:XMLTagProcessor):void
        {
            super.init(xml, context, xmlProcessor);
        }
        
        override public function execute(callbackMode:Boolean):Boolean
        {
            var f:File = new File(fileName);
            var fs:FileStream = new FileStream();
            fs.open(f, FileMode.READ);
            var data:String = fs.readUTFBytes(fs.bytesAvailable);
            var xml:XML = XML(data);
            createProperties(xml, xml.name());
            fs.close();                
            return true;
        }
        
        private function createProperties(xml:XML, prefix:String):void
        {
            var children:XMLList = xml.*;
            for each (var node:XML in children)
            {
                var val:String;
                var key:String;
                if (node.nodeKind() == "text")
                {
                    key = prefix;
                    val = node.toString();
                    if (!context.hasOwnProperty(key))
                        context[key] = val;                    
                }
                else if (node.nodeKind() == "element")
                {
                    key = prefix + "." + node.name();
                    createProperties(node, key);
                }            
            }
            if (collapse)
            {
                var attrs:XMLList = xml.attributes();
                var n:int = attrs.length();
                for (var i:int = 0; i < n; i++)
                {
                    key = prefix + "." + attrs[i].name();
                    val = xml.attribute(attrs[i].name()).toString();
                    if (!context.hasOwnProperty(key))
                        context[key] = val;                    
                }
            }
        }
        
        private var fileName:String;
        private var collapse:Boolean;
        
        override protected function processAttribute(name:String, value:String):void
        {
            if (name == "file")
            {
                fileName = value;
            }
            else if (name == "collapseAttributes")
            {
                collapse = value == "true";
            }
            else
                super.processAttribute(name, value);
        }
        

    } 
}