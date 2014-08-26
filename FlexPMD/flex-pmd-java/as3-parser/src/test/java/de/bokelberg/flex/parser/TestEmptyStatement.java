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

public class TestEmptyStatement extends AbstractStatementTest
{
   @Test
   public void testComplex() throws TokenException
   {
      assertStatement( "1",
                       "{;1;;}",
                       "<block line=\"1\"><stmt-empty line=\"1\">;"
                             + "</stmt-empty><primary line=\"1\">1"
                             + "</primary><stmt-empty line=\"1\">;</stmt-empty></block>" );
   }

   @Test
   public void testSimple() throws TokenException
   {
      assertStatement( "1",
                       ";",
                       "<stmt-empty line=\"1\">;</stmt-empty>" );
   }
}
