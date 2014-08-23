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

public class TestPrimaryExpression extends AbstractAs3ParserTest
{
   @Test
   public void testArrayLiteral() throws TokenException
   {
      assertPrimary( "[1,2,3]",
                     "<array line=\"1\"><primary line=\"1\">1"
                           + "</primary><primary line=\"1\">2</primary>"
                           + "<primary line=\"1\">3</primary></array>" );
   }

   @Test
   public void testBooleans() throws TokenException
   {
      assertPrimary( "true" );
      assertPrimary( "false" );
   }

   @Test
   public void testFunctionLiteral() throws TokenException
   {
      assertPrimary( "function ( a : Object ) : * { trace('test'); }",
                     "<lambda line=\"1\"><parameter-list line=\"1\">"
                           + "<parameter line=\"1\"><name-type-init line=\"1\">"
                           + "<name line=\"1\">a</name><type line=\"1\">"
                           + "Object</type></name-type-init></parameter></parameter-list>"
                           + "<type line=\"1\">*</type><block line=\"1\">"
                           + "<call line=\"1\"><primary line=\"1\">trace</primary>"
                           + "<arguments line=\"1\"><primary line=\"1\">'test'"
                           + "</primary></arguments></call></block></lambda>" );
   }

   @Test
   public void testNull() throws TokenException
   {
      assertPrimary( "null" );
   }

   @Test
   public void testNumbers() throws TokenException
   {
      assertPrimary( "1" );
      assertPrimary( "0xff" );
      assertPrimary( "0777" );
      assertPrimary( ".12E5" );
   }

   @Test
   public void testObjectLiteral() throws TokenException
   {
      assertPrimary( "{a:1,b:2}",
                     "<object line=\"1\"><prop line=\"1\">"
                           + "<name line=\"1\">a</name><value line=\"1\">"
                           + "<primary line=\"1\">1</primary></value></prop><prop line=\"1\">"
                           + "<name line=\"1\">b</name><value line=\"1\">"
                           + "<primary line=\"1\">2</primary></value></prop></object>" );
   }

   @Test
   public void testStrings() throws TokenException
   {
      assertPrimary( "\"string\"" );
      assertPrimary( "'string'" );
   }

   @Test
   public void testUndefined() throws TokenException
   {
      assertPrimary( "undefined" );
   }

   private void assertPrimary( final String input ) throws TokenException
   {
      assertPrimary( input,
                     input );
   }

   private void assertPrimary( final String input,
                               final String expected ) throws TokenException
   {
      scn.setLines( new String[]
      { input,
                  "__END__" } );
      asp.nextToken();
      final String result = new ASTToXMLConverter().convert( asp.parsePrimaryExpression() );
      assertEquals( "unexpected",
                    "<primary line=\"1\">"
                          + expected + "</primary>",
                    result );
   }

}
