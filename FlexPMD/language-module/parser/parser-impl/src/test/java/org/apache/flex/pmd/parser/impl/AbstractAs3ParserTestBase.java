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

import org.apache.flex.pmd.parser.IParserNode;
import org.testng.annotations.BeforeMethod;

public abstract class AbstractAs3ParserTestBase {

    protected final class ASTToXMLConverter {
        public String convert(final IParserNode ast) {
            final StringBuilder result = new StringBuilder();
            visitNodes(ast, result, 0);
            return result.toString();
        }
    }

    private static String escapeEntities(final String stringToEscape) {
        final StringBuilder buffer = new StringBuilder();

        for (int i = 0; i < stringToEscape.length(); i++) {
            final char currentCharacter = stringToEscape.charAt(i);

            if (currentCharacter == '<') {
                buffer.append("&lt;");
            } else if (currentCharacter == '>') {
                buffer.append("&gt;");
            } else {
                buffer.append(currentCharacter);
            }
        }
        return buffer.toString();
    }

    private static void visitNodes(final IParserNode ast,
                                   final StringBuilder result,
                                   final int level) {
        result.append("<").append(ast.getId()).append(" line=\"").append(ast.getLine()).append("\">");

        final int numChildren = ast.numChildren();
        if (numChildren > 0) {
            for (int i = 0; i < numChildren; i++) {
                visitNodes(ast.getChild(i), result, level + 1);
            }
        } else if (ast.getStringValue() != null) {
            result.append(escapeEntities(ast.getStringValue()));
        }
        result.append("</").append(ast.getId()).append(">");
    }

    protected AS3Parser asp;
    protected AS3Scanner scn;

    @BeforeMethod(alwaysRun = true)
    public void setUp() {
        asp = new AS3Parser(null);
        scn = asp.getScn();
    }

}