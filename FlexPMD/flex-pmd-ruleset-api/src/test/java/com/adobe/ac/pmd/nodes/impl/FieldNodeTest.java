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

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import junit.framework.Assert;
import net.sourceforge.pmd.PMDException;

import org.junit.Before;
import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.files.FileSetUtils;
import com.adobe.ac.pmd.nodes.IAttribute;
import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.Modifier;
import com.adobe.ac.pmd.parser.IParserNode;

public class FieldNodeTest extends FlexPmdTestBase
{
   private IAttribute first;
   private IAttribute second;
   private IAttribute third;
   private IAttribute withAsDoc;

   @Before
   public void setup() throws PMDException
   {
      final IParserNode nonBindableModelLocatorAst = FileSetUtils.buildAst( getTestFiles().get( "cairngorm.NonBindableModelLocator.as" ) );
      final IClass nonBindableModelLocator = NodeFactory.createPackage( nonBindableModelLocatorAst )
                                                        .getClassNode();
      first = nonBindableModelLocator.getAttributes().get( 0 );
      second = nonBindableModelLocator.getAttributes().get( 1 );
      third = nonBindableModelLocator.getAttributes().get( 2 );
      final IParserNode asDocsAst = FileSetUtils.buildAst( getTestFiles().get( "asDocs.EmptyWithDocClass.as" ) );
      final IClass asDocs = NodeFactory.createPackage( asDocsAst ).getClassNode();
      withAsDoc = asDocs.getAttributes().get( 0 );

   }

   @Test
   public void testBug167()
   {
      Assert.assertNotNull( withAsDoc.getAsDoc() );
      Assert.assertEquals( 1,
                           withAsDoc.getMetaDataCount() );
   }

   @Test
   public void testIsStatic()
   {
      assertTrue( first.isStatic() );
      assertFalse( second.isStatic() );
   }

   @Test
   public void testVisibility() throws PMDException
   {
      assertTrue( first.is( Modifier.PRIVATE ) );
      assertFalse( first.isPublic() );
      assertFalse( first.is( Modifier.PROTECTED ) );
      assertTrue( second.is( Modifier.PROTECTED ) );
      assertFalse( second.isPublic() );
      assertFalse( second.is( Modifier.PRIVATE ) );
      assertTrue( third.isPublic() );
      assertFalse( third.is( Modifier.PROTECTED ) );
      assertFalse( third.is( Modifier.PRIVATE ) );
   }
}
