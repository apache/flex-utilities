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
package de.bokelberg.flex.parser;

import org.junit.Test;

import com.adobe.ac.pmd.parser.exceptions.TokenException;

public class TestE4xExpression extends AbstractStatementTest
{
   @Test
   public void testE4xFilter() throws TokenException
   {
      assertStatement( "",
                       "myXml.(lala=\"lala\")",
                       "<e4x-filter line=\"1\"><primary line=\"1\">myXml"
                             + "</primary><assign line=\"1\"><primary line=\"1\">"
                             + "lala</primary><op line=\"1\">=</op><primary line=\"1\">"
                             + "\"lala\"</primary></assign></e4x-filter>" );

      assertStatement( "",
                       "doc.*.worm[1]",
                       "<mul line=\"1\"><e4x-star line=\"1\"><primary line=\"1\""
                             + ">doc</primary></e4x-star><op line=\"1\">*</op><primary "
                             + "line=\"1\">.</primary></mul>" );

      assertStatement( "",
                       "doc.@worm",
                       "<dot line=\"1\"><primary line=\"1\">doc</primary><primary "
                             + "line=\"1\">@worm</primary></dot>" );
   }
}
