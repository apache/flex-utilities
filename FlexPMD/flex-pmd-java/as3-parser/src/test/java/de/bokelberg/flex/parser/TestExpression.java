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

public class TestExpression extends AbstractStatementTest
{
   @Test
   public void testAddExpression() throws TokenException
   {
      assertStatement( "1",
                       "5+6",
                       "<add line=\"1\"><primary line=\"1\""
                             + ">5</primary><op line=\"1\">+</op>" + "<primary line=\"1\">6</primary></add>" );
   }

   @Test
   public void testAndExpression() throws TokenException
   {
      assertStatement( "1",
                       "5&&6",
                       "<and line=\"1\"><primary line=\"1\">5</primary>"
                             + "<op line=\"1\">&&</op>" + "<primary line=\"1\">6</primary></and>" );
   }

   @Test
   public void testAssignmentExpression() throws TokenException
   {
      assertStatement( "1",
                       "x+=6",
                       "<assign line=\"1\"><primary line=\"1\">x"
                             + "</primary><op line=\"1\">+=</op><primary line=\"1\""
                             + ">6</primary></assign>" );
   }

   @Test
   public void testBitwiseAndExpression() throws TokenException
   {
      assertStatement( "1",
                       "5&6",
                       "<b-and line=\"1\"><primary line=\"1\">5"
                             + "</primary><op line=\"1\">&</op><primary line=\"1\">6</primary></b-and>" );
   }

   @Test
   public void testBitwiseOrExpression() throws TokenException
   {
      assertStatement( "1",
                       "5|6",
                       "<b-or line=\"1\"><primary line=\"1\">5"
                             + "</primary><op line=\"1\">|</op><primary line=\"1\">6</primary></b-or>" );
   }

   @Test
   public void testBitwiseXorExpression() throws TokenException
   {
      assertStatement( "1",
                       "5^6",
                       "<b-xor line=\"1\"><primary line=\"1\">5"
                             + "</primary><op line=\"1\">^</op><primary line=\"1\">6</primary></b-xor>" );
   }

   @Test
   public void testConditionalExpression() throws TokenException
   {
      assertStatement( "1",
                       "true?5:6",
                       "<conditional line=\"1\"><primary line=\"1\">"
                             + "true</primary><primary line=\"1\">5" + "</primary><primary line=\"1\">6"
                             + "</primary></conditional>" );
   }

   @Test
   public void testDivision() throws TokenException
   {
      assertStatement( "",
                       "offset = ( this[ axis.unscaled ] / 2 - ( rightPos ) / 2 );",
                       "<assign line=\"1\"><primary line=\"1\">offset</primary><op line=\"1\">=</op>"
                             + "<primary line=\"1\"><encapsulated line=\"1\"><add line=\"1\"><mul line=\"1\">"
                             + "<arr-acc line=\"1\"><primary line=\"1\">this</primary><dot line=\"1\"><primary "
                             + "line=\"1\">axis</primary><primary line=\"1\">unscaled</primary></dot></arr-acc>"
                             + "<op line=\"1\">/</op><primary line=\"1\">2</primary></mul><op line=\"1\">-</op>"
                             + "<mul line=\"1\"><primary line=\"1\"><encapsulated line=\"1\"><primary line=\"1\">"
                             + "rightPos</primary></encapsulated></primary><op line=\"1\">/</op><primary line=\"1\">"
                             + "2</primary></mul></add></encapsulated></primary></assign>" );
   }

   @Test
   public void testEncapsulated() throws TokenException
   {
      assertStatement( "",
                       "(dataProvider as ArrayCollection) = null",
                       "<assign line=\"1\"><primary line=\"1\">"
                             + "<encapsulated line=\"1\"><relation line=\"1\">"
                             + "<primary line=\"1\">dataProvider</primary>"
                             + "<as line=\"1\">as</as><primary line=\"1\">"
                             + "ArrayCollection</primary></relation></encapsulated></primary>"
                             + "<op line=\"1\">=</op><primary line=\"1\">" + "null</primary></assign>" );
   }

   @Test
   public void testEqualityExpression() throws TokenException
   {
      assertStatement( "1",
                       "5!==6",
                       "<equality line=\"1\"><primary line=\"1\">5"
                             + "</primary><op line=\"1\">!==</op><primary line=\"1\">6</primary></equality>" );
   }

   @Test
   public void testExpressionList() throws TokenException
   {
      assertStatement( "1",
                       "5&&6,5&&9",
                       "<expr-list line=\"1\"><and line=\"1\">"
                             + "<primary line=\"1\">5</primary><op line=\"1\">"
                             + "&&</op><primary line=\"1\">6</primary></and><and line=\"1\""
                             + "><primary line=\"1\">5</primary><op line=\"1\""
                             + ">&&</op><primary line=\"1\">9</primary></and></expr-list>" );
   }

   @Test
   public void testInstanceOf() throws TokenException
   {
      assertStatement( "bug237",
                       "if (a instanceof b){}",
                       "<if line=\"1\"><condition line=\"1\"><relation line=\"1\"><primary "
                             + "line=\"1\">a</primary><op line=\"1\">instanceof</op><primary line=\"1\">"
                             + "b</primary></relation></condition><block line=\"1\"></block></if>" );
   }

   @Test
   public void testMulExpression() throws TokenException
   {
      assertStatement( "1",
                       "5/6",
                       "<mul line=\"1\"><primary line=\"1\">5"
                             + "</primary><op line=\"1\">/</op><primary line=\"1\">6</primary></mul>" );
   }

   @Test
   public void testNewExpression() throws TokenException
   {
      assertStatement( "",
                       "new Event()",
                       "<new line=\"1\"><call line=\"1\">"
                             + "<primary line=\"1\">Event</primary>"
                             + "<arguments line=\"1\"></arguments></call></new>" );

      assertStatement( "",
                       "new Event(\"lala\")",
                       "<new line=\"1\"><call line=\"1\">"
                             + "<primary line=\"1\">Event</primary>"
                             + "<arguments line=\"1\"><primary line=\"1\">"
                             + "\"lala\"</primary></arguments></call></new>" );

   }

   @Test
   public void testOrExpression() throws TokenException
   {
      assertStatement( "1",
                       "5||6",
                       "<or line=\"1\"><primary line=\"1\">5"
                             + "</primary><op line=\"1\">||</op><primary line=\"1\">6</primary></or>" );
   }

   @Test
   public void testRelationalExpression() throws TokenException
   {
      assertStatement( "1",
                       "5<=6",
                       "<relation line=\"1\"><primary line=\"1\">5"
                             + "</primary><op line=\"1\">&lt;=</op><primary line=\"1\""
                             + ">6</primary></relation>" );
   }

   @Test
   public void testShiftExpression() throws TokenException
   {
      assertStatement( "1",
                       "5<<6",
                       "<shift line=\"1\"><primary line=\"1\">5"
                             + "</primary><op line=\"1\">&lt;&lt;</op><primary line=\"1\""
                             + ">6</primary></shift>" );
   }
}
