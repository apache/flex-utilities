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
package org.apache.flex.pmd.rules.parsley;

import org.apache.flex.pmd.nodes.*;
import org.apache.flex.pmd.rules.core.AbstractFlexMetaDataRule;
import org.apache.flex.pmd.rules.core.ViolationPriority;
import org.apache.flex.pmd.rules.parsley.utils.ParsleyMetaData;

import java.util.List;

/**
 * @author xagnetti
 */
public final class InaccessibleMetaDataRule extends AbstractFlexMetaDataRule {
    /*
     * (non-Javadoc)
     * @seecom.adobe.ac.pmd.rules.core.AbstractFlexMetaDataRule#
     * findViolationsFromAttributeMetaData(com.adobe.ac.pmd.nodes.IAttribute)
     */
    @Override
    protected void findViolationsFromAttributeMetaData(final IAttribute attribute) {
        findInaccessibleNodes(attribute,
                attribute);
    }

    /*
     * (non-Javadoc)
     * @seecom.adobe.ac.pmd.rules.core.AbstractFlexMetaDataRule#
     * findViolationsFromClassMetaData(com.adobe.ac.pmd.nodes.IClass)
     */
    @Override
    protected void findViolationsFromClassMetaData(final IClass classNode) {
        findInaccessibleNodes(classNode,
                classNode);
    }

    /*
     * (non-Javadoc)
     * @seecom.adobe.ac.pmd.rules.core.AbstractFlexMetaDataRule#
     * findViolationsFromFunctionMetaData(com.adobe.ac.pmd.nodes.IFunction)
     */
    @Override
    protected void findViolationsFromFunctionMetaData(final IFunction function) {
        findInaccessibleNodes(function,
                function);
    }

    /*
     * (non-Javadoc)
     * @see com.adobe.ac.pmd.rules.core.AbstractFlexRule#getDefaultPriority()
     */
    @Override
    protected ViolationPriority getDefaultPriority() {
        return ViolationPriority.NORMAL;
    }

    private void findInaccessibleNodes(final IMetaDataListHolder holder,
                                       final IVisible visibility) {
        final List<IMetaData> allMetaData = holder.getMetaData(MetaData.OTHER);

        if (allMetaData != null) {
            for (final IMetaData metaData : allMetaData) {
                if (ParsleyMetaData.isParsleyMetaData(metaData.getName())
                        && !visibility.isPublic()) {
                    addViolation(metaData);
                }
            }
        }
    }
}