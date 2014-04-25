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
package com.adobe.ac.pmd.model
{
    public class File
    {
        private var _path : String;

        public function File( path : String )
        {
            _path = path;
        }

        public function get path() : String
        {
            return _path;
        }

        public function get shortPath() : String
        {
            var srcIndex : int = path.indexOf( "src" );
			var result : String = path;

            if ( srcIndex != -1 )
            {
                var regexp : RegExp = new RegExp( "/", "g" );
				result = path.substr( srcIndex + 4 ).replace( regexp, "." );
            }
            return result;
        }
    }
}