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
package com.adobe.ac.pmd.rules.naming;

import java.util.Collection;
import java.util.List;
import java.util.Map.Entry;

import com.adobe.ac.pmd.nodes.IAttribute;
import com.adobe.ac.pmd.nodes.IConstant;
import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.nodes.IVariable;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public class WronglyNamedVariableRule extends AbstractAstFlexRule
{
   private static final String[] FORBIDDEN_NAMES =
                                                 { "tmp",
               "temp",
               "foo",
               "bar",
               "object",
               "evt"                            };

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolations(java.util
    * .List)
    */
   @Override
   protected final void findViolations( final List< IFunction > functions )
   {
      for ( final IFunction function : functions )
      {
         findViolationsInVariables( function.getParameters() );

         for ( final Entry< String, IParserNode > variableNameEntrySet : function.getLocalVariables()
                                                                                 .entrySet() )
         {
            checkWronglyNamedVariable( variableNameEntrySet.getKey(),
                                       variableNameEntrySet.getValue() );
         }
      }
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolationsFromAttributes
    * (java.util.List)
    */
   @Override
   protected final void findViolationsFromAttributes( final List< IAttribute > attributes )
   {
      findViolationsInVariables( attributes );
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolationsFromConstants
    * (java.util.List)
    */
   @Override
   protected final void findViolationsFromConstants( final List< IConstant > constants )
   {
      findViolationsInVariables( constants );
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.rules.core.AbstractFlexRule#getDefaultPriority()
    */
   @Override
   protected final ViolationPriority getDefaultPriority()
   {
      return ViolationPriority.NORMAL;
   }

   private void checkWronglyNamedVariable( final String variableName,
                                           final IParserNode variableNode )
   {
      for ( final String forbiddenName : FORBIDDEN_NAMES )
      {
         if ( variableName.startsWith( forbiddenName ) )
         {
            addViolation( variableNode,
                          variableName );
         }
      }
   }

   private void findViolationsInVariables( final Collection< ? extends IVariable > variables )
   {
      for ( final IVariable variable : variables )
      {
         checkWronglyNamedVariable( variable.getName(),
                                    variable.getInternalNode() );
      }
   }
}
