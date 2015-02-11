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

    import org.apache.flex.utilities.common.Constants;

    public class FlexVersions extends ArrayCollection
    {
        public var defaultVersionIndex:int = -1;

        public function FlexVersions()
        {

        }

        public function showDevBuilds():void
        {
            this.filterFunction = null;
            this.refresh();
        }

        public function hideDevBuilds():void
        {
            this.filterFunction = devBuildFilterFunction;
            this.refresh();
        }

        public function processXML(flexData:XMLList, isWindows:Boolean):void
        {
            for each (var productData:XML in flexData)
            {
                var productVersionList:XMLList = productData.versions.children();

                for each (var productVersion:XML in productVersionList)
                {
                    var newFlexVersion:AvailableFlexVersion = new AvailableFlexVersion();
                    newFlexVersion.shortName = productVersion.@file.toString();
                    newFlexVersion.fileName = newFlexVersion.shortName + (isWindows ? Constants.ARCHIVE_EXTENSION_WIN : Constants.ARCHIVE_EXTENSION_MAC);
                    newFlexVersion.version = newFlexVersion.fileName.substr(productData.@prefix.toString().length).split("-")[0];
                    newFlexVersion.label = productData.@name.toString() + " " + productVersion.@version.toString();
                    newFlexVersion.path = productVersion.@path.toString();
                    newFlexVersion.devBuild = productVersion.@dev.toString() == "true";
                    newFlexVersion.legacy = productVersion.@legacy.toString() == "true";
                    newFlexVersion.nocache = productVersion.@nocache.toString() == "true";
                    newFlexVersion.overlay = productData.@overlay.toString() == "true";
                    newFlexVersion.needsAIR = productData.@needsAIR.toString() != "false";
                    newFlexVersion.needsFlash = productData.@needsFlash.toString() != "false";
                    newFlexVersion.icon =  productData.@icon.toString();
                    if (productVersion["@default"].length() == 1)
                    {
                        defaultVersionIndex = this.length;
                    }
                    this.addItem(newFlexVersion);
                }
            }

        }

        private function devBuildFilterFunction(o:Object):Boolean
        {
            return !o.devBuild;
        }
    }
}
