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
import static org.junit.Assert.assertNull;
import net.sourceforge.pmd.PMDException;

import org.junit.Before;
import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.files.FileSetUtils;
import com.adobe.ac.pmd.nodes.IAttribute;
import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.parser.IParserNode;

public class VariableNodeTest extends FlexPmdTestBase
{
   private IAttribute first;

   @Before
   public void setup() throws PMDException
   {
      final IParserNode ast = FileSetUtils.buildAst( getTestFiles().get( "cairngorm.NonBindableModelLocator.as" ) );
      final IClass nonBindableModelLocator = NodeFactory.createPackage( ast ).getClassNode();
      first = nonBindableModelLocator.getAttributes().get( 0 );
   }

   @Test
   public void testGetAllMetaData()
   {
      assertEquals( 0,
                    first.getAllMetaData().size() );
   }

   @Test
   public void testGetInitializationExpression()
   {
      assertNull( first.getInitializationExpression() );
   }

   @Test
   public void testGetMetaDataCount()
   {
      assertEquals( 0,
                    first.getMetaDataCount() );
   }

   @Test
   public void testGetName()
   {
      assertEquals( "_instance",
                    first.getName() );
   }

   @Test
   public void testGetType()
   {
      assertEquals( "ModelLocator",
                    first.getType().toString() );
   }
}
