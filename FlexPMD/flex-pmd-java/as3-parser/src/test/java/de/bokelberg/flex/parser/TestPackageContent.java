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

public class TestPackageContent extends AbstractAs3ParserTest
{
   @Test
   public void testClass() throws TokenException
   {
      assertPackageContent( "1",
                            "public class A { }",
                            "<content line=\"2\"><class line=\"2\">"
                                  + "<name line=\"2\">A</name><mod-list line=\"2\">"
                                  + "<mod line=\"2\">public</mod>" + "</mod-list><content line=\"2\">"
                                  + "</content></class></content>" );
   }

   @Test
   public void testClassWithAsDoc() throws TokenException
   {
      assertPackageContent( "1",
                            "/** AsDoc */ public class A { }",
                            "<content line=\"2\"><class line=\"2\">"
                                  + "<as-doc line=\"2\">/** AsDoc */</as-doc><name line=\"2\""
                                  + ">A</name><mod-list line=\"2\"><mod line=\"2\""
                                  + ">public</mod></mod-list><content line=\"2\">"
                                  + "</content></class></content>" );
   }

   @Test
   public void testClassWithAsDocComplex() throws TokenException
   {
      assertPackageContent( "1",
                            "/** AsDoc */ public class A { "
                                  + "/** Member */ " + "public var tmp : Number; "
                                  + "private var tmp2 : int; " + "/** Function */ "
                                  + "protected function foo() : void { } }",
                            "<content line=\"2\"><class line=\"2\"><as-doc line=\"2\""
                                  + ">/** AsDoc */</as-doc><name line=\"2\">A</name>"
                                  + "<mod-list line=\"2\"><mod line=\"2\">public</mod>"
                                  + "</mod-list><content line=\"2\"><var-list line=\"2\">"
                                  + "<mod-list line=\"2\"><mod line=\"2\">public</mod>"
                                  + "</mod-list><name-type-init line=\"2\"><name line=\"2\">tmp</name>"
                                  + "<type line=\"2\">Number</type></name-type-init><as-doc line=\"2\""
                                  + ">/** Member */</as-doc></var-list><var-list line=\"2\">"
                                  + "<mod-list line=\"2\"><mod line=\"2\">private</mod></mod-list>"
                                  + "<name-type-init line=\"2\"><name line=\"2\">tmp2</name>"
                                  + "<type line=\"2\">int</type></name-type-init></var-list><function "
                                  + "line=\"2\"><as-doc line=\"2\">/** Function */</as-doc>"
                                  + "<mod-list line=\"2\"><mod line=\"2\">protected</mod></mod-list>"
                                  + "<name line=\"2\">foo</name><parameter-list line=\"2\">"
                                  + "</parameter-list><type line=\"2\">void</type><block line=\"2\""
                                  + "></block></function></content></class></content>" );
   }

   @Test
   public void testClassWithComment() throws TokenException
   {
      assertPackageContent( "1",
                            "/* lala */ /** asDoc */ public class A { }",
                            "<content line=\"2\"><class line=\"2\">"
                                  + "<as-doc line=\"2\">/** asDoc */</as-doc><multi-line-comment "
                                  + "line=\"2\">/* lala */</multi-line-comment><name line=\"2\""
                                  + ">A</name><mod-list line=\"2\"><mod line=\"2\""
                                  + ">public</mod></mod-list><content line=\"2\">"
                                  + "</content></class></content>" );
   }

   @Test
   public void testClassWithMetadata() throws TokenException
   {
      assertPackageContent( "1",
                            "[Bindable(name=\"abc\", value=\"123\")] public class A { }",
                            "<content line=\"2\"><class line=\"2\">"
                                  + "<name line=\"2\">A</name><meta-list line=\"2\">" + "<meta line=\"2\""
                                  + ">Bindable ( name = \"abc\" , value = \"123\" )</meta>"
                                  + "</meta-list><mod-list line=\"2\">" + "<mod line=\"2\">public"
                                  + "</mod></mod-list><content line=\"2\"></content></class></content>" );
   }

   @Test
   public void testClassWithMetadataAsDoc() throws TokenException
   {
      assertPackageContent( "1",
                            "/** Comment */ [Bindable] public class A { }",
                            "<content line=\"2\"><class line=\"2\"><as-doc line=\"2\">"
                                  + "/** Comment */</as-doc><name line=\"2\">A</name><meta-list "
                                  + "line=\"2\"><meta line=\"2\">Bindable</meta></meta-list><mod-list "
                                  + "line=\"2\"><mod line=\"2\">public</mod></mod-list><content "
                                  + "line=\"2\"></content></class></content>" );
   }

   @Test
   public void testClassWithMetadataComment() throws TokenException
   {
      assertPackageContent( "1",
                            "/* Comment */ [Bindable] public class A { }",
                            "<content line=\"2\"><class line=\"2\">"
                                  + "<multi-line-comment line=\"2\">/* Comment */"
                                  + "</multi-line-comment><name line=\"2\">A</name>"
                                  + "<meta-list line=\"2\"><meta line=\"2\">"
                                  + "Bindable</meta></meta-list><mod-list line=\"2\"><mod "
                                  + "line=\"2\">public</mod></mod-list><content line=\"2\""
                                  + "></content></class></content>" );
   }

   @Test
   public void testClassWithMetadataWithComment() throws TokenException
   {
      assertPackageContent( "1",
                            "/* lala */ /** asDoc */ [Bindable] public class A { }",
                            "<content line=\"2\"><class line=\"2\"><as-doc line=\"2\">"
                                  + "/** asDoc */</as-doc><multi-line-comment line=\"2\">"
                                  + "/* lala */</multi-line-comment><name line=\"2\">A</name>"
                                  + "<meta-list line=\"2\"><meta line=\"2\">Bindable</meta>"
                                  + "</meta-list><mod-list line=\"2\"><mod line=\"2\">public"
                                  + "</mod></mod-list><content line=\"2\"></content></class></content>" );
   }

   @Test
   public void testClassWithSimpleMetadata() throws TokenException
   {
      assertPackageContent( "1",
                            "[Bindable] public class A { }",
                            "<content line=\"2\"><class line=\"2\"><name line=\"2\""
                                  + ">A</name><meta-list line=\"2\"><meta line=\"2\""
                                  + ">Bindable</meta></meta-list><mod-list line=\"2\">"
                                  + "<mod line=\"2\">public</mod></mod-list><content line=\"2\""
                                  + "></content></class></content>" );
   }

   @Test
   public void testImports() throws TokenException
   {
      assertPackageContent( "1",
                            "import a.b.c;",
                            "<content line=\"2\"><import line=\"2\""
                                  + ">a.b.c</import></content>" );

      assertPackageContent( "2",
                            "import a.b.c import x.y.z",
                            "<content line=\"2\"><import line=\"2\">a.b.c"
                                  + "</import><import line=\"2\">x.y.z</import></content>" );
   }

   @Test
   public void testInterface() throws TokenException
   {
      assertPackageContent( "1",
                            "public interface A { }",
                            "<content line=\"2\"><interface line=\"2\">"
                                  + "<name line=\"2\">A</name><mod-list line=\"2\">"
                                  + "<mod line=\"2\">public</mod>" + "</mod-list><content line=\"2\">"
                                  + "</content></interface></content>" );
   }

   @Test
   public void testMethodPackages() throws TokenException
   {
      assertPackageContent( "1",
                            "public function a() : void { }",
                            "<content line=\"2\"><function line=\"2\">"
                                  + "<mod-list line=\"2\"><mod line=\"2\">public</mod>"
                                  + "</mod-list><name line=\"2\">a</name><parameter-list line=\"2\""
                                  + "></parameter-list><type line=\"2\">void</type>"
                                  + "<block line=\"2\"></block></function></content>" );
   }

   @Test
   public void testUse() throws TokenException
   {
      assertPackageContent( "1",
                            "use namespace myNamespace",
                            "<content line=\"2\"><use line=\"2\""
                                  + ">myNamespace</use></content>" );
   }

   @Test
   public void testUseNameSpace() throws TokenException
   {
      assertPackageContent( "FlexPMD-108",
                            "use namespace mx_internal;",
                            "<content line=\"2\"><use line=\"2\">mx_internal</use></content>" );
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
