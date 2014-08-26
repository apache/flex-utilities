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
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.IOException;

import junit.framework.Assert;
import net.sourceforge.pmd.PMDException;

import org.junit.Before;
import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.files.FileSetUtils;
import com.adobe.ac.pmd.files.IFlexFile;
import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.MetaData;
import com.adobe.ac.pmd.nodes.Modifier;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.parser.exceptions.TokenException;

public class ClassNodeTest extends FlexPmdTestBase
{
   private IClass bug233;
   private IClass modelLocator;
   private IClass nonBindableModelLocator;
   private IClass radonDataGrid;

   @Before
   public void setup() throws IOException,
                      TokenException,
                      PMDException
   {
      IParserNode ast = FileSetUtils.buildAst( getTestFiles().get( "RadonDataGrid.as" ) );
      radonDataGrid = NodeFactory.createPackage( ast ).getClassNode();
      final IFlexFile file = getTestFiles().get( "bug.FlexPMD233a.mxml" );
      ast = FileSetUtils.buildAst( file );
      bug233 = NodeFactory.createPackage( ast ).getClassNode();
      ast = FileSetUtils.buildAst( getTestFiles().get( "cairngorm.BindableModelLocator.as" ) );
      modelLocator = NodeFactory.createPackage( ast ).getClassNode();
      ast = FileSetUtils.buildAst( getTestFiles().get( "cairngorm.NonBindableModelLocator.as" ) );
      nonBindableModelLocator = NodeFactory.createPackage( ast ).getClassNode();
   }

   @Test
   public void testBlock()
   {
      Assert.assertNull( radonDataGrid.getBlock() );
   }

   @Test
   public void testFlexPMD233()
   {
      Assert.assertNull( bug233.getBlock() );
   }

   @Test
   public void testGetAllMetaData()
   {
      assertEquals( 0,
                    radonDataGrid.getAllMetaData().size() );
   }

   @Test
   public void testGetAttributes()
   {
      assertEquals( 0,
                    radonDataGrid.getAttributes().size() );
   }

   @Test
   public void testGetAverageCyclomaticComplexity()
   {
      assertEquals( 3.0,
                    radonDataGrid.getAverageCyclomaticComplexity(),
                    0.1 );
   }

   @Test
   public void testGetConstants()
   {
      assertEquals( 0,
                    radonDataGrid.getConstants().size() );
   }

   @Test
   public void testGetConstructor()
   {
      assertNotNull( radonDataGrid.getConstructor() );
   }

   @Test
   public void testGetExtensionName()
   {
      assertEquals( "DataGrid",
                    radonDataGrid.getExtensionName() );
   }

   @Test
   public void testGetImplementations()
   {
      assertEquals( 0,
                    radonDataGrid.getImplementations().size() );
      assertEquals( 1,
                    modelLocator.getImplementations().size() );
   }

   @Test
   public void testGetMetaData()
   {
      assertEquals( 0,
                    nonBindableModelLocator.getMetaData( MetaData.BINDABLE ).size() );
      assertEquals( 1,
                    modelLocator.getMetaData( MetaData.BINDABLE ).size() );
   }

   @Test
   public void testGetMetaDataList()
   {
      assertEquals( 0,
                    radonDataGrid.getMetaDataCount() );
      assertNotNull( modelLocator.getMetaData( MetaData.BINDABLE ) );
      assertEquals( 1,
                    modelLocator.getMetaData( MetaData.BINDABLE ).size() );
      assertTrue( modelLocator.isBindable() );
      assertFalse( nonBindableModelLocator.isBindable() );
   }

   @Test
   public void testGetName()
   {
      assertEquals( "RadonDataGrid",
                    radonDataGrid.getName() );
   }

   @Test
   public void testIsFinal()
   {
      assertFalse( radonDataGrid.isFinal() );
   }

   @Test
   public void testVisibility()
   {
      assertTrue( radonDataGrid.isPublic() );
      assertTrue( modelLocator.is( Modifier.PROTECTED ) );
      assertTrue( nonBindableModelLocator.is( Modifier.PRIVATE ) );
      assertFalse( nonBindableModelLocator.is( Modifier.PROTECTED ) );
      assertFalse( nonBindableModelLocator.isPublic() );
      assertFalse( radonDataGrid.is( Modifier.PROTECTED ) );
      assertFalse( radonDataGrid.is( Modifier.PRIVATE ) );
      assertFalse( modelLocator.isPublic() );
      assertFalse( modelLocator.is( Modifier.PRIVATE ) );
   }
}
