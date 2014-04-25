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
package com.adobe.ac.pmd.rules.core;

import net.sourceforge.pmd.PMDException;

import org.junit.Assert;
import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.files.FileSetUtils;
import com.adobe.ac.pmd.files.IFlexFile;
import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.nodes.impl.NodeFactory;
import com.adobe.ac.pmd.parser.IParserNode;

public class TestAbstractAstFlexRule extends FlexPmdTestBase
{
   public class AllRule extends AbstractAstFlexRule
   {
      protected boolean catchVisited     = false;
      protected boolean emptyVisited     = false;
      protected boolean interfaceVisited = false;
      protected boolean switchVisited    = false;
      protected boolean whileVisited     = false;

      @Override
      protected void findViolations( final IClass classNode )
      {
         super.findViolations( classNode );

         addViolation( classNode );
         addViolation( classNode.getInternalNode(),
                       "first",
                       "second" );
         addViolation( classNode,
                       "first",
                       "second" );
      }

      @Override
      protected void findViolations( final IFunction function )
      {
         super.findViolations( function );

         addViolation( function );
         addViolation( function,
                       "toto" );
      }

      @Override
      protected ViolationPriority getDefaultPriority()
      {
         return ViolationPriority.NORMAL;
      }

      @Override
      protected void visitCatch( final IParserNode catchNode )
      {
         super.visitCatch( catchNode );

         catchVisited = true;
      }

      @Override
      protected void visitEmptyStatetement( final IParserNode statementNode )
      {
         super.visitEmptyStatetement( statementNode );

         emptyVisited = true;
      }

      @Override
      protected void visitInterface( final IParserNode interfaceNode )
      {
         super.visitInterface( interfaceNode );

         interfaceVisited = true;
      }

      @Override
      protected void visitSwitch( final IParserNode switchNode )
      {
         super.visitSwitch( switchNode );

         switchVisited = true;
      }

      @Override
      protected void visitWhile( final IParserNode whileNode )
      {
         super.visitWhile( whileNode );

         whileVisited = true;
      }
   }

   @Test
   public void testVisit() throws PMDException
   {
      final AllRule rule = new AllRule();

      processFile( rule,
                   "bug.Duane.mxml" );
      processFile( rule,
                   "PngEncoder.as" );
      processFile( rule,
                   "Color.as" );
      processFile( rule,
                   "AbstractRowData.as" );
      processFile( rule,
                   "com.adobe.ac.ncss.LongSwitch.as" );
      processFile( rule,
                   "com.adobe.ac.ncss.BigImporterModel.as" );

      Assert.assertTrue( rule.catchVisited );
      Assert.assertTrue( rule.emptyVisited );
      Assert.assertTrue( rule.interfaceVisited );
      Assert.assertTrue( rule.switchVisited );
      Assert.assertTrue( rule.whileVisited );
   }

   private void processFile( final AllRule rule,
                             final String fileName ) throws PMDException
   {
      final IFlexFile duane = getTestFiles().get( fileName );
      rule.processFile( duane,
                        NodeFactory.createPackage( FileSetUtils.buildAst( duane ) ),
                        getTestFiles() );
   }
}
