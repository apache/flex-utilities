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
    import flash.events.EventDispatcher;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.xml.ITagHandler;
    import org.apache.flex.xml.XMLTagProcessor;
    
    /**
     *   The lowest-level base class for ITagHandlers for Ant.
     */
    public class TagHandler extends EventDispatcher implements ITagHandler
    {
        /**
         *  Constructor
         */
        public function TagHandler()
        {
        }
        
        /**
         *  The Ant instance.  Often used for getValue() and output() methods. 
         */
        protected var ant:Ant;
        
        /**
         *  The context object.  Contains a project property referencing the project.
         */
        protected var context:Object;
        
        /**
         *  The xml node for this tag
         */
        protected var xml:XML;
        
        /**
         *  @see org.apache.flex.xml.ITagHandler 
         */
        public function init(xml:XML, context:Object, xmlProcessor:XMLTagProcessor):void
        {
            ant = xmlProcessor as Ant;
            this.context = context;
            this.xml = xml;
            processAttributes(xml.attributes(), context);
        }
        
        /**
         *  Loop through and process attributes.
         *  @param xmlList XMLList The list of attributes.
         *  @param context Object An object containing useful information.
         */
        protected function processAttributes(xmlList:XMLList, context:Object):void
        {
            var n:int = xmlList.length();
            for (var i:int = 0; i < n; i++)
                processAttribute(xmlList[i].name().toString(), ant.getValue(xmlList[i].toString(), context));
        }
        
        /**
         *  Process an attribute on the tag.
         *  @param name String The attribute name.
         *  @param value String The attribute value.
         */
        protected function processAttribute(name:String, value:String):void
        {     
        }
    }
}