/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.flex.utilities.converter.core;

import org.apache.flex.utilities.converter.air.AirConverter;
import org.apache.flex.utilities.converter.retrievers.download.DownloadRetriever;
import org.apache.flex.utilities.converter.retrievers.types.PlatformType;
import org.apache.flex.utilities.converter.retrievers.types.SdkType;

import java.io.File;

/**
 * Created by cdutz on 24.05.2014.
 */
public class AirDownloader {

    public void downloadAndConvert(File targetDirectory, String version, PlatformType platformType) throws Exception {
        final DownloadRetriever downloadRetriever = new DownloadRetriever();
        final File airSDKSourceDirectory = downloadRetriever.retrieve(SdkType.AIR, version, platformType);

        final AirConverter airConverter = new AirConverter(airSDKSourceDirectory, targetDirectory);
        airConverter.convert();
    }

    public static void main(String[] args) throws Exception {
        if(args.length != 3) {
            System.out.println("Usage: AirDownloader {air-version} {target-directory} {platform-type}");
            return;
        }

        final String version = args[0];
        final File targetDirectory = new File(args[1]);
        final PlatformType platformType = PlatformType.valueOf(args[2]);
        if(platformType == null) {
            throw new Exception("Unknown platform type: " + args[2]);
        }

        new AirDownloader().downloadAndConvert(targetDirectory, version, platformType);
    }

}
