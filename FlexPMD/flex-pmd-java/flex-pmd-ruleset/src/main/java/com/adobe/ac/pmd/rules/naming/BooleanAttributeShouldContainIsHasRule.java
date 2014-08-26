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

import com.adobe.ac.pmd.nodes.IAttribute;
import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.nodes.INamableNode;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

public class BooleanAttributeShouldContainIsHasRule extends AbstractAstFlexRule
{
   private static final String   BOOLEAN         = "Boolean";
   private static final String[] FORBIDDEN_NAMES = new String[]
                                                 { "has",
               "is",
               "can"                            };

   @Override
   protected void findViolations( final IFunction function )
   {
      if ( function.isGetter()
            && function.isPublic() && function.getReturnType().toString().compareTo( BOOLEAN ) == 0 )
      {
         isWronglyNamed( function );
      }
   }

   @Override
   protected void findViolationsFromAttributes( final List< IAttribute > variables )
   {
      for ( final IAttribute variable : variables )
      {
         if ( variable.getName().compareTo( BOOLEAN ) == 0 )
         {
            isWronglyNamed( variable );
         }
      }
   }

   @Override
   protected ViolationPriority getDefaultPriority()
   {
      return ViolationPriority.LOW;
   }

   private void isWronglyNamed( final INamableNode namable )
   {
      for ( final String forbiddenName : FORBIDDEN_NAMES )
      {
         if ( namable.getName().startsWith( forbiddenName ) )
         {
            return;
         }
      }
      addViolation( namable,
                    namable.getName() );
   }
}
