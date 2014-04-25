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
package com.adobe.ac.pmd.rules.maintanability;

import java.util.List;

import com.adobe.ac.pmd.nodes.IAttribute;
import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.nodes.Modifier;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public class AvoidProtectedFieldInFinalClassRule extends AbstractAstFlexRule
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
      final boolean isClassFinal = classNode.isFinal();

      findProtectedAttributes( classNode.getAttributes(),
                               isClassFinal );
      findProtectedMethods( classNode.getFunctions(),
                            isClassFinal );
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.rules.core.AbstractFlexRule#getDefaultPriority()
    */
   @Override
   protected final ViolationPriority getDefaultPriority()
   {
      return ViolationPriority.LOW;
   }

   private void findProtectedAttributes( final List< IAttribute > atributes,
                                         final boolean isClassFinal )
   {
      if ( atributes != null )
      {
         for ( final IAttribute field : atributes )
         {
            if ( field.is( Modifier.PROTECTED )
                  && isClassFinal )
            {
               addViolation( field,
                             field.getName() );
            }
         }
      }
   }

   private void findProtectedMethods( final List< IFunction > functions,
                                      final boolean isClassFinal )
   {
      if ( functions != null )
      {
         for ( final IFunction function : functions )
         {
            if ( function.is( Modifier.PROTECTED )
                  && !function.isOverriden() && isClassFinal )
            {
               addViolation( function );
            }
         }
      }
   }
}
