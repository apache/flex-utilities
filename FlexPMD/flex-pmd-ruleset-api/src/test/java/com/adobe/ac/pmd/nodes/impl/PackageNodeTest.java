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
import static org.junit.Assert.assertNull;

import java.io.IOException;

import net.sourceforge.pmd.PMDException;

import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.files.FileSetUtils;
import com.adobe.ac.pmd.nodes.IPackage;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.parser.exceptions.TokenException;

public class PackageNodeTest extends FlexPmdTestBase
{
   private final IPackage buttonRenderer;
   private final IPackage FlexPMD115Package;
   private final IPackage FlexPMD62Package;
   private final IPackage modelLocator;
   private final IPackage stylePackage;

   public PackageNodeTest() throws PMDException
   {
      final IParserNode ast = FileSetUtils.buildAst( getTestFiles().get( "SkinStyles.as" ) );
      stylePackage = NodeFactory.createPackage( ast );

      final IParserNode buttonRendererAst = FileSetUtils.buildAst( getTestFiles().get( "DeleteButtonRenderer.mxml" ) );
      buttonRenderer = NodeFactory.createPackage( buttonRendererAst );

      final IParserNode modelLocatorAst = FileSetUtils.buildAst( getTestFiles().get( "cairngorm."
            + "NonBindableModelLocator.as" ) );
      modelLocator = NodeFactory.createPackage( modelLocatorAst );

      final IParserNode bug62Ast = FileSetUtils.buildAst( getTestFiles().get( "bug."
            + "FlexPMD62.as" ) );
      FlexPMD62Package = NodeFactory.createPackage( bug62Ast );

      final IParserNode bug115Ast = FileSetUtils.buildAst( getTestFiles().get( "bug."
            + "FlexPMD115.as" ) );
      FlexPMD115Package = NodeFactory.createPackage( bug115Ast );
   }

   @Test
   public void testConstructMxmlFile() throws IOException,
                                      TokenException,
                                      PMDException
   {
      assertNotNull( buttonRenderer.getClassNode() );
      assertEquals( "",
                    buttonRenderer.getName() );
      assertEquals( 0,
                    buttonRenderer.getImports().size() );

   }

   @Test
   public void testConstructNamespace() throws IOException,
                                       TokenException,
                                       PMDException
   {
      final IParserNode ast = FileSetUtils.buildAst( getTestFiles().get( "schedule_internal.as" ) );
      final IPackage namespacePackage = NodeFactory.createPackage( ast );

      assertNull( namespacePackage.getClassNode() );
      assertEquals( "flexlib.scheduling.scheduleClasses",
                    namespacePackage.getName() );
      assertEquals( 0,
                    namespacePackage.getImports().size() );
   }

   @Test
   public void testConstructStyles()
   {
      assertNull( stylePackage.getClassNode() );
      assertEquals( "",
                    stylePackage.getName() );
      assertEquals( 0,
                    stylePackage.getImports().size() );
   }

   @Test
   public void testFullyQualifiedName()
   {
      assertEquals( "",
                    stylePackage.getFullyQualifiedClassName() );
      assertEquals( "DeleteButtonRenderer",
                    buttonRenderer.getFullyQualifiedClassName() );
      assertEquals( "com.adobe.ac.sample.model.ModelLocator",
                    modelLocator.getFullyQualifiedClassName() );
   }

   @Test
   public void testGetFunctions()
   {
      assertEquals( 0,
                    stylePackage.getFunctions().size() );
   }

   @Test
   public void testGetName()
   {
      assertEquals( "com.test.testy.ui.components",
                    FlexPMD62Package.getName() );
   }
}
