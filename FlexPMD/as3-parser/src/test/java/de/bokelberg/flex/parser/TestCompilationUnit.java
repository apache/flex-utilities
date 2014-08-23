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

public class TestCompilationUnit extends AbstractAs3ParserTest
{
   @Test
   public void testEmptyPackage() throws TokenException
   {
      assertCompilationUnit( "1",
                             "package a { } ",
                             "<compilation-unit line=\"-1\">"
                                   + "<package line=\"1\">" + "<name line=\"1\">a"
                                   + "</name><content line=\"1\">"
                                   + "</content></package><content line=\"2\">"
                                   + "</content></compilation-unit>" );
   }

   @Test
   public void testEmptyPackagePlusLocalClass() throws TokenException
   {
      assertCompilationUnit( "1",
                             "package a { } class Local { }",
                             "<compilation-unit line=\"-1\"><package line=\"1\">"
                                   + "<name line=\"1\">a</name><content line=\"1\">"
                                   + "</content></package><content line=\"1\"><class line=\"1\""
                                   + "><name line=\"1\">Local</name>"
                                   + "<mod-list line=\"1\"></mod-list><content line=\"1\">"
                                   + "</content></class></content></compilation-unit>" );
   }

   @Test
   public void testPackageWithClass() throws TokenException
   {
      assertCompilationUnit( "1",
                             "package a { public class B { } } ",
                             "<compilation-unit line=\"-1\"><package line=\"1\">"
                                   + "<name line=\"1\">a</name><content line=\"1\">"
                                   + "<class line=\"1\"><name line=\"1\">B</name>"
                                   + "<mod-list line=\"1\"><mod line=\"1\">public"
                                   + "</mod></mod-list><content line=\"1\"></content>"
                                   + "</class></content></package><content line=\"2\">"
                                   + "</content></compilation-unit>" );
   }

   @Test
   public void testPackageWithInterface() throws TokenException
   {
      assertCompilationUnit( "1",
                             "package a { public interface B { } } ",
                             "<compilation-unit line=\"-1\"><package line=\"1\">"
                                   + "<name line=\"1\">a</name><content line=\"1\">"
                                   + "<interface line=\"1\"><name line=\"1\">B</name>"
                                   + "<mod-list line=\"1\"><mod line=\"1\">public</mod>"
                                   + "</mod-list><content line=\"1\"></content></interface>"
                                   + "</content></package><content line=\"2\"></content>"
                                   + "</compilation-unit>" );
   }

   private void assertCompilationUnit( final String message,
                                       final String input,
                                       final String expected ) throws TokenException
   {
      scn.setLines( new String[]
      { input,
                  "__END__" } );
      final String result = new ASTToXMLConverter().convert( asp.parseCompilationUnit() );
      assertEquals( message,
                    expected,
                    result );
   }
}
