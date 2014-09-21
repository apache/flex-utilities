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

import org.apache.flex.utilities.converter.flash.FlashConverter;
import org.apache.flex.utilities.converter.retrievers.download.DownloadRetriever;
import org.apache.flex.utilities.converter.retrievers.types.SdkType;

import java.io.File;

/**
 * Created by cdutz on 24.05.2014.
 */
public class FlashDownloader {

    public void downloadAndConvert(File targetDirectory, String version) throws Exception {
        final DownloadRetriever downloadRetriever = new DownloadRetriever();
        final File playerglobalSourceFile = downloadRetriever.retrieve(SdkType.FLASH, version);

        final File tempSdkRoot = new File(playerglobalSourceFile.getParent(),
                playerglobalSourceFile.getName().substring(0, playerglobalSourceFile.getName().length() - 4) +
                        "-temp-dir");
        final File playerGlobalTargetDir = new File(tempSdkRoot,
                ("frameworks.libs.player.").replace(".", File.separator) + version);
        if(!playerGlobalTargetDir.mkdirs()) {
            throw new Exception("Couldn't create playerglobal target dir " + tempSdkRoot.getAbsolutePath());
        }
        final File playerGlobalTargetFile = new File(playerGlobalTargetDir, "playerglobal.swc");

        if(!playerglobalSourceFile.renameTo(playerGlobalTargetFile)) {
            throw new Exception("Couldn't move playerglobal file from " + playerglobalSourceFile.getAbsolutePath() +
                    " to " + playerGlobalTargetFile.getAbsolutePath());
        }

        final FlashConverter flashConverter = new FlashConverter(tempSdkRoot, targetDirectory);
        flashConverter.convert();
    }

    public static void main(String[] args) throws Exception {
        if(args.length != 2) {
            System.out.println("Usage: FlashDownloader {player-version} {target-directory}");
            return;
        }

        final String version = args[0];
        final File targetDirectory = new File(args[1]);

        new FlashDownloader().downloadAndConvert(targetDirectory, version);
    }

}
