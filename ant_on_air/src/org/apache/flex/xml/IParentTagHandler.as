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
    /**
     *  The interface for ITagHandlers that can have children 
     */
    public interface IParentTagHandler extends ITagHandler
    {
        /**
         *  Add a child ITagHandler
         *  @param child ITagHandler The child.
         *  @return ITagHandler The child. 
         */
        function addChild(child:ITagHandler):ITagHandler;

        /**
         *  Get a child ITagHandler
         *  @param index int The index of the child.
         *  @return ITagHandler The child. 
         */
        function getChildAt(index:int):ITagHandler;
        
        /**
         *  Remove all children
         */        
        function removeChildren():void;
        
        /**
         *  The number of children.
         *  @return int The number of children. 
         */
        function get numChildren():int;
    }
}