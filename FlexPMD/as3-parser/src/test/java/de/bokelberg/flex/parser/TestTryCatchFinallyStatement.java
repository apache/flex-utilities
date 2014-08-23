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

public class TestTryCatchFinallyStatement extends AbstractStatementTest
{
   @Test
   public void testCatch() throws TokenException
   {
      assertStatement( "1",
                       "catch( e : Error ) {trace( true ); }",
                       "<catch line=\"1\"><name line=\"1\">e"
                             + "</name><type line=\"1\">Error</type><block line=\"1\">"
                             + "<call line=\"1\"><primary line=\"1\">trace</primary>"
                             + "<arguments line=\"1\"><primary line=\"1\">true"
                             + "</primary></arguments></call></block></catch>" );
   }

   @Test
   public void testFinally() throws TokenException
   {
      assertStatement( "1",
                       "finally {trace( true ); }",
                       "<finally line=\"1\"><block line=\"1\">"
                             + "<call line=\"1\"><primary line=\"1\">"
                             + "trace</primary><arguments line=\"1\"><primary line=\"1\">"
                             + "true</primary></arguments></call></block></finally>" );
   }

   @Test
   public void testTry() throws TokenException
   {
      assertStatement( "1",
                       "try {trace( true ); }",
                       "<try line=\"1\"><block line=\"1\">"
                             + "<call line=\"1\"><primary line=\"1\">"
                             + "trace</primary><arguments line=\"1\"><primary line=\"1\">"
                             + "true</primary></arguments></call></block></try>" );
   }
}
