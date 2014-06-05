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
    import org.apache.flex.xml.IParentTagHandler;
    import org.apache.flex.xml.ITagHandler;

    /**
     *  The base class for ITagHandlers that have children 
     */
    public class ParentTagHandler extends TagHandler implements IParentTagHandler
    {
        private var children:Array;
        
        public function addChild(child:ITagHandler):ITagHandler
        {
            if (children == null)
                children = [ child ];
            else
                children.push(child);
            return child;
        }
        
        public function getChildAt(index:int):ITagHandler
        {
            return children[index];
        }
        
        public function removeChildren():void
        {
            children = null;
        }
        
        public function get numChildren():int
        {
            if (!children) return 0;
            
            return children.length;
        }
    }
}