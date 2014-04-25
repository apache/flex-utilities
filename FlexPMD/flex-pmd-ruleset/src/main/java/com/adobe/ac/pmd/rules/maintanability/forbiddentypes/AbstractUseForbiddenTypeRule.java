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
package com.adobe.ac.pmd.rules.maintanability.forbiddentypes;

import java.util.List;
import java.util.Map.Entry;

import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.nodes.IVariable;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;

/**
 * @author xagnetti
 */
public abstract class AbstractUseForbiddenTypeRule extends AbstractAstFlexRule
{
   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolations(com.adobe
    * .ac.pmd.nodes.IClass)
    */
   @Override
   protected void findViolations( final IClass classNode )
   {
      super.findViolations( classNode );

      findViolationInVariableLists( classNode.getAttributes() );
      findViolationInVariableLists( classNode.getConstants() );
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolations(com.adobe
    * .ac.pmd.nodes.IFunction)
    */
   @Override
   protected void findViolations( final IFunction function )
   {
      findViolationsInReturnType( function );
      if ( !function.isOverriden() )
      {
         findViolationsInParametersList( function );
      }
      findViolationsInLocalVariables( function );
   }

   /**
    * @param function
    */
   protected void findViolationsInParametersList( final IFunction function )
   {
      findViolationInVariableLists( function.getParameters() );
   }

   /**
    * @return
    */
   protected abstract String getForbiddenType();

   private < E extends IVariable > void findViolationInVariableLists( final List< E > variables )
   {
      for ( final IVariable variable : variables )
      {
         if ( variable.getType() != null )
         {
            tryToAddViolation( variable.getInternalNode(),
                               variable.getType().toString() );
         }
      }
   }

   private void findViolationsInLocalVariables( final IFunction function )
   {
      for ( final Entry< String, IParserNode > localVariableEntry : function.getLocalVariables().entrySet() )
      {
         final IParserNode type = getTypeFromFieldDeclaration( localVariableEntry.getValue() );

         tryToAddViolation( type,
                            type.getStringValue() );
      }
   }

   private void findViolationsInReturnType( final IFunction function )
   {
      if ( function != null
            && function.getReturnType() != null )
      {
         tryToAddViolation( function.getReturnType().getInternalNode(),
                            function.getReturnType().toString() );
      }
   }

   private void tryToAddViolation( final IParserNode node,
                                   final String typeName )
   {
      if ( typeName.equals( getForbiddenType() ) )
      {
         addViolation( node );
      }
   }
}
