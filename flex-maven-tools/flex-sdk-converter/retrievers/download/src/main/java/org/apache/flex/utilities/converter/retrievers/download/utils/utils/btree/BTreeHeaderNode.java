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

/**
 * Created by christoferdutz on 15.04.17.
 */
public class HFSPlusBTreeHeaderNode extends HFSPlusBTreeNode {

    private HFSPlusBTreeHeaderRecord headerRecord;
    private HFSPlusBTreeUserDataRecord userDataRecord;
    private HFSPlusBTreeMapRecord mapRecord;

    public HFSPlusBTreeHeaderNode(DataInputStream dis) {
        super(dis);
    }

    public HFSPlusBTreeHeaderRecord getHeaderRecord() {
        return headerRecord;
    }

    public HFSPlusBTreeUserDataRecord getUserDataRecord() {
        return userDataRecord;
    }

    public HFSPlusBTreeMapRecord getMapRecord() {
        return mapRecord;
    }

    @Override
    public String toString() {
        return "HFSPlusBTreeHeaderNode{" +
                super.toString() +
                "headerRecord=" + headerRecord +
                ", userDataRecord=" + userDataRecord +
                ", mapRecord=" + mapRecord +
                '}';
    }
}
