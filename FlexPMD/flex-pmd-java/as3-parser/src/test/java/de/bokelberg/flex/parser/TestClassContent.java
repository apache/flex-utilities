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

public class TestClassContent extends AbstractAs3ParserTest
{
   @Test
   public void testCommentInMethod() throws TokenException
   {
      assertClassContent( "",
                          "public function log():void{/* comment */}",
                          "<function line=\"2\"><mod-list line=\"2\"><mod "
                                + "line=\"2\">public</mod></mod-list><name line=\"2\">log</name>"
                                + "<parameter-list line=\"2\"></parameter-list><type line=\"2\">"
                                + "void</type><block line=\"2\"><multi-line-comment line=\"2\">"
                                + "/* comment */</multi-line-comment></block></function>" );

      assertClassContent( "",
                          new String[]
                          { "{",
                                      "public function log():void{// comment ",
                                      "}",
                                      "}",
                                      "__END__" },
                          "<function line=\"2\"><mod-list line=\"2\"><mod line=\"2\""
                                + ">public</mod></mod-list><name line=\"2\">log</name>"
                                + "<parameter-list line=\"2\"></parameter-list><type line=\"2\""
                                + ">void</type><block line=\"2\"></block></function>" );
   }

   @Test
   public void testConstDeclarations() throws TokenException
   {
      assertClassContent( "1",
                          "const a",
                          "<const-list line=\"2\"><mod-list line=\"2\">"
                                + "</mod-list><name-type-init line=\"2\"><name line=\"2\">a"
                                + "</name><type line=\"3\"></type></name-type-init></const-list>" );

      assertClassContent( "2",
                          "public const a",
                          "<const-list line=\"2\"><mod-list line=\"2\">"
                                + "<mod line=\"2\">public</mod></mod-list><name-type-init line=\"2\""
                                + "><name line=\"2\">a</name><type line=\"3\">"
                                + "</type></name-type-init></const-list>" );

      assertClassContent( "3",
                          "public static const a : int = 0",
                          "<const-list line=\"2\"><mod-list line=\"2\">"
                                + "<mod line=\"2\">public</mod><mod line=\"2\">"
                                + "static</mod></mod-list><name-type-init line=\"2\"><name "
                                + "line=\"2\">a</name><type line=\"2\">int</type>"
                                + "<init line=\"2\"><primary line=\"2\">0</primary>"
                                + "</init></name-type-init></const-list>" );

      assertClassContent( "4",
                          "[Bindable] const a",
                          "<const-list line=\"2\"><meta-list line=\"2\">"
                                + "<meta line=\"2\">Bindable</meta></meta-list><mod-list line=\"2\""
                                + "></mod-list><name-type-init line=\"2\">"
                                + "<name line=\"2\">a</name><type line=\"3\">"
                                + "</type></name-type-init></const-list>" );
   }

   @Test
   public void testFlexPMD211() throws TokenException
   {
      assertClassContent( "",
                          "private function foo(sf:int):void{"
                                + "var a:Vector.<String> = new Vector.<String>()}",
                          "<function line=\"2\"><mod-list line=\"2\"><mod line=\"2\">private</mod>"
                                + "</mod-list><name line=\"2\">foo</name><parameter-list line=\"2\">"
                                + "<parameter line=\"2\"><name-type-init line=\"2\"><name line=\"2\">sf</name>"
                                + "<type line=\"2\">int</type></name-type-init></parameter></parameter-list>"
                                + "<type line=\"2\">void</type><block line=\"2\"><var-list line=\"2\">"
                                + "<name-type-init line=\"2\"><name line=\"2\">a</name><vector line=\"2\">"
                                + "<type line=\"2\">String</type></vector><init line=\"2\"><new line=\"2\">"
                                + "<primary line=\"2\">Vector</primary><vector line=\"2\"><vector line=\"2\">"
                                + "<type line=\"2\">String</type></vector></vector><arguments line=\"2\">"
                                + "</arguments></new></init></name-type-init></var-list></block></function>" );
      assertClassContent( "",
                          "private function foo(sf:int):void{"
                                + "var a:Vector.<String> = new Vector.<String>();}",
                          "<function line=\"2\"><mod-list line=\"2\"><mod line=\"2\">private</mod></mod-list>"
                                + "<name line=\"2\">foo</name><parameter-list line=\"2\"><parameter line=\"2\">"
                                + "<name-type-init line=\"2\"><name line=\"2\">sf</name><type line=\"2\">int</type>"
                                + "</name-type-init></parameter></parameter-list><type line=\"2\">void</type>"
                                + "<block line=\"2\"><var-list line=\"2\"><name-type-init line=\"2\">"
                                + "<name line=\"2\">a</name><vector line=\"2\"><type line=\"2\">String</type>"
                                + "</vector><init line=\"2\"><new line=\"2\"><primary line=\"2\">Vector</primary>"
                                + "<vector line=\"2\"><vector line=\"2\"><type line=\"2\">String</type></vector>"
                                + "</vector><arguments line=\"2\"></arguments></new></init></name-type-init>"
                                + "</var-list></block></function>" );
   }

   @Test
   public void testImports() throws TokenException
   {
      assertClassContent( "1",
                          "import a.b.c;",
                          "<import line=\"2\">a.b.c</import>" );
      assertClassContent( "2",
                          "import a.b.c import x.y.z",
                          "<import line=\"2\">a.b.c</import>"
                                + "<import line=\"2\">x.y.z</import>" );
   }

   @Test
   public void testMethods() throws TokenException
   {
      assertClassContent( "1",
                          "function a(){}",
                          "<function line=\"2\"><mod-list line=\"2\">"
                                + "</mod-list><name line=\"2\">a</name><parameter-list line=\"2\""
                                + "></parameter-list><type line=\"2\"></type><block "
                                + "line=\"2\"></block></function>" );

      assertClassContent( "2",
                          "function set a( value : int ) : void {}",
                          "<set line=\"2\"><mod-list line=\"2\">"
                                + "</mod-list><name line=\"2\">a</name>"
                                + "<parameter-list line=\"2\"><parameter line=\"2\">"
                                + "<name-type-init line=\"2\"><name line=\"2\">value"
                                + "</name><type line=\"2\">int</type></name-type-init></parameter>"
                                + "</parameter-list><type line=\"2\">void</type><block line=\"2\""
                                + "></block></set>" );

      assertClassContent( "3",
                          "function get a() : int {}",
                          "<get line=\"2\"><mod-list line=\"2\">"
                                + "</mod-list><name line=\"2\">a</name><parameter-list line=\"2\""
                                + "></parameter-list><type line=\"2\">int"
                                + "</type><block line=\"2\"></block></get>" );

      assertClassContent( "function with default parameter",
                          "public function newLine ( height:*='' ):void{}",
                          "<function line=\"2\"><mod-list line=\"2\"><mod line=\"2\""
                                + ">public</mod></mod-list><name line=\"2\">newLine"
                                + "</name><parameter-list line=\"2\"><parameter line=\"2\""
                                + "><name-type-init line=\"2\"><name line=\"2\""
                                + ">height</name><type line=\"2\">*</type>"
                                + "<init line=\"2\"><primary line=\"2\">''"
                                + "</primary></init></name-type-init></parameter></parameter-list>"
                                + "<type line=\"2\">void</type><block line=\"2\">" + "</block></function>" );
   }

   @Test
   public void testMethodsWithAsDoc() throws TokenException
   {
      scn.setLines( new String[]
      { "{",
                  "/** AsDoc */public function a(){}",
                  "}",
                  "__END__" } );
      asp.nextToken(); // first call
      asp.nextToken(); // skip {

      assertEquals( "<content line=\"2\"><function line=\"2\">"
                          + "<as-doc line=\"2\">/** AsDoc */</as-doc><mod-list "
                          + "line=\"2\"><mod line=\"2\">public</mod>"
                          + "</mod-list><name line=\"2\">a</name><parameter-list "
                          + "line=\"2\"></parameter-list><type line=\"2\">"
                          + "</type><block line=\"2\"></block></function></content>",
                    new ASTToXMLConverter().convert( asp.parseClassContent() ) );
   }

   @Test
   public void testMethodsWithMultiLineComments() throws TokenException
   {
      scn.setLines( new String[]
      { "{",
                  "/* Commented */public function a(){}",
                  "}",
                  "__END__" } );
      asp.nextToken(); // first call
      asp.nextToken(); // skip {

      assertEquals( "<content line=\"2\"><multi-line-comment line=\"2\">"
                          + "/* Commented */</multi-line-comment><function line=\"2\">"
                          + "<mod-list line=\"2\"><mod line=\"2\">public"
                          + "</mod></mod-list><name line=\"2\">a</name><parameter-list "
                          + "line=\"2\"></parameter-list><type line=\"2\">"
                          + "</type><block line=\"2\"></block></function></content>",
                    new ASTToXMLConverter().convert( asp.parseClassContent() ) );
   }

   @Test
   public void testMethodWithMetadataComment() throws TokenException
   {
      scn.setLines( new String[]
      { "{",
                  "/* Comment */ [Bindable] public function a () : void { }",
                  "}",
                  "__END__" } );
      asp.nextToken(); // first call
      asp.nextToken(); // skip {

      assertEquals( "1",
                    "<content line=\"2\"><multi-line-comment line=\"2\">"
                          + "/* Comment */</multi-line-comment><function line=\"2\">"
                          + "<meta-list line=\"2\"><meta line=\"2\">Bindable"
                          + "</meta></meta-list><mod-list line=\"2\"><mod line=\"2\""
                          + ">public</mod></mod-list><name line=\"2\">a</name>"
                          + "<parameter-list line=\"2\"></parameter-list><type line=\"2\""
                          + ">void</type><block line=\"2\"></block></function>" + "</content>",
                    new ASTToXMLConverter().convert( asp.parseClassContent() ) );
   }

   @Test
   public void testRestParameter() throws TokenException
   {
      assertClassContent( "",
                          "public function log(message:String, ... rest):void{}",
                          "<function line=\"2\"><mod-list line=\"2\">"
                                + "<mod line=\"2\">public</mod></mod-list><name line=\"2\">"
                                + "log</name><parameter-list line=\"2\">"
                                + "<parameter line=\"2\"><name-type-init line=\"2\">"
                                + "<name line=\"2\">message</name><type line=\"2\">String"
                                + "</type></name-type-init></parameter><parameter line=\"2\">"
                                + "<rest line=\"2\">rest</rest></parameter></parameter-list>"
                                + "<type line=\"2\">void</type><block line=\"2\">" + "</block></function>" );
   }

   @Test
   public void testVarDeclarations() throws TokenException
   {
      assertClassContent( "1",
                          "var a",
                          "<var-list line=\"2\"><mod-list line=\"2\">"
                                + "</mod-list><name-type-init line=\"2\"><name line=\"2\">a"
                                + "</name><type line=\"3\"></type></name-type-init></var-list>" );

      assertClassContent( "2",
                          "public var a;",
                          "<var-list line=\"2\"><mod-list line=\"2\">"
                                + "<mod line=\"2\">public</mod></mod-list><name-type-init line=\"2\""
                                + "><name line=\"2\">a</name><type line=\"2\""
                                + "></type></name-type-init></var-list>" );

      assertClassContent( "3",
                          "public static var a : int = 0",
                          "<var-list line=\"2\"><mod-list line=\"2\">"
                                + "<mod line=\"2\">public</mod><mod line=\"2\">"
                                + "static</mod></mod-list><name-type-init line=\"2\">"
                                + "<name line=\"2\">a</name><type line=\"2\">int</type>"
                                + "<init line=\"2\"><primary line=\"2\">0</primary>"
                                + "</init></name-type-init></var-list>" );

      assertClassContent( "4",
                          "[Bindable] var a",
                          "<var-list line=\"2\"><meta-list line=\"2\">"
                                + "<meta line=\"2\">Bindable</meta></meta-list>"
                                + "<mod-list line=\"2\"></mod-list>" + "<name-type-init line=\"2\">"
                                + "<name line=\"2\">a</name><type line=\"3\">"
                                + "</type></name-type-init></var-list>" );
   }

   private void assertClassContent( final String message,
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
      final String result = new ASTToXMLConverter().convert( asp.parseClassContent() );
      assertEquals( message,
                    "<content line=\"2\">"
                          + expected + "</content>",
                    result );
   }

   private void assertClassContent( final String message,
                                    final String[] input,
                                    final String expected ) throws TokenException
   {
      scn.setLines( input );
      asp.nextToken(); // first call
      asp.nextToken(); // skip {
      final String result = new ASTToXMLConverter().convert( asp.parseClassContent() );
      assertEquals( message,
                    "<content line=\"2\">"
                          + expected + "</content>",
                    result );
   }
}
