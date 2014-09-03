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

public class TestDoStatement extends AbstractStatementTest
{
   @Test
   public void testDo() throws TokenException
   {
      assertStatement( "1",
                       "do{ trace( i ); } while( i++ );",
                       "<do line=\"1\"><block line=\"1\">"
                             + "<call line=\"1\"><primary line=\"1\">"
                             + "trace</primary><arguments line=\"1\">"
                             + "<primary line=\"1\">i</primary></arguments>"
                             + "</call></block><condition line=\"1\">"
                             + "<post-inc line=\"1\"><primary line=\"1\">"
                             + "i</primary></post-inc></condition></do>" );
   }

   @Test
   public void testDoWithEmptyStatement() throws TokenException
   {
      assertStatement( "1",
                       "do ; while( i++ ); ",
                       "<do line=\"1\"><stmt-empty line=\"1\">;</stmt-empty>"
                             + "<condition line=\"1\"><post-inc line=\"1\">"
                             + "<primary line=\"1\">i</primary></post-inc></condition></do>" );
   }

   @Test
   public void testDoWithoutBlock() throws TokenException
   {
      assertStatement( "1",
                       "do trace( i ); while( i++ ); ",
                       "<do line=\"1\"><call line=\"1\">"
                             + "<primary line=\"1\">trace</primary><arguments line=\"1\""
                             + "><primary line=\"1\">i</primary>"
                             + "</arguments></call><condition line=\"1\">"
                             + "<post-inc line=\"1\"><primary line=\"1\""
                             + ">i</primary></post-inc></condition></do>" );
   }
}
