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

import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public class UnusedLocalVariableRule extends AbstractUnusedVariableRule
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
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#visitFunction(com.adobe
    * .ac.pmd.parser.IParserNode,
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule.FunctionType)
    */
   @Override
   protected final void visitFunction( final IParserNode ast,
                                       final FunctionType type )
   {
      setVariablesUnused( new LinkedHashMap< String, IParserNode >() );

      super.visitFunction( ast,
                           type );
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
    * com.adobe.ac.pmd.rules.unused.AbstractUnusedVariableRule#visitStatement
    * (com.adobe.ac.pmd.parser.IParserNode)
    */
   @Override
   protected final void visitStatement( final IParserNode ast )
   {
      super.visitStatement( ast );
      tryToAddVariableNodeInChildren( ast );
   }
}
