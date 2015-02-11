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

package org.apache.flex.packageflexsdk.model
{
    public class AvailableFlexVersion
    {

        public var shortName:String;
        public var fileName:String;
        public var label:String;
        public var version:String;
        public var path:String;
        public var overlay:Boolean;
        public var prefix:String;
        public var legacy:Boolean;
        public var nocache:Boolean;
        public var needsAIR:Boolean;
        public var needsFlash:Boolean;
        public var devBuild:Boolean;
        public var icon:String;

        public function AvailableFlexVersion()
        {
        }

    }
}
