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
package com.adobe.ac.pmd.nodes.utils;

import static org.junit.Assert.assertEquals;
import net.sourceforge.pmd.PMDException;

import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.files.FileSetUtils;
import com.adobe.ac.pmd.files.IFlexFile;
import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.impl.NodeFactory;
import com.adobe.ac.pmd.parser.IParserNode;

public class FunctionUtilsTest extends FlexPmdTestBase
{
   @Test
   public void testComputeFunctionLength() throws PMDException
   {
      final IFlexFile file = getTestFiles().get( "RadonDataGrid.as" );
      final IParserNode dataGridAst = FileSetUtils.buildAst( file );
      final IClass radonDataGrid = NodeFactory.createPackage( dataGridAst ).getClassNode();

      assertEquals( 6,
                    FunctionUtils.computeFunctionLength( file,
                                                         radonDataGrid.getFunctions().get( 0 ).getBody() ) );

      assertEquals( 9,
                    FunctionUtils.computeFunctionLength( file,
                                                         radonDataGrid.getFunctions().get( 1 ).getBody() ) );

      assertEquals( 21,
                    FunctionUtils.computeFunctionLength( file,
                                                         radonDataGrid.getFunctions().get( 2 ).getBody() ) );

      assertEquals( 16,
                    FunctionUtils.computeFunctionLength( file,
                                                         radonDataGrid.getFunctions().get( 3 ).getBody() ) );

      assertEquals( 10,
                    FunctionUtils.computeFunctionLength( file,
                                                         radonDataGrid.getFunctions().get( 4 ).getBody() ) );
   }
}
