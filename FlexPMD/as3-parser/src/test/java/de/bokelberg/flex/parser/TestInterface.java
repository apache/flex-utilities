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

public class TestInterface extends AbstractAs3ParserTest
{
   @Test
   public void testExtends() throws TokenException
   {
      assertPackageContent( "1",
                            "public interface A extends B { } ",
                            "<content line=\"2\"><interface line=\"2\">"
                                  + "<name line=\"2\">A</name><mod-list line=\"2\">"
                                  + "<mod line=\"2\">public</mod>"
                                  + "</mod-list><extends line=\"2\">B</extends>"
                                  + "<content line=\"2\"></content></interface></content>" );

      assertPackageContent( "",
                            "   public interface ITimelineEntryRenderer extends IFlexDisplayObject, IDataRenderer{}",
                            "<content line=\"2\"><interface line=\"2\"><name line=\"2\""
                                  + ">ITimelineEntryRenderer</name><mod-list line=\"2\">"
                                  + "<mod line=\"2\">public</mod></mod-list><extends line=\"2\""
                                  + ">IFlexDisplayObject</extends><extends line=\"2\">"
                                  + "IDataRenderer</extends><content line=\"2\">"
                                  + "</content></interface></content>" );
   }

   @Test
   public void testInclude() throws TokenException
   {
      assertPackageContent( "1",
                            "public interface A extends B { include \"ITextFieldInterface.asz\" } ",
                            "<content line=\"2\"><interface line=\"2\">"
                                  + "<name line=\"2\">A</name><mod-list line=\"2\">"
                                  + "<mod line=\"2\">public</mod></mod-list>" + "<extends line=\"2\">"
                                  + "B</extends><content line=\"2\"><include line=\"2\">"
                                  + "<primary line=\"2\">\"ITextFieldInterface.asz\"</primary>"
                                  + "</include></content></interface></content>" );
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
