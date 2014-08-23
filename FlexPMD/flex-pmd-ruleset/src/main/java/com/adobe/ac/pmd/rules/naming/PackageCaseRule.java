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

import com.adobe.ac.pmd.IFlexViolation;
import com.adobe.ac.pmd.nodes.IPackage;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public class PackageCaseRule extends AbstractAstFlexRule
{
   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolations(com.adobe
    * .ac.pmd.nodes.IPackage)
    */
   @Override
   protected final void findViolations( final IPackage packageNode )
   {
      if ( containsUpperCharacter( packageNode.getName() ) )
      {
         final IFlexViolation violation = addViolation( packageNode,
                                                        packageNode.getName() );

         violation.setEndColumn( packageNode.getName().length()
               + violation.getBeginColumn() );
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

   private boolean containsUpperCharacter( final String packageName )
   {
      boolean found = false;

      for ( int i = 1; i < packageName.length(); i++ )
      {
         final char currentChar = packageName.charAt( i );

         if ( currentChar >= 'A'
               && currentChar <= 'Z' && packageName.charAt( i - 1 ) == '.' )
         {
            found = true;

            break;
         }
      }
      return found;
   }
}
