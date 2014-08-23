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

public class TestInterfaceContent extends AbstractAs3ParserTest
{
   @Test(timeout = 2)
   public void testConditionalCompilation() throws TokenException
   {
      assertInterfaceContent( "with conditional compilation",

                              "CONFIG::DEBUG { function output():String; } ",
                              "<function line=\"2\"><name line=\"2\">"
                                    + "output</name><parameter-list line=\"2\"></parameter-list>"
                                    + "<type line=\"2\">String</type></function>" );

   }

   @Test
   public void testImports() throws TokenException
   {
      assertInterfaceContent( "1",
                              "import a.b.c;",
                              "<import line=\"2\">a.b.c</import>" );

      assertInterfaceContent( "2",
                              "import a.b.c import x.y.z",
                              "<import line=\"2\">a.b.c</import>"
                                    + "<import line=\"2\">x.y.z</import>" );
   }

   @Test
   public void testMethods() throws TokenException
   {
      assertInterfaceContent( "1",
                              "function a()",
                              "<function line=\"3\">"
                                    + "<name line=\"2\">a</name>"
                                    + "<parameter-list line=\"2\">"
                                    + "</parameter-list><type line=\"3\">"
                                    + "</type></function>" );

      assertInterfaceContent( "2",
                              "function set a( value : int ) : void",
                              "<set line=\"3\"><name line=\"2\">a"
                                    + "</name><parameter-list line=\"2\">"
                                    + "<parameter line=\"2\">"
                                    + "<name-type-init line=\"2\">"
                                    + "<name line=\"2\">value</name>"
                                    + "<type line=\"2\">int</type>"
                                    + "</name-type-init></parameter></parameter-list>"
                                    + "<type line=\"2\">void</type></set>" );

      assertInterfaceContent( "3",
                              "function get a() : int",
                              "<get line=\"3\"><name line=\"2\">a"
                                    + "</name><parameter-list line=\"2\">"
                                    + "</parameter-list><type line=\"2\">int" + "</type></get>" );
   }

   private void assertInterfaceContent( final String message,
                                        final String input,
                                        final String expected ) throws TokenException
   {
      scn.setLines( new String[]
      { "{",
                  input,
                  "}",
                  "__END__" } );
      asp.nextToken(); // first call
      asp.nextToken(); // skip {
      final String result = new ASTToXMLConverter().convert( asp.parseInterfaceContent() );
      assertEquals( message,
                    "<content line=\"2\">"
                          + expected + "</content>",
                    result );
   }
}
