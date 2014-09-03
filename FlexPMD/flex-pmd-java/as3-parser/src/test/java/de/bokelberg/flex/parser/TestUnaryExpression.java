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

public class TestUnaryExpression extends AbstractStatementTest
{
   @Test
   public void testArrayAccess() throws TokenException
   {
      assertStatement( "1",
                       "x[0]",
                       "<arr-acc line=\"1\"><primary line=\"1\">x<"
                             + "/primary><primary line=\"1\">0</primary></arr-acc>" );
   }

   @Test
   public void testComplex() throws TokenException
   {
      assertStatement( "1",
                       "a.b['c'].d.e(1)",
                       "<dot line=\"1\"><primary line=\"1\">a"
                             + "</primary><dot line=\"1\"><arr-acc line=\"1\">"
                             + "<primary line=\"1\">b</primary><primary line=\"1\">"
                             + "'c'</primary></arr-acc><dot line=\"1\"><primary line=\"1\">"
                             + "d</primary><call line=\"1\"><primary line=\"1\">e"
                             + "</primary><arguments line=\"1\"><primary line=\"1\">1"
                             + "</primary></arguments></call></dot></dot></dot>" );

      assertStatement( "2",
                       "a.b['c']['d'].e(1)",
                       "<dot line=\"1\"><primary line=\"1\">a"
                             + "</primary><dot line=\"1\"><arr-acc line=\"1\">"
                             + "<primary line=\"1\">b</primary><primary line=\"1\">"
                             + "'c'</primary><primary line=\"1\">'d'</primary>"
                             + "</arr-acc><call line=\"1\"><primary line=\"1\">"
                             + "e</primary><arguments line=\"1\"><primary line=\"1\">1"
                             + "</primary></arguments></call></dot></dot>" );
   }

   @Test
   public void testMethodCall() throws TokenException
   {
      assertStatement( "1",
                       "method()",
                       "<call line=\"1\"><primary line=\"1\">"
                             + "method</primary><arguments line=\"1\"></arguments></call>" );

      assertStatement( "2",
                       "method( 1, \"two\" )",
                       "<call line=\"1\"><primary line=\"1\">"
                             + "method</primary><arguments line=\"1\"><primary line=\"1\">1"
                             + "</primary><primary line=\"1\">\"two\"</primary></arguments></call>" );
   }

   @Test
   public void testMultipleMethodCall() throws TokenException
   {
      assertStatement( "1",
                       "method()()",
                       "<call line=\"1\"><primary line=\"1\">"
                             + "method</primary><arguments line=\"1\"></arguments>"
                             + "<arguments line=\"1\"></arguments></call>" );
   }

   @Test
   public void testParseUnaryExpressions() throws TokenException
   {
      assertStatement( "1",
                       "++x",
                       "<pre-inc line=\"1\"><primary line=\"1\">x</primary></pre-inc>" );
      assertStatement( "2",
                       "x++",
                       "<post-inc line=\"2\"><primary line=\"1\">x</primary></post-inc>" );
      assertStatement( "3",
                       "--x",
                       "<pre-dec line=\"1\"><primary line=\"1\">x</primary></pre-dec>" );
      assertStatement( "4",
                       "x--",
                       "<post-dec line=\"2\"><primary line=\"1\">x</primary></post-dec>" );
      assertStatement( "5",
                       "+x",
                       "<plus line=\"1\"><primary line=\"1\">x</primary></plus>" );
      assertStatement( "6",
                       "+ x",
                       "<plus line=\"1\"><primary line=\"1\">x</primary></plus>" );
      assertStatement( "7",
                       "-x",
                       "<minus line=\"1\"><primary line=\"1\">x</primary></minus>" );
      assertStatement( "8",
                       "- x",
                       "<minus line=\"1\"><primary line=\"1\">x</primary></minus>" );
      assertStatement( "9",
                       "delete x",
                       "<delete line=\"1\"><primary line=\"1\">x</primary></delete>" );
      assertStatement( "a",
                       "void x",
                       "<void line=\"1\"><primary line=\"1\">x</primary></void>" );
      assertStatement( "b",
                       "typeof x",
                       "<typeof line=\"1\"><primary line=\"1\">x</primary></typeof>" );
      assertStatement( "c",
                       "! x",
                       "<not line=\"1\"><primary line=\"1\">x</primary></not>" );
      assertStatement( "d",
                       "~ x",
                       "<b-not line=\"1\"><primary line=\"1\">x</primary></b-not>" );
      assertStatement( "e",
                       "x++",
                       "<post-inc line=\"2\"><primary line=\"1\">x</primary></post-inc>" );
      assertStatement( "f",
                       "x--",
                       "<post-dec line=\"2\"><primary line=\"1\">x</primary></post-dec>" );
   }
}
