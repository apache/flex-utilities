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
package com.adobe.ac.pmd.rules.performance;

import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.parser.NodeKind;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;

public abstract class AbstractAvoidNodeInLoopRule extends AbstractAstFlexRule
{
   private int loopLevel = 0;

   protected int getLoopLevel()
   {
      return loopLevel;
   }

   protected abstract boolean isNodeForbidden( final IParserNode ast );

   @Override
   protected final void visitFor( final IParserNode ast )
   {
      loopLevel++;
      super.visitFor( ast );
      loopLevel--;
   }

   @Override
   protected final void visitForEach( final IParserNode ast )
   {
      loopLevel++;
      super.visitForEach( ast );
      loopLevel--;
   }

   @Override
   protected final void visitStatement( final IParserNode ast )
   {
      super.visitStatement( ast );

      if ( ast != null
            && !ast.is( NodeKind.WHILE ) && !ast.is( NodeKind.FOR ) && !ast.is( NodeKind.FOREACH )
            && !ast.is( NodeKind.FOR ) )
      {
         searchForbiddenNode( ast );
      }
   }

   @Override
   protected final void visitWhile( final IParserNode ast )
   {
      loopLevel++;
      super.visitWhile( ast );
      loopLevel--;
   }

   private void searchForbiddenNode( final IParserNode ast )
   {
      if ( ast.numChildren() > 0 )
      {
         for ( final IParserNode child : ast.getChildren() )
         {
            searchForbiddenNode( child );
         }
      }
      if ( isNodeForbidden( ast ) )
      {
         addViolation( ast );
      }
   }
}