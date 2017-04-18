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
package org.apache.flex.utilities.converter.retrievers.download.utils.utils;

import java.io.DataInputStream;
import java.io.IOException;

/**
 * Created by christoferdutz on 15.04.17.
 */
public class HFSPlusFinderInfo {

    private int bootableSystemDirectoryId;
    private int startupApplicationParentDirectoryId;
    private int onMountOpenDirectoryId;
    private int bootableMacOs8Or9SystemDirectoryId;
    private int bootableMacOsXSystemDirectoryId;
    private long uniqueVolumeIdentifyer;

    public HFSPlusFinderInfo(DataInputStream dis) {
        try {
            bootableSystemDirectoryId = dis.readInt();
            startupApplicationParentDirectoryId = dis.readInt();
            onMountOpenDirectoryId = dis.readInt();
            bootableMacOs8Or9SystemDirectoryId = dis.readInt();
            dis.readInt();
            bootableMacOsXSystemDirectoryId = dis.readInt();
            uniqueVolumeIdentifyer = dis.readLong();
        } catch (IOException e) {
            throw new IllegalArgumentException("Invalid HFSPlusVolumeHeader data.");
        }
    }

    public int getBootableSystemDirectoryId() {
        return bootableSystemDirectoryId;
    }

    public int getStartupApplicationParentDirectoryId() {
        return startupApplicationParentDirectoryId;
    }

    public int getOnMountOpenDirectoryId() {
        return onMountOpenDirectoryId;
    }

    public int getBootableMacOs8Or9SystemDirectoryId() {
        return bootableMacOs8Or9SystemDirectoryId;
    }

    public int getBootableMacOsXSystemDirectoryId() {
        return bootableMacOsXSystemDirectoryId;
    }

    public long getUniqueVolumeIdentifyer() {
        return uniqueVolumeIdentifyer;
    }

}
