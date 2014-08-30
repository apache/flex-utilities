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
package com.adobe.ac.pmd.nodes.impl;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import net.sourceforge.pmd.PMDException;

import org.junit.Ignore;
import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.files.FileSetUtils;
import com.adobe.ac.pmd.nodes.IPackage;
import com.adobe.ac.pmd.parser.IParserNode;

@Ignore("This test requires test-data that was not donated to Apache")
public class CommentNodeTest extends FlexPmdTestBase
{
   private final IPackage flexPMD60Package;

   public CommentNodeTest() throws PMDException
   {
      final IParserNode bug60Ast = FileSetUtils.buildAst( getTestFiles().get( "bug."
            + "FlexPMD60.as" ) );
      flexPMD60Package = NodeFactory.createPackage( bug60Ast );
   }

   @Test
   public void testClassComment()
   {
      assertNotNull( flexPMD60Package.getClassNode().getAsDoc().getStringValue() );

      assertEquals( "/** * AsDoc class */",
                    flexPMD60Package.getClassNode()
                                    .getAsDoc()
                                    .getStringValue()
                                    .replace( "\t",
                                              "   " )
                                    .replace( '\n',
                                              ' ' )
                                    .replaceAll( "  ",
                                                 " " ) );

      assertEquals( 2,
                    flexPMD60Package.getClassNode().getMultiLinesComment().size() );

      assertNotNull( flexPMD60Package.getClassNode().getMultiLinesComment().get( 0 ) );

      assertEquals( "/* * comment */",
                    flexPMD60Package.getClassNode()
                                    .getMultiLinesComment()
                                    .get( 0 )
                                    .getStringValue()
                                    .replace( "\t",
                                              "   " )
                                    .replace( '\n',
                                              ' ' )
                                    .replaceAll( "  ",
                                                 " " ) );
   }

   @Test
   public void testFieldComment()
   {
      assertNotNull( flexPMD60Package.getClassNode().getAttributes().get( 0 ).getAsDoc() );

      assertEquals( "/**   * AsDoc attribute   */",
                    flexPMD60Package.getClassNode()
                                    .getAttributes()
                                    .get( 0 )
                                    .getAsDoc()
                                    .getStringValue()
                                    .replace( "\t",
                                              "   " )
                                    .replace( '\n',
                                              ' ' )
                                    .replaceAll( "  ",
                                                 " " ) );

   }

   @Test
   public void testFunctionComment()
   {
      assertNotNull( flexPMD60Package.getClassNode().getFunctions().get( 0 ).getAsDoc() );

      assertEquals( "/**   * AsDoc method   */",
                    flexPMD60Package.getClassNode()
                                    .getFunctions()
                                    .get( 0 )
                                    .getAsDoc()
                                    .getStringValue()
                                    .replace( "\t","   " )
                                    .replace( '\n', ' ' )
                                    .replaceAll( "  ", " " ) );

      assertEquals( 2,
                    flexPMD60Package.getClassNode().getMultiLinesComment().size() );

      assertEquals( "/* * comment */",
                    flexPMD60Package.getClassNode()
                                    .getMultiLinesComment()
                                    .get( 0 )
                                    .getStringValue()
                                    .replace( "\t",
                                              "   " )
                                    .replace( '\n',
                                              ' ' )
                                    .replaceAll( "  ",
                                                 " " ) );

      assertEquals( 1,
                    flexPMD60Package.getClassNode().getFunctions().get( 0 ).getMultiLinesComment().size() );

      assertEquals( "/*     var i : int = 0;*/",
                    flexPMD60Package.getClassNode()
                                    .getFunctions()
                                    .get( 0 )
                                    .getMultiLinesComment()
                                    .get( 0 )
                                    .getStringValue()
                                    .replace( "\t",
                                              "   " )
                                    .replace( '\n',
                                              ' ' )
                                    .replaceAll( "  ",
                                                 " " ) );
   }

   @Test
   public void testMetadataComment()
   {
      assertNotNull( flexPMD60Package.getClassNode().getAsDoc() );

      assertEquals( "/** * AsDoc class */",
                    flexPMD60Package.getClassNode()
                                    .getAsDoc()
                                    .getStringValue()
                                    .replace( "\t",
                                              "   " )
                                    .replace( '\n',
                                              ' ' )
                                    .replaceAll( "  ",
                                                 " " ) );

   }
}
