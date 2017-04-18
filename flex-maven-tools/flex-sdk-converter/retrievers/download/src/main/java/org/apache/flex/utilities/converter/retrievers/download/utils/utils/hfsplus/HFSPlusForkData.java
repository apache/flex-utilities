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
import java.util.ArrayList;
import java.util.List;

/**
 * Created by christoferdutz on 26.02.16.
 */
public class HFSPlusForkData {

    private long logicalSize;
    private int clumpSize;
    private int totalBlocks;
    private List<HFSPlusExtent> extents;

    public HFSPlusForkData(DataInputStream dis) {
        try {
            logicalSize = dis.readLong();
            clumpSize = dis.readInt();
            totalBlocks = dis.readInt();
            extents = new ArrayList<HFSPlusExtent>(8);
            for(int i = 0; i < 8; i++) {
                HFSPlusExtent extent = new HFSPlusExtent(dis);
                extents.add(extent);
            }
        } catch (IOException e) {
            throw new IllegalArgumentException("Invalid HFSPlusVolumeHeader data.");
        }
    }

    public long getLogicalSize() {
        return logicalSize;
    }

    public int getClumpSize() {
        return clumpSize;
    }

    public int getTotalBlocks() {
        return totalBlocks;
    }

    public List<HFSPlusExtent> getExtents() {
        return extents;
    }

    @Override
    public String toString() {
        return "HFSPlusForkData{" +
                "logicalSize=" + logicalSize +
                ", clumpSize=" + clumpSize +
                ", totalBlocks=" + totalBlocks +
                ", extents=" + extents +
                '}';
    }
}
