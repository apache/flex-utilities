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
        
        override public function execute(callbackMode:Boolean, context:Object):Boolean
        {
            super.execute(callbackMode, context);
            
            try {
                var f:File = new File(fileName);
            } 
            catch (e:Error)
            {
                ant.output(fileName);
                ant.output(e.message);
				if (failonerror)
				{
					ant.project.failureMessage = e.message;
					ant.project.status = false;
				}
                return true;							
            }
            
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
                    var id:String = node.@id.toString();
                    if (id)
                        ant.project.refids[id] = key;
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
        
        private function get fileName():String
        {
            return getAttributeValue("@file");
        }
        
        private function get collapse():Boolean
        {
            return getAttributeValue("@collapseAttributes") == "true";
        }
        
    } 
}