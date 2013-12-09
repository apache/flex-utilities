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
    // an approximation of the Java StringTokenizer
    public class StringTokenizer
    {
        public function StringTokenizer(s:String, delims:String = "\t\r\n\f", returnDelims:Boolean = false)
        {
            tokens = new Vector.<String>();
            var c1:int = 0;
            var c2:int = 0;
            var n:int = s.length;
            while (c2 < n)
            {
                var c:String = s.charAt(c2);
                if (delims.indexOf(c) != -1)
                {
                    tokens.push(s.substring(c1, c2));
                    c1 = c2;
                    while (c2 < n)
                    {
                        c = s.charAt(c2);
                        if (delims.indexOf(c) == -1)
                        {
                            if (returnDelims)
                                tokens.push(s.substring(c1, c2))
                            c1 = c2;
                            break;
                        }
                        c2++;
                    }
                    if (returnDelims && c1 < c2)
                    {
                        tokens.push(s.substring(c1, c2));
                        c1 = c2;
                    }
                }
                c2++;
            }
            if (c1 < n)
                tokens.push(s.substring(c1))
        }
        
        private var tokens:Vector.<String>;
        private var index:int = 0;
        
        public function hasMoreTokens():Boolean
        {
            return index < tokens.length;    
        }
        
        public function nextToken():String
        {
            return tokens[index++];
        }
    }
}