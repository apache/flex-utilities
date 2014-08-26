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
package com.adobe.ac.pmd.files;

import static org.junit.Assert.assertEquals;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;

public class MxmlFileTest extends FlexPmdTestBase
{
   private IMxmlFile bug141;
   private IMxmlFile bug233a;
   private IMxmlFile bug233b;
   private IMxmlFile deleteRenderer;
   private IMxmlFile iterationsList;
   private IMxmlFile nestedComponent;

   @Before
   public void setUp()
   {
      bug141 = ( IMxmlFile ) getTestFiles().get( "bug.FlexPMD141a.mxml" );
      bug233a = ( IMxmlFile ) getTestFiles().get( "bug.FlexPMD233a.mxml" );
      bug233b = ( IMxmlFile ) getTestFiles().get( "bug.FlexPMD233b.mxml" );
      iterationsList = ( IMxmlFile ) getTestFiles().get( "com.adobe.ac.ncss.mxml.IterationsList.mxml" );
      nestedComponent = ( IMxmlFile ) getTestFiles().get( "com.adobe.ac.ncss.mxml.NestedComponent.mxml" );
      deleteRenderer = ( IMxmlFile ) getTestFiles().get( "DeleteButtonRenderer.mxml" );
   }

   @Test
   public void testCommentTags()
   {
      assertEquals( "<!--",
                    iterationsList.getCommentOpeningTag() );
      assertEquals( "-->",
                    iterationsList.getCommentClosingTag() );
   }

   @Test
   public void testFlexPMD141()
   {
      final String[] lines = bug141.getScriptBlock();

      assertEquals( "package bug{",
                    lines[ 0 ] );
      assertEquals( "class FlexPMD141a{",
                    lines[ 1 ] );
      assertEquals( Integer.valueOf( 32 ),
                    Integer.valueOf( lines.length ) );
      assertEquals( "",
                    lines[ 22 ] );
      assertEquals( "",
                    lines[ 23 ] );
      assertEquals( "",
                    lines[ 24 ] );
      assertEquals( "private var object:List = new List();",
                    lines[ 25 ].trim() );
      assertEquals( "}}",
                    lines[ lines.length - 1 ] );
   }

   @Test
   public void testFlexPMD233()
   {
      final String[] lines = bug233a.getScriptBlock();

      Assert.assertEquals( "",
                           lines[ 47 ] );

      Assert.assertEquals( 80,
                           bug233b.getActualScriptBlock().length );
   }

   @Test
   public void testGetActionScriptScriptBlock()
   {
      final String[] deleteRendererLines = deleteRenderer.getScriptBlock();

      assertEquals( "package {",
                    deleteRendererLines[ 0 ] );
      assertEquals( "       [Event(name=\"ruleRemoved\", type=\"flash.events.Event\")]",
                    deleteRendererLines[ 29 ] );
      assertEquals( "class DeleteButtonRenderer{",
                    deleteRendererLines[ 30 ] );
      assertEquals( Integer.valueOf( 101 ),
                    Integer.valueOf( deleteRendererLines.length ) );
      assertEquals( "            import com.adobe.ac.pmd.model.Rule;",
                    deleteRendererLines[ 35 ] );
      assertEquals( "}}",
                    deleteRendererLines[ deleteRendererLines.length - 1 ] );
   }

   @Test
   public void testGetMxmlScriptBlock()
   {
      final String[] iterationsListLines = iterationsList.getScriptBlock();

      assertEquals( "package com.adobe.ac.ncss.mxml{",
                    iterationsListLines[ 0 ] );
      assertEquals( "class IterationsList{",
                    iterationsListLines[ 1 ] );
      assertEquals( "         import com.adobe.ac.anthology.model.object.IterationModelLocator;",
                    iterationsListLines[ 26 ] );
      assertEquals( "}}",
                    iterationsListLines[ iterationsListLines.length - 1 ] );
      assertEquals( Integer.valueOf( 90 ),
                    Integer.valueOf( iterationsListLines.length ) );
   }

   @Test
   public void testGetMxmlScriptBlock2()
   {
      final String[] nestedLines = nestedComponent.getScriptBlock();

      assertEquals( "package com.adobe.ac.ncss.mxml{",
                    nestedLines[ 0 ] );
      assertEquals( "class NestedComponent{",
                    nestedLines[ 1 ] );
      assertEquals( Integer.valueOf( 43 ),
                    Integer.valueOf( nestedLines.length ) );
      assertEquals( "}}",
                    nestedLines[ nestedLines.length - 1 ] );
   }

   @Test
   public void testScriptBlockLines()
   {
      assertEquals( Integer.valueOf( 26 ),
                    Integer.valueOf( iterationsList.getBeginningScriptBlock() ) );
      assertEquals( Integer.valueOf( 80 ),
                    Integer.valueOf( iterationsList.getEndingScriptBlock() ) );
   }
}
