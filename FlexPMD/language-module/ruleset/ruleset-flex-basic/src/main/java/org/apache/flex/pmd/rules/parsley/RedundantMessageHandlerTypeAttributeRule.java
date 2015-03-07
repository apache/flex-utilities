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

import org.apache.flex.pmd.nodes.IFunction;
import org.apache.flex.pmd.nodes.IIdentifierNode;
import org.apache.flex.pmd.nodes.IMetaData;
import org.apache.flex.pmd.nodes.IParameter;
import org.apache.flex.pmd.rules.core.AbstractFlexMetaDataRule;
import org.apache.flex.pmd.rules.core.ViolationPriority;
import org.apache.flex.pmd.rules.parsley.utils.ParsleyMetaData;

import java.util.List;

/**
 * @author xagnetti
 */
public final class RedundantMessageHandlerTypeAttributeRule extends AbstractFlexMetaDataRule {
    /*
     * (non-Javadoc)
     * @seecom.adobe.ac.pmd.rules.core.AbstractFlexMetaDataRule#
     * findViolationsFromFunctionMetaData(com.adobe.ac.pmd.nodes.IFunction)
     */
    @Override
    protected void findViolationsFromFunctionMetaData(final IFunction function) {
        final List<IParameter> params = function.getParameters();

        if (params.size() == 1) {
            final IIdentifierNode parameterType = params.get(0).getType();
            findMessageHandlersContainingType(function,
                    parameterType);
        }
    }

    /*
     * (non-Javadoc)
     * @see com.adobe.ac.pmd.rules.core.AbstractFlexRule#getDefaultPriority()
     */
    @Override
    protected ViolationPriority getDefaultPriority() {
        return ViolationPriority.NORMAL;
    }

    private void findMessageHandlersContainingType(final IFunction function,
                                                   final IIdentifierNode type) {
        final List<IMetaData> handlers = ParsleyMetaData.MESSAGE_HANDLER.getMetaDataList(function);

        for (final IMetaData handler : handlers) {
            final String parameterType = type.toString();
            final String metaDataType = getMessageHandlerType(handler);

            if (metaDataType != null
                    && metaDataType.equals(parameterType)) {
                addViolation(handler);
            }
        }
    }

    private String getMessageHandlerType(final IMetaData handler) {
        final String[] types = handler.getProperty("type");
        String type = "";

        if (types.length > 0
                && types[0].contains(".")) {
            type = types[0];
            final int index = type.lastIndexOf('.') + 1;

            if (index < type.length()) {
                type = type.substring(index);
            }
        }

        return type;
    }
}