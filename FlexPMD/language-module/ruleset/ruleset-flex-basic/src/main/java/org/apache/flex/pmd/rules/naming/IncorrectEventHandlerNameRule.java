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
package org.apache.flex.pmd.rules.naming;

import net.sourceforge.pmd.lang.rule.properties.StringProperty;
import org.apache.flex.pmd.nodes.IFunction;
import org.apache.flex.pmd.parser.IParserNode;
import org.apache.flex.pmd.rules.core.AbstractAstFlexRule;
import org.apache.flex.pmd.rules.core.ViolationPriority;

public class IncorrectEventHandlerNameRule extends AbstractAstFlexRule {

    private static final StringProperty PREFIX_DESCRIPTOR = new StringProperty(
            "prefix",
            "",
            "on",
            1.0f
    );
    private static final StringProperty SUFFIX_DESCRIPTOR = new StringProperty(
            "suffix",
            "",
            "",
            1.0f
    );

    private final String prefix;
    private final String suffix;

    public IncorrectEventHandlerNameRule() {
        super();
        prefix = getProperty(PREFIX_DESCRIPTOR);
        suffix = getProperty(SUFFIX_DESCRIPTOR);
    }

    @Override
    protected void findViolations(final IFunction function) {
        if (function.isEventHandler()
                && !(function.getName().startsWith(prefix) && function.getName().endsWith(suffix))) {
            final IParserNode name = getNameFromFunctionDeclaration(function.getInternalNode());

            addViolation(name,
                    name.getStringValue(),
                    prefix,
                    suffix);
        }
    }

    @Override
    protected ViolationPriority getDefaultPriority() {
        return ViolationPriority.LOW;
    }

}
