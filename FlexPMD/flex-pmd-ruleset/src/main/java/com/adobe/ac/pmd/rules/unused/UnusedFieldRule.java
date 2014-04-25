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
package com.adobe.ac.pmd.rules.unused;

import java.util.LinkedHashMap;
import java.util.List;

import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.parser.KeyWords;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public class UnusedFieldRule extends AbstractUnusedVariableRule
{
   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#isConcernedByTheCurrentFile
    * ()
    */
   @Override
   public final boolean isConcernedByTheCurrentFile()
   {
      return !getCurrentFile().isMxml();
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.rules.core.AbstractFlexRule#getDefaultPriority()
    */
   @Override
   protected final ViolationPriority getDefaultPriority()
   {
      return ViolationPriority.HIGH;
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#visitClass(com.adobe.ac
    * .pmd.parser.IParserNode)
    */
   @Override
   protected final void visitClass( final IParserNode classNode )
   {
      setVariablesUnused( new LinkedHashMap< String, IParserNode >() );

      super.visitClass( classNode );

      for ( final String variableName : getVariablesUnused().keySet() )
      {
         final IParserNode variable = getVariablesUnused().get( variableName );

         addViolation( variable,
                       variable,
                       variableName );
      }
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#visitVariableInitialization
    * (com.adobe.ac.pmd.parser.IParserNode)
    */
   @Override
   protected final void visitVariableInitialization( final IParserNode node )
   {
      super.visitVariableInitialization( node );

      tryToMarkVariableAsUsed( node );
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#visitVarOrConstList(com
    * .adobe.ac.pmd.parser.IParserNode,
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule.VariableOrConstant,
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule.VariableScope)
    */
   @Override
   protected final void visitVarOrConstList( final IParserNode ast,
                                             final VariableOrConstant varOrConst,
                                             final VariableScope scope )
   {
      if ( scope.equals( VariableScope.IN_CLASS ) )
      {
         final List< IParserNode > modifiers = ast.getChild( 0 ).getChildren();
         boolean isPrivate = false;

         if ( !modifiers.isEmpty() )
         {
            for ( final IParserNode modifierNode : modifiers )
            {
               if ( modifierNode.getStringValue().equals( KeyWords.PRIVATE.toString() ) )
               {
                  isPrivate = true;
                  break;
               }
            }
         }
         if ( isPrivate )
         {
            tryToAddVariableNodeInChildren( ast );
         }
      }
      super.visitVarOrConstList( ast,
                                 varOrConst,
                                 scope );
   }
}
