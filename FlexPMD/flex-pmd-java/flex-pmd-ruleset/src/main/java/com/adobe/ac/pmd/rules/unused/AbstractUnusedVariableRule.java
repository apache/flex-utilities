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

import java.util.Map;

import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.parser.NodeKind;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;

/**
 * @author xagnetti
 */
abstract class AbstractUnusedVariableRule extends AbstractAstFlexRule
{
   private Map< String, IParserNode > variablesUnused;

   /**
    * @param variableName
    * @param ast
    */
   protected final void addVariable( final String variableName,
                                     final IParserNode ast )
   {
      variablesUnused.put( variableName,
                           ast );
   }

   /**
    * @return
    */
   protected Map< String, IParserNode > getVariablesUnused()
   {
      return variablesUnused;
   }

   /**
    * @param variablesUnusedToBeSet
    */
   protected void setVariablesUnused( final Map< String, IParserNode > variablesUnusedToBeSet )
   {
      variablesUnused = variablesUnusedToBeSet;
   }

   /**
    * @param ast
    */
   protected final void tryToAddVariableNodeInChildren( final IParserNode ast )
   {
      if ( ast != null
            && !tryToAddVariableNode( ast ) && ast.is( NodeKind.VAR_LIST ) )
      {
         for ( final IParserNode child : ast.getChildren() )
         {
            tryToAddVariableNode( child );
         }
      }
   }

   /**
    * @param ast
    */
   protected final void tryToMarkVariableAsUsed( final IParserNode ast )
   {
      if ( variablesUnused != null
            && ast != null )
      {
         markVariableAsUsed( ast );
      }
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#visitStatement(com.adobe
    * .ac.pmd.parser.IParserNode)
    */
   @Override
   protected void visitStatement( final IParserNode ast )
   {
      super.visitStatement( ast );

      tryToMarkVariableAsUsed( ast );
   }

   private void markVariableAsUsed( final IParserNode ast )
   {
      if ( ast.numChildren() == 0 )
      {
         if ( variablesUnused.containsKey( ast.getStringValue() ) )
         {
            variablesUnused.remove( ast.getStringValue() );
         }
      }
      else
      {
         for ( final IParserNode child : ast.getChildren() )
         {
            markVariableAsUsed( child );
         }
      }
   }

   private boolean tryToAddVariableNode( final IParserNode ast )
   {
      boolean result = false;

      if ( ast.is( NodeKind.NAME_TYPE_INIT ) )
      {
         addVariable( ast.getChild( 0 ).getStringValue(),
                      ast );
         result = true;
      }
      return result;
   }
}
