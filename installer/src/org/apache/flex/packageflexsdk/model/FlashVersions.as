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

    public class FlashVersions extends ArrayCollection
    {
        public const MAX_LINUX_FLASH_VERSION:Number = 11.2;

        public var defaultVersionIndex:int = -1;

        public function FlashVersions()
        {
        }

        public function processXML(flashData:XMLList, isLinux:Boolean):void
        {
            var flashVersionList:XMLList = flashData[0].children();
            var _defaultVersion:String = flashData[0]["@default"].toString();
            var newFlashVersion:AvailableFlashVersion;
            for each (var flashVersion:XML in flashVersionList)
            {
                newFlashVersion = new AvailableFlashVersion();
                newFlashVersion.version = flashVersion.@version.toString();
                if (!isLinux || Number(newFlashVersion.version) <= MAX_LINUX_FLASH_VERSION)
                {
                    newFlashVersion.label = "Flash Player " + flashVersion.@displayVersion.toString();
                    newFlashVersion.versionID = null;
                    newFlashVersion.swfVersion = flashVersion.swfversion.toString();
                    newFlashVersion.path = flashVersion.path.toString();
                    newFlashVersion.file = flashVersion.file.toString();

                    if (flashVersion.@versionID.length() > 0)
                    {
                        newFlashVersion.versionID = flashVersion.@versionID.toString();
                    }

                    if (newFlashVersion.version == _defaultVersion)
                    {
                        defaultVersionIndex = this.length;
                    }

                    this.addItem(newFlashVersion);
                }
            }

        }
    }
}
