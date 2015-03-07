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
package org.apache.flex.pmd.nodes.impl;

import org.apache.flex.pmd.nodes.IMetaDataListHolder;
import org.apache.flex.pmd.nodes.IModifiersHolder;
import org.apache.flex.pmd.nodes.INode;
import org.apache.flex.pmd.nodes.Modifier;
import org.apache.flex.pmd.parser.IParserNode;

import java.util.logging.Logger;

/**
 * @author xagnetti
 */
abstract class AbstractNode implements INode {
    protected static final Logger LOGGER = Logger.getLogger("Node");

    /**
     * @param metaDataHolder
     * @param child
     */
    protected static void computeMetaDataList(final IMetaDataListHolder metaDataHolder,
                                              final IParserNode child) {
        if (child.numChildren() != 0) {
            for (final IParserNode metadataNode : child.getChildren()) {
                metaDataHolder.add(NodeFactory.createMetaData(metadataNode));
            }
        }
    }

    /**
     * @param modifiable
     * @param child
     */
    protected static final void computeModifierList(final IModifiersHolder modifiable,
                                                    final IParserNode child) {
        if (child.numChildren() != 0) {
            for (final IParserNode modifierNode : child.getChildren()) {
                final Modifier modifier = Modifier.create(modifierNode.getStringValue());

                modifiable.add(modifier);
            }
        }
    }

    private final IParserNode internalNode;

    /**
     * @param node
     */
    protected AbstractNode(final IParserNode node) {
        internalNode = node;
    }

    /**
     * @return
     */
    public abstract AbstractNode compute();

    /*
     * (non-Javadoc)
     * @see com.adobe.ac.pmd.nodes.INode#getInternalNode()
     */
    public IParserNode getInternalNode() {
        return internalNode;
    }
}