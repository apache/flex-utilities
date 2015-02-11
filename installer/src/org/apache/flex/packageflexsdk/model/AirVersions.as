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
    import mx.collections.ArrayCollection;

    public class AirVersions extends ArrayCollection
    {

        public var defaultVersionIndex:int = -1;

        public function AirVersions()
        {
        }

        public function processXML(airData:XMLList):void
        {
            var airVersionList:XMLList = airData[0].children();
            var _defaultVersion:String = airData[0]["@default"].toString();
            var newAIRVersion:AvailableAirVersion;
            for each (var airVersion:XML in airVersionList)
            {
                newAIRVersion = new AvailableAirVersion();
                newAIRVersion.label = "AIR " + airVersion.@displayVersion.toString();
                newAIRVersion.version = airVersion.@version.toString();
                newAIRVersion.path = airVersion.path.toString();
                newAIRVersion.file = airVersion.file.toString();
                newAIRVersion.versionID = null;
                if (airVersion.@versionID.length() > 0)
                {
                    newAIRVersion.versionID = airVersion.@versionID.toString();
                }
                if (newAIRVersion.version == _defaultVersion)
                {
                    defaultVersionIndex = this.length;
                }
                this.addItem(newAIRVersion);
            }


        }
    }
}
