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

import java.util.List;

import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.nodes.INamableNode;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public class VariableNameEndingWithNumericRule extends AbstractAstFlexRule
{
   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolations(com.adobe
    * .ac.pmd.nodes.IClass)
    */
   @Override
   protected final void findViolations( final IClass classNode )
   {
      super.findViolations( classNode );

      findViolationsInNamableList( classNode.getAttributes() );
      findViolationsInNamableList( classNode.getConstants() );
      findViolationsInNamableList( classNode.getFunctions() );
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolations(com.adobe
    * .ac.pmd.nodes.IFunction)
    */
   @Override
   protected final void findViolations( final IFunction function )
   {
      findViolationsInNamableList( function.getParameters() );

      for ( final String variableName : function.getLocalVariables().keySet() )
      {
         if ( isNameEndsWithNumeric( variableName ) )
         {
            addViolation( function.getLocalVariables().get( variableName ),
                          variableName );
         }
      }
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

   private void findViolationsInNamableList( final List< ? extends INamableNode > namables )
   {
      for ( final INamableNode namable : namables )
      {
         if ( isNameEndsWithNumeric( namable.getName() ) )
         {
            if ( namable instanceof IFunction )
            {
               final IFunction function = ( IFunction ) namable;

               addViolation( function,
                             function.getName() );
            }
            else
            {
               addViolation( namable,
                             namable.getName() );
            }
         }
      }
   }

   private boolean isNameEndsWithNumeric( final String name )
   {
      if ( name.length() == 0 )
      {
         return false;
      }
      final char lastCharacter = name.charAt( name.length() - 1 );

      return Character.isDigit( lastCharacter );
   }
}
