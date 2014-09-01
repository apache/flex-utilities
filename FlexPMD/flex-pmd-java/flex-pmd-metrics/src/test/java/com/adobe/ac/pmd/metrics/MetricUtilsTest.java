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
package com.adobe.ac.pmd.metrics;

import static org.junit.Assert.assertEquals;
import net.sourceforge.pmd.PMDException;

import org.junit.Ignore;
import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.files.FileSetUtils;
import com.adobe.ac.pmd.files.IFlexFile;
import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.impl.NodeFactory;
import com.adobe.ac.pmd.parser.IParserNode;

public class MetricUtilsTest extends FlexPmdTestBase
{
   @Test
   @Ignore("This test requires test-data that was not donated to Apache")
   public void testComputeMultiLineComments() throws PMDException
   {
      final IFlexFile file = getTestFiles().get( "bug.FlexPMD60.as" );
      final IParserNode ast = FileSetUtils.buildAst( file );
      final IClass classNode = NodeFactory.createPackage( ast ).getClassNode();

      assertEquals( 6,
                    MetricUtils.computeMultiLineComments( classNode ) );
   }
}
