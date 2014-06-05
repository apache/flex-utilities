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
package org.apache.flex.xml
{
    import flash.events.EventDispatcher;

    /**
     *  Base class for processing XML Tags 
     */
    public class XMLTagProcessor extends EventDispatcher
    {
        /**
         *  Constructor
         */
        public function XMLTagProcessor()
        {
        }
        
        /**
         *  Find the associated class for the XML tag and generate
         *  and instance of it.
         * 
         *  @param xml XML The XML node.
         *  @param context Object An object containing useful information.
         *  @return ITagHandler An instance representing this XML node
         */
        public function processXMLTag(xml:XML):ITagHandler
        {
            var tag:String = xml.name().toString();
            var c:Class = tagMap[tag];
            if (!c)
            {
                trace("no processor for ", tag);
                throw new Error("no processor for " + tag);
            }
            var o:ITagHandler = new c() as ITagHandler;
            o.init(xml, this);
            return o;
        }
        
        /**
         *  Loop through the children of a node and process them
         *  
         *  @param xml XML The XML node.
         *  @param context Object An object containing useful information.
         *  @param parentTag IParentTagHandler The parent for the instances that are created.
         */
        public function processChildren(xml:XML, parentTag:IParentTagHandler):void
        {
            parentTag.removeChildren();
            
            var xmlList:XMLList = xml.children();
            var n:int = xmlList.length();
            for (var i:int = 0; i < n; i++)
            {
                var kind:String = xmlList[i].nodeKind();
                if (kind == "text")
                    ITextTagHandler(parentTag).setText(xmlList[i].toString());
                else
                {
                    var tagHandler:ITagHandler = processXMLTag(xmlList[i]);
                    parentTag.addChild(tagHandler);
                }
            }
        }
        
        public var tagMap:Object = {};
        
    }
}