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

import java.util.HashSet;
import java.util.Set;

import junit.framework.Assert;
import net.sourceforge.pmd.PMDException;

import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.files.FileSetUtils;
import com.adobe.ac.pmd.files.IFlexFile;
import com.adobe.ac.pmd.nodes.impl.NodeFactory;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.parser.NodeKind;

public class FlexRuleTest extends FlexPmdTestBase
{
   public class EmptyIfStmtRule extends AbstractAstFlexRule
   {
      /*
       * (non-Javadoc)
       * @see com.adobe.ac.pmd.rules.core.AbstractFlexRule#getDefaultPriority()
       */
      @Override
      protected final ViolationPriority getDefaultPriority()
      {
         return ViolationPriority.NORMAL;
      }

      /*
       * (non-Javadoc)
       * @see
       * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#visitIf(com.adobe.ac
       * .pmd .parser.IParserNode)
       */
      @Override
      protected final void visitIf( final IParserNode ast )
      {
         super.visitIf( ast );

         if ( isBlockEmpty( ast.getChild( 1 ) ) )
         {
            addViolation( ast );
         }
      }

      private boolean isBlockEmpty( final IParserNode block )
      {
         return block.is( NodeKind.BLOCK )
               && block.numChildren() == 0 || block.is( NodeKind.STMT_EMPTY );
      }
   }

   @Test
   public void testExclusions() throws PMDException
   {
      final AbstractFlexRule rule = new EmptyIfStmtRule();
      final IFlexFile duaneMxml = getTestFiles().get( "bug.Duane.mxml" );
      final Set< String > excludes = new HashSet< String >();

      excludes.add( "" );

      final int noExclusionViolationsLength = rule.processFile( duaneMxml,
                                                                NodeFactory.createPackage( FileSetUtils.buildAst( duaneMxml ) ),
                                                                getTestFiles() )
                                                  .size();

      rule.setExcludes( excludes );
      final int exclusionViolationsLength = rule.processFile( duaneMxml,
                                                              NodeFactory.createPackage( FileSetUtils.buildAst( duaneMxml ) ),
                                                              getTestFiles() )
                                                .size();

      Assert.assertTrue( noExclusionViolationsLength > exclusionViolationsLength );
   }
}
