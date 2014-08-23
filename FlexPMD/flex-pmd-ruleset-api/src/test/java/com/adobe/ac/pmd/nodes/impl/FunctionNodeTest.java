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
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import java.io.IOException;

import net.sourceforge.pmd.PMDException;

import org.junit.Before;
import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.files.FileSetUtils;
import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.nodes.MetaData;
import com.adobe.ac.pmd.nodes.Modifier;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.parser.exceptions.TokenException;

public class FunctionNodeTest extends FlexPmdTestBase
{
   private IFunction bug88Constructor;
   private IFunction constructor;
   private IFunction drawHighlightIndicator;
   private IFunction drawRowBackground;
   private IFunction drawSelectionIndicator;
   private IFunction fDCTQuant;
   private IFunction flexunit4Test;
   private IFunction flexunit4TestSetUp;
   private IFunction getHeight;
   private IFunction isTrueGetter;
   private IFunction isTrueSetter;
   private IFunction placeSortArrow;

   @Test
   public void modifiers()
   {
      assertTrue( constructor.is( Modifier.PUBLIC ) );
   }

   @Before
   public void setup() throws IOException,
                      TokenException,
                      PMDException
   {
      final IParserNode dataGridAst = FileSetUtils.buildAst( getTestFiles().get( "RadonDataGrid.as" ) );
      final IParserNode modelLocatorAst = FileSetUtils.buildAst( getTestFiles().get( "cairngorm."
            + "NonBindableModelLocator.as" ) );
      final IParserNode flexUnit4TestCaseAst = FileSetUtils.buildAst( getTestFiles().get( "flexunit."
            + "RaoulTest.as" ) );
      final IParserNode bug888Ast = FileSetUtils.buildAst( getTestFiles().get( "bug."
            + "FlexPMD88.as" ) );
      final IParserNode pngEncoderAst = FileSetUtils.buildAst( getTestFiles().get( "PngEncoder.as" ) );

      final IClass radonDataGrid = NodeFactory.createPackage( dataGridAst ).getClassNode();
      final IClass nonBindableModelLocator = NodeFactory.createPackage( modelLocatorAst ).getClassNode();
      final IClass flexUnit4TestCase = NodeFactory.createPackage( flexUnit4TestCaseAst ).getClassNode();
      final IClass bug88 = NodeFactory.createPackage( bug888Ast ).getClassNode();
      final IClass pngEncoder = NodeFactory.createPackage( pngEncoderAst ).getClassNode();

      constructor = radonDataGrid.getFunctions().get( 0 );
      drawHighlightIndicator = radonDataGrid.getFunctions().get( 1 );
      drawSelectionIndicator = radonDataGrid.getFunctions().get( 2 );
      drawRowBackground = radonDataGrid.getFunctions().get( 3 );
      placeSortArrow = radonDataGrid.getFunctions().get( 4 );
      isTrueGetter = radonDataGrid.getFunctions().get( 5 );
      isTrueSetter = radonDataGrid.getFunctions().get( 6 );
      getHeight = nonBindableModelLocator.getFunctions().get( 2 );
      flexunit4Test = flexUnit4TestCase.getFunctions().get( 1 );
      flexunit4TestSetUp = flexUnit4TestCase.getFunctions().get( 0 );
      bug88Constructor = bug88.getConstructor();
      fDCTQuant = pngEncoder.getFunctions().get( 9 );
   }

   @Test
   public void testFindPrimaryStatementFromName()
   {
      assertEquals( 0,
                    constructor.findPrimaryStatementsInBody( "" ).size() );
      assertEquals( 1,
                    drawHighlightIndicator.findPrimaryStatementInBody( new String[]
                    { "super",
                                "" } ).size() );
   }

   @Test
   public void testGetAllMetaData()
   {
      assertEquals( 0,
                    constructor.getAllMetaData().size() );
   }

   @Test
   public void testGetBody()
   {
      assertEquals( 1,
                    flexunit4TestSetUp.getBody().numChildren() );

      assertEquals( 38,
                    fDCTQuant.getBody().numChildren() );
   }

   @Test
   public void testGetCyclomaticComplexity()
   {
      assertEquals( 2,
                    constructor.getCyclomaticComplexity() );
      assertEquals( 1,
                    drawHighlightIndicator.getCyclomaticComplexity() );
      assertEquals( 1,
                    drawSelectionIndicator.getCyclomaticComplexity() );
      assertEquals( 4,
                    drawRowBackground.getCyclomaticComplexity() );
      assertEquals( 13,
                    placeSortArrow.getCyclomaticComplexity() );

      assertEquals( 3,
                    bug88Constructor.getCyclomaticComplexity() );
   }

   @Test
   public void testGetMetaData()
   {
      assertEquals( 1,
                    getHeight.getMetaDataCount() );
      assertEquals( 0,
                    isTrueGetter.getMetaDataCount() );
      assertEquals( 1,
                    flexunit4Test.getMetaData( MetaData.TEST ).size() );
      assertEquals( "Test",
                    flexunit4Test.getMetaData( MetaData.TEST ).get( 0 ).getName() );
      assertEquals( 0,
                    flexunit4Test.getMetaData( MetaData.BEFORE ).size() );
   }

   @Test
   public void testGetName()
   {
      assertEquals( "RadonDataGrid",
                    constructor.getName() );
      assertEquals( "drawHighlightIndicator",
                    drawHighlightIndicator.getName() );
      assertEquals( "drawSelectionIndicator",
                    drawSelectionIndicator.getName() );
      assertEquals( "drawRowBackground",
                    drawRowBackground.getName() );
      assertEquals( "placeSortArrow",
                    placeSortArrow.getName() );
   }

   @Test
   public void testGetParameters()
   {
      assertEquals( 0,
                    constructor.getParameters().size() );
      assertEquals( 7,
                    drawHighlightIndicator.getParameters().size() );
      assertEquals( 7,
                    drawSelectionIndicator.getParameters().size() );
      assertEquals( 6,
                    drawRowBackground.getParameters().size() );
      assertEquals( 0,
                    placeSortArrow.getParameters().size() );
   }

   @Test
   public void testGetReturnType()
   {
      assertEquals( "",
                    constructor.getReturnType().getInternalNode().getStringValue() );
      assertEquals( "void",
                    drawHighlightIndicator.getReturnType().getInternalNode().getStringValue() );
      assertEquals( "void",
                    drawSelectionIndicator.getReturnType().getInternalNode().getStringValue() );
      assertEquals( "void",
                    drawRowBackground.getReturnType().getInternalNode().getStringValue() );
      assertEquals( "void",
                    placeSortArrow.getReturnType().getInternalNode().getStringValue() );
      assertEquals( "void",
                    flexunit4TestSetUp.getReturnType().getInternalNode().getStringValue() );
   }

   @Test
   public void testGetStatementNbInBody()
   {
      assertEquals( 7,
                    constructor.getStatementNbInBody() );
      assertEquals( 9,
                    drawHighlightIndicator.getStatementNbInBody() );
      assertEquals( 21,
                    placeSortArrow.getStatementNbInBody() );
   }

   @Test
   public void testIsGetter()
   {
      assertFalse( constructor.isGetter() );
      assertFalse( drawHighlightIndicator.isGetter() );
      assertFalse( isTrueSetter.isGetter() );
      assertTrue( isTrueGetter.isGetter() );
   }

   @Test
   public void testIsSetter()
   {
      assertFalse( constructor.isSetter() );
      assertFalse( drawHighlightIndicator.isSetter() );
      assertFalse( isTrueGetter.isSetter() );
      assertTrue( isTrueSetter.isSetter() );
   }

   @Test
   public void testLocalVariables()
   {
      assertEquals( 0,
                    constructor.getLocalVariables().size() );
      assertEquals( 2,
                    drawHighlightIndicator.getLocalVariables().size() );
      assertEquals( 13,
                    drawSelectionIndicator.getLocalVariables().size() );
      assertEquals( 5,
                    drawRowBackground.getLocalVariables().size() );
   }

   @Test
   public void testOverride()
   {
      assertTrue( drawHighlightIndicator.isOverriden() );
      assertFalse( isTrueGetter.isOverriden() );
   }

   @Test
   public void testSuperCall()
   {
      assertNotNull( constructor.getSuperCall() );
      assertNotNull( drawHighlightIndicator.getSuperCall() );
      assertNotNull( placeSortArrow.getSuperCall() );
      assertNull( drawRowBackground.getSuperCall() );
   }

   @Test
   public void testVisibility()
   {
      assertTrue( constructor.isPublic() );
      assertTrue( drawHighlightIndicator.is( Modifier.PROTECTED ) );
      assertTrue( drawSelectionIndicator.is( Modifier.PROTECTED ) );
      assertTrue( drawRowBackground.is( Modifier.PROTECTED ) );
      assertTrue( isTrueGetter.is( Modifier.PRIVATE ) );
   }
}
