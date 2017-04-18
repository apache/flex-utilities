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

/**
 * Created by christoferdutz on 27.02.16.
 */
public class HFSPlusExtent {

    private int startBlock;
    private int blockCount;

    public HFSPlusExtent(DataInputStream dis) {
        try {
            startBlock = dis.readInt();
            blockCount = dis.readInt();
        } catch (IOException e) {
            throw new IllegalArgumentException("Invalid HFSPlusVolumeHeader data.");
        }
    }

    public int getStartBlock() {
        return startBlock;
    }

    public int getBlockCount() {
        return blockCount;
    }

    @Override
    public String toString() {
        return "HFSPlusExtent{" +
                "startBlock=" + startBlock +
                ", blockCount=" + blockCount +
                '}';
    }

}
