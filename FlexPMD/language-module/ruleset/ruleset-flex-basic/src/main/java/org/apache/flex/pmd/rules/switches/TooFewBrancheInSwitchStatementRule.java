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
package org.apache.flex.pmd.rules.switches;

import net.sourceforge.pmd.PropertyDescriptor;
import net.sourceforge.pmd.lang.rule.properties.IntegerProperty;
import org.apache.flex.pmd.parser.IParserNode;
import org.apache.flex.pmd.rules.core.AbstractAstFlexRule;
import org.apache.flex.pmd.rules.core.ViolationPriority;
import org.apache.flex.pmd.rules.core.thresholded.IThresholdedRule;

/**
 * @author xagnetti
 */
public class TooFewBrancheInSwitchStatementRule extends AbstractAstFlexRule implements IThresholdedRule {
    public static final int DEFAULT_THRESHOLD = 3;
    private int switchCases;

    public TooFewBrancheInSwitchStatementRule() {
        super();
        definePropertyDescriptor(new IntegerProperty(
                getThresholdName(), "TODO: Put some real text here ...",
                0, Integer.MAX_VALUE, getDefaultThreshold(), 1.0f));
    }

    /*
         * (non-Javadoc)
         * @seecom.adobe.ac.pmd.rules.core.thresholded.IThresholdedRule#
         * getActualValueForTheCurrentViolation()
         */
    public final int getActualValueForTheCurrentViolation() {
        return switchCases;
    }

    /*
     * (non-Javadoc)
     * @see
     * com.adobe.ac.pmd.rules.core.thresholded.IThresholdedRule#getDefaultThreshold
     * ()
     */
    public final int getDefaultThreshold() {
        return DEFAULT_THRESHOLD;
    }

    /*
     * (non-Javadoc)
     * @see
     * com.adobe.ac.pmd.rules.core.thresholded.IThresholdedRule#getThreshold()
     */
    public final int getThreshold() {
        return getProperty((PropertyDescriptor<Integer>) getPropertyDescriptor(getThresholdName()));
    }

    /*
     * (non-Javadoc)
     * @see
     * com.adobe.ac.pmd.rules.core.thresholded.IThresholdedRule#getThresholdName
     * ()
     */
    public final String getThresholdName() {
        return MINIMUM;
    }

    /*
     * (non-Javadoc)
     * @see com.adobe.ac.pmd.rules.core.AbstractFlexRule#getDefaultPriority()
     */
    @Override
    protected final ViolationPriority getDefaultPriority() {
        return ViolationPriority.LOW;
    }

    /*
     * (non-Javadoc)
     * @see
     * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#visitSwitch(com.adobe.
     * ac.pmd.parser.IParserNode)
     */
    @Override
    protected final void visitSwitch(final IParserNode ast) {
        switchCases = 0;

        super.visitSwitch(ast);

        if (switchCases < getThreshold()) {
            addViolation(ast);
        }
    }

    /*
     * (non-Javadoc)
     * @see
     * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#visitSwitchCase(com.adobe
     * .ac.pmd.parser.IParserNode)
     */
    @Override
    protected final void visitSwitchCase(final IParserNode child) {
        super.visitSwitchCase(child);

        switchCases++;
    }

    /*
     * (non-Javadoc)
     * @see
     * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#visitSwitchDefaultCase
     * (com.adobe.ac.pmd.parser.IParserNode)
     */
    @Override
    protected void visitSwitchDefaultCase(final IParserNode defaultCaseNode) {
        super.visitSwitchDefaultCase(defaultCaseNode);

        switchCases++;
    }
}
