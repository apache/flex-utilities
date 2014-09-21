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

import java.io.File;

import net.sourceforge.pmd.PMDException;

import org.junit.Ignore;
import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.files.FileSetUtils;
import com.adobe.ac.pmd.files.IFlexFile;
import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.impl.NodeFactory;
import com.adobe.ac.pmd.parser.IParserNode;

public class ClassMetricsTest extends FlexPmdTestBase
{
   @Test
   public void testBug157() throws PMDException
   {
      final IFlexFile file = getTestFiles().get( "bug.FlexPMD157.as" );
      final IParserNode ast = FileSetUtils.buildAst( file );
      final IClass classNode = NodeFactory.createPackage( ast ).getClassNode();
      final ClassMetrics classMetrics = ClassMetrics.create( "bug",
                                                             new File( file.getFilePath() ),
                                                             InternalFunctionMetrics.create( new ProjectMetrics(),
                                                                                             file.getFullyQualifiedName(),
                                                                                             classNode ),
                                                             classNode,
                                                             file,
                                                             0 );

      assertEquals( "<object><name>bug.FlexPMD157</name><ccn>0</ccn><ncss>3</ncss><javadocs>0</javadocs>"
                          + "<javadoc_lines>0</javadoc_lines><multi_comment_lines>0</multi_comment_lines>"
                          + "<single_comment_lines>0</single_comment_lines><functions>0</functions></object>",
                    classMetrics.toXmlString() );
   }

   @Test
   public void testBug181() throws PMDException
   {
      final IFlexFile file = getTestFiles().get( "bug.FlexPMD181.as" );
      final IParserNode ast = FileSetUtils.buildAst( file );
      final IClass classNode = NodeFactory.createPackage( ast ).getClassNode();
      final ClassMetrics classMetrics = ClassMetrics.create( "bug",
                                                             new File( file.getFilePath() ),
                                                             InternalFunctionMetrics.create( new ProjectMetrics(),
                                                                                             file.getFullyQualifiedName(),
                                                                                             classNode ),
                                                             classNode,
                                                             file,
                                                             0 );

      assertEquals( "<object><name>bug.FlexPMD181</name><ccn>3</ccn><ncss>379</ncss><javadocs>1403"
                          + "</javadocs><javadoc_lines>1403</javadoc_lines><multi_comment_lines>4"
                          + "</multi_comment_lines><single_comment_lines>0</single_comment_lines>"
                          + "<functions>81</functions></object>",
                    classMetrics.toXmlString() );
   }

   @Test
   public void testBug232() throws PMDException
   {
      final IFlexFile file = getTestFiles().get( "bug.FlexPMD232.as" );
      final IParserNode ast = FileSetUtils.buildAst( file );
      final IClass classNode = NodeFactory.createPackage( ast ).getClassNode();
      final ClassMetrics classMetrics = ClassMetrics.create( "bug",
                                                             new File( file.getFilePath() ),
                                                             InternalFunctionMetrics.create( new ProjectMetrics(),
                                                                                             file.getFullyQualifiedName(),
                                                                                             classNode ),
                                                             classNode,
                                                             file,
                                                             0 );

      assertEquals( "<object><name>bug.FlexPMD232</name><ccn>4</ccn><ncss>7</ncss><javadocs>0</javadocs>"
                          + "<javadoc_lines>0</javadoc_lines><multi_comment_lines>0</multi_comment_lines>"
                          + "<single_comment_lines>0</single_comment_lines><functions>1</functions></object>",
                    classMetrics.toXmlString() );
   }

   @Test
   public void testBug233() throws PMDException
   {
      final IFlexFile file = getTestFiles().get( "bug.Duane.mxml" );
      final IParserNode ast = FileSetUtils.buildAst( file );
      final IClass classNode = NodeFactory.createPackage( ast ).getClassNode();
      final ClassMetrics classMetrics = ClassMetrics.create( "bug",
                                                             new File( file.getFilePath() ),
                                                             InternalFunctionMetrics.create( new ProjectMetrics(),
                                                                                             file.getFullyQualifiedName(),
                                                                                             classNode ),
                                                             classNode,
                                                             file,
                                                             1 );

      assertEquals( "<object><name>bug.Duane</name><ccn>1</ccn><ncss>203</ncss><javadocs>0</javadocs>"
                          + "<javadoc_lines>0</javadoc_lines><multi_comment_lines>0</multi_comment_lines>"
                          + "<single_comment_lines>0</single_comment_lines><functions>8</functions></object>",
                    classMetrics.toXmlString() );
   }

   @Test
   public void testToXmlString() throws PMDException
   {
      final IFlexFile file = getTestFiles().get( "RadonDataGrid.as" );
      final IParserNode ast = FileSetUtils.buildAst( file );
      final IClass classNode = NodeFactory.createPackage( ast ).getClassNode();
      final ClassMetrics classMetrics = ClassMetrics.create( "com.adobe.ac",
                                                             new File( file.getFilePath() ),
                                                             InternalFunctionMetrics.create( new ProjectMetrics(),
                                                                                             file.getFullyQualifiedName(),
                                                                                             classNode ),
                                                             classNode,
                                                             file,
                                                             0 );

      assertEquals( "<object><name>com.adobe.ac.RadonDataGrid</name><ccn>3</ccn><ncss>87</ncss><javadocs>0</javadocs>"
                          + "<javadoc_lines>0</javadoc_lines><multi_comment_lines>0</multi_comment_lines>"
                          + "<single_comment_lines>0</single_comment_lines><functions>7</functions></object>",
                    classMetrics.toXmlString() );
   }

   @Test
   @Ignore("This test requires test-data that was not donated to Apache")
   public void testToXmlStringWithMultiLineComments() throws PMDException
   {
      final IFlexFile file = getTestFiles().get( "bug.FlexPMD60.as" );
      final IParserNode ast = FileSetUtils.buildAst( file );
      final IClass classNode = NodeFactory.createPackage( ast ).getClassNode();
      final ClassMetrics classMetrics = ClassMetrics.create( "bug",
                                                             new File( file.getFilePath() ),
                                                             InternalFunctionMetrics.create( new ProjectMetrics(),
                                                                                             file.getFullyQualifiedName(),
                                                                                             classNode ),
                                                             classNode,
                                                             file,
                                                             0 );

      assertEquals( "<object><name>bug.FlexPMD60</name><ccn>1</ccn><ncss>4</ncss><javadocs>9</javadocs>"
                          + "<javadoc_lines>9</javadoc_lines><multi_comment_lines>7</multi_comment_lines>"
                          + "<single_comment_lines>0</single_comment_lines><functions>1</functions></object>",
                    classMetrics.toXmlString() );
   }
}
