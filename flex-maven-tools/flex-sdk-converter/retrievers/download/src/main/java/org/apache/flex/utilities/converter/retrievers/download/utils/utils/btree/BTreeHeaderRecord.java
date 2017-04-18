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
package org.apache.flex.utilities.converter.retrievers.download.utils.utils.btree;

import java.io.DataInputStream;
import java.io.IOException;

/**
 * Created by christoferdutz on 15.04.17.
 */
public class HFSPlusBTreeHeaderRecord {

    private short treeDepth;
    private int rootNode;
    private int leafRecords;
    private int firstLeafNode;
    private int lastLeafNode;
    private short nodeSize;
    private short maxKeyLength;
    private int totalNodes;
    private int freeNodes;
    //private short reserved1;
    private int clumpSize;
    private byte btreeType;
    private byte keyCompareType;
    private int attributes;
    //private int reserved3[16];

    public HFSPlusBTreeHeaderRecord(DataInputStream dis) {
        try {
            treeDepth = dis.readShort();
            rootNode = dis.readInt();
            leafRecords = dis.readInt();
            firstLeafNode = dis.readInt();
            lastLeafNode = dis.readInt();
            nodeSize = dis.readShort();
            maxKeyLength = dis.readShort();
            totalNodes = dis.readInt();
            freeNodes = dis.readInt();
            dis.readShort();
            clumpSize = dis.readInt();
            btreeType = dis.readByte();
            keyCompareType = dis.readByte();
            attributes = dis.readInt();
            // read 16 bytes ...
            if(dis.read(new byte[16]) != 16) {
                throw new IllegalArgumentException("Invalid HFSPlusBTreeHeaderRecord data.");
            }
        } catch (IOException e) {
            throw new IllegalArgumentException("Invalid HFSPlusBTreeHeaderRecord data.");
        }
    }

    /**
     * @return The current depth of the B-tree. Always equal to the height field of the root node.
     */
    public short getTreeDepth() {
        return treeDepth;
    }

    /**
     * @return The node number of the root node, the index node that acts as the root of the B-tree.
     */
    public int getRootNode() {
        return rootNode;
    }

    /**
     * @return The total number of records contained in all of the leaf nodes.
     */
    public int getLeafRecords() {
        return leafRecords;
    }

    /**
     * @return The node number of the first leaf node. This may be zero if there are no leaf nodes.
     */
    public int getFirstLeafNode() {
        return firstLeafNode;
    }

    /**
     * @return The node number of the last leaf node. This may be zero if there are no leaf nodes.
     */
    public int getLastLeafNode() {
        return lastLeafNode;
    }

    /**
     * @return The size, in bytes, of a node. This is a power of two, from 512 through 32,768, inclusive.
     */
    public short getNodeSize() {
        return nodeSize;
    }

    /**
     * @return The maximum length of a key in an index or leaf node.
     */
    public short getMaxKeyLength() {
        return maxKeyLength;
    }

    /**
     * @return The total number of nodes (be they free or used) in the B-tree.
     */
    public int getTotalNodes() {
        return totalNodes;
    }

    /**
     * @return The number of unused nodes in the B-tree.
     */
    public int getFreeNodes() {
        return freeNodes;
    }

    /**
     * @return clumpSize
     */
    public int getClumpSize() {
        return clumpSize;
    }

    public byte getBtreeType() {
        return btreeType;
    }

    public byte getKeyCompareType() {
        return keyCompareType;
    }

    public int getAttributes() {
        return attributes;
    }

    @Override
    public String toString() {
        return "HFSPlusBTreeHeaderRecord{" +
                "treeDepth=" + treeDepth +
                ", rootNode=" + rootNode +
                ", leafRecords=" + leafRecords +
                ", firstLeafNode=" + firstLeafNode +
                ", lastLeafNode=" + lastLeafNode +
                ", nodeSize=" + nodeSize +
                ", maxKeyLength=" + maxKeyLength +
                ", totalNodes=" + totalNodes +
                ", freeNodes=" + freeNodes +
                ", clumpSize=" + clumpSize +
                ", btreeType=" + btreeType +
                ", keyCompareType=" + keyCompareType +
                ", attributes=" + attributes +
                '}';
    }
}
