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
public class HFSPlusBTreeDescriptor {

    private int fLink;
    private int bLink;
    private BTreeNodeType kind;
    private byte height;
    private short numRecords;

    public HFSPlusBTreeDescriptor(DataInputStream dis) {
        try {
            fLink = dis.readInt();
            bLink = dis.readInt();
            switch(dis.readByte()) {
                case -1:
                    kind = BTreeNodeType.LEAF_NODE;
                    break;
                case 0:
                    kind = BTreeNodeType.INDEX_NODE;
                    break;
                case 1:
                    kind = BTreeNodeType.HEADER_NODE;
                    break;
                case 2:
                    kind = BTreeNodeType.MAP_NODE;
                    break;
                default:
                    throw new IllegalArgumentException("Invalid HFSPlusBTreeDescriptor data. Unknown node type.");
            }
            height = dis.readByte();
            numRecords = dis.readShort();
            dis.readShort();
        } catch (IOException e) {
            throw new IllegalArgumentException("Invalid HFSPlusBTreeDescriptor data.");
        }
    }

    public int getfLink() {
        return fLink;
    }

    public int getbLink() {
        return bLink;
    }

    public BTreeNodeType getKind() {
        return kind;
    }

    public byte getHeight() {
        return height;
    }

    public short getNumRecords() {
        return numRecords;
    }

    @Override
    public String toString() {
        return "HFSPlusBTreeDescriptor{" +
                "fLink=" + fLink +
                ", bLink=" + bLink +
                ", kind=" + kind +
                ", height=" + height +
                ", numRecords=" + numRecords +
                '}';
    }

    public enum BTreeNodeType {
        LEAF_NODE,
        INDEX_NODE,
        HEADER_NODE,
        MAP_NODE
    }

}
