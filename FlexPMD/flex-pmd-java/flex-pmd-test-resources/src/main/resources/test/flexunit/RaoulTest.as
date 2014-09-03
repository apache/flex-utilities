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
package suite.cases
{
    import flexunit.framework.TestCase;

    import math.RaoulUtil;

    public class RaoulTest
    {
        private var classToTestRef : math.RaoulUtil;
        private static var _allowEdit : ArrayCollection = new ArrayCollection( [ COMMENT_ADDED, COMMENT_UPDATED ] );

        private static var _locked : Boolean;
        {
        	loacked = true;
        }

        [Before]
        public function setUp() : void
        {
            classToTestRef = new RaoulUtil();
        }

        [Test]
        public function foo() : void
        {
            classToTestRef.foo1();
        }

        [Test]
        public function fooAgain() : void
        {
            classToTestRef.foo();
        }

        public static function editAllowed( status : ActionItemCommentStatus ) : Boolean
        {
            return _allowEdit.contains( status );
        }

        /** Locked constructor will fail if used outside of the enum class */
        public function RaoulTest( key : int, name : String )
        {
            if ( _locked )
            {
                throw new Error( "Enumeration constructor is private, do not use externally" );
            }
            _key = key;
            _name = name;
        }
    }
}