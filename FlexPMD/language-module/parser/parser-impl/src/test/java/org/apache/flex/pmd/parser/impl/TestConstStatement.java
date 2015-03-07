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
package org.apache.flex.pmd.parser.impl;

import org.apache.flex.pmd.parser.exceptions.TokenException;
import org.testng.annotations.Test;

public class TestConstStatement extends AbstractStatementTestBase {

    @Test
    public void testFullFeaturedConst() throws TokenException {
        assertStatement("1",
                "const a : int = 4",
                "<const-list line=\"1\">"
                        + "<name-type-init line=\"1\">"
                        + "<name line=\"1\">a</name><type line=\"1\">int</type>"
                        + "<init line=\"1\"><primary line=\"1\">4</primary>"
                        + "</init></name-type-init></const-list>");
    }

    @Test
    public void testInitializedConst() throws TokenException {
        assertStatement("1",
                "const a = 4",
                "<const-list line=\"1\"><name-type-init line=\"1\">"
                        + "<name line=\"1\">a</name><type line=\"1\">"
                        + "</type><init line=\"1\"><primary line=\"1\">4"
                        + "</primary></init></name-type-init></const-list>");
    }

    @Test
    public void testSimpleConst() throws TokenException {
        assertStatement("1",
                "const a",
                "<const-list line=\"1\"><name-type-init line=\"1\">"
                        + "<name line=\"1\">a</name><type line=\"2\">"
                        + "</type></name-type-init></const-list>");
    }

    @Test
    public void testTypedConst() throws TokenException {
        assertStatement("1",
                "const a : Object",
                "<const-list line=\"1\"><name-type-init line=\"1\">"
                        + "<name line=\"1\">a</name><type line=\"1\">Object</type>"
                        + "</name-type-init></const-list>");
    }
}
