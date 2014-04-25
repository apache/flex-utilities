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

public class TestClass extends AbstractAs3ParserTest
{
   @Test
   public void testExtends() throws TokenException
   {
      assertPackageContent( "1",
                            "public class A extends B { } ",
                            "<content line=\"2\">"
                                  + "<class line=\"2\">" + "<name line=\"2\">A</name><mod-list line=\"2\">"
                                  + "<mod line=\"2\">public</mod></mod-list><extends line=\"2\""
                                  + ">B</extends><content line=\"2\"></content>" + "</class></content>" );

      assertPackageContent( "1",
                            "public class A extends com.adobe::B { } ",
                            "<content line=\"2\"><class line=\"2\"><name line=\"2\""
                                  + ">A</name><mod-list line=\"2\"><mod line=\"2\""
                                  + ">public</mod></mod-list><extends line=\"2\""
                                  + ">com.adobe::B</extends><content line=\"2\"></content>"
                                  + "</class></content>" );
   }

   @Test
   public void testFinalClass() throws TokenException
   {
      assertPackageContent( "",
                            "public final class Title{ }",
                            "<content line=\"2\">"
                                  + "<class line=\"2\">" + "<name line=\"2\">Title</name>"
                                  + "<mod-list line=\"2\">" + "<mod line=\"2\">public</mod>"
                                  + "<mod line=\"2\">final</mod></mod-list>" + "<content line=\"2\""
                                  + "></content>" + "</class>" + "</content>" );
   }

   @Test
   public void testFullFeatured() throws TokenException
   {
      // assertPackageContent( "",
      // "public class A { public static const RULE_REMOVED : String = \"ruleRemoved\";}",
      // "" );

      assertPackageContent( "1",
                            "public class A extends B implements C,D { } ",
                            "<content line=\"2\"><class line=\"2\">"
                                  + "<name line=\"2\">A</name><mod-list line=\"2\">"
                                  + "<mod line=\"2\">public</mod></mod-list><extends line=\"2\""
                                  + ">B</extends><implements-list line=\"2\">"
                                  + "<implements line=\"2\">C</implements><implements line=\"2\""
                                  + ">D</implements></implements-list><content line=\"2\">"
                                  + "</content></class></content>" );
   }

   @Test
   public void testImplementsList() throws TokenException
   {
      assertPackageContent( "1",
                            "public class A implements B,C { } ",
                            "<content line=\"2\"><class line=\"2\">"
                                  + "<name line=\"2\">A</name><mod-list line=\"2\""
                                  + "><mod line=\"2\">public</mod></mod-list>"
                                  + "<implements-list line=\"2\"><implements line=\"2\""
                                  + ">B</implements><implements line=\"2\">"
                                  + "C</implements></implements-list><content line=\"2\">"
                                  + "</content></class></content>" );
   }

   @Test
   public void testImplementsSingle() throws TokenException
   {
      assertPackageContent( "1",
                            "public class A implements B { } ",
                            "<content line=\"2\"><class line=\"2\">"
                                  + "<name line=\"2\">A</name><mod-list line=\"2\""
                                  + "><mod line=\"2\">public</mod></mod-list>"
                                  + "<implements-list line=\"2\"><implements line=\"2\""
                                  + ">B</implements></implements-list><content line=\"2\""
                                  + "></content></class></content>" );
   }

   @Test
   public void testImportInsideClass() throws TokenException
   {
      assertPackageContent( "",
                            "public final class Title{ import lala.lala; }",
                            "<content line=\"2\">"
                                  + "<class line=\"2\"><name line=\"2\">Title</name>"
                                  + "<mod-list line=\"2\"><mod line=\"2\">public</mod>"
                                  + "<mod line=\"2\">final</mod></mod-list>"
                                  + "<content line=\"2\"><import line=\"2\""
                                  + ">lala.lala</import></content></class></content>" );

   }

   @Test
   public void testInclude() throws TokenException
   {
      assertPackageContent( "1",
                            "public class A extends B { include \"ITextFieldInterface.asz\" } ",
                            "<content line=\"2\"><class line=\"2\">"
                                  + "<name line=\"2\">A</name><mod-list line=\"2\">"
                                  + "<mod line=\"2\">public</mod></mod-list>"
                                  + "<extends line=\"2\">B</extends>"
                                  + "<content line=\"2\"></content></class></content>" );
   }

   private void assertPackageContent( final String message,
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
      final String result = new ASTToXMLConverter().convert( asp.parsePackageContent() );
      assertEquals( message,
                    expected,
                    result );
   }

}
