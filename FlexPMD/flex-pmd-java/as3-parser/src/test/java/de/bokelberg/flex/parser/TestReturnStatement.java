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

public class TestReturnStatement extends AbstractStatementTest
{
   @Test
   public void testEmptyReturn() throws TokenException
   {
      assertStatement( "1",
                       "return",
                       "<return line=\"2\"></return>" );

      assertStatement( "2",
                       "return;",
                       "<return line=\"2\"></return>" );
   }

   @Test
   public void testFlexPMD181a() throws TokenException
   {
      assertStatement( "1",
                       "return (str1 === str2);",
                       "<return line=\"1\"><primary line=\"1\"><encapsulated line=\"1\">"
                             + "<equality line=\"1\"><primary line=\"1\">str1</primary><op line=\"1\">"
                             + "===</op><primary line=\"1\">str2</primary></equality>"
                             + "</encapsulated></primary></return>" );
   }

   @Test
   public void testFlexPMD181b() throws TokenException
   {
      assertStatement( "1",
                       "return testString(str, /^[a-zA-Z\\s]*$/);",
                       "<return line=\"1\"><call line=\"1\"><primary line=\"1\">testString"
                             + "</primary><arguments line=\"1\"><primary line=\"1\">str</primary>"
                             + "<primary line=\"1\">/^[a-zA-Z\\s]*$/</primary></arguments></call></return>" );
   }

   @Test
   public void testReturnArrayLiteral() throws TokenException
   {
      assertStatement( "1",
                       "return []",
                       "<return line=\"1\"><primary line=\"1\">"
                             + "<array line=\"1\"></array></primary></return>" );
      assertStatement( "2",
                       "return [];",
                       "<return line=\"1\"><primary line=\"1\">"
                             + "<array line=\"1\"></array></primary></return>" );
   }
}
