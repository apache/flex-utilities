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
package org.apache.flex.ant.tags.filesetClasses
{
    public class CollectionUtils
    {
        public function CollectionUtils()
        {
            super();
        }
        
        private static var target:String;
        
        private static function callback(item:String, index:int, list:Vector.<String>):Boolean
        {
            return CollectionUtils.target == item;
        }
        
        public static function frequency(list:Vector.<String>, c:String):int
        {
            target = c;
            return list.filter(callback).length;
        }        
   }
}