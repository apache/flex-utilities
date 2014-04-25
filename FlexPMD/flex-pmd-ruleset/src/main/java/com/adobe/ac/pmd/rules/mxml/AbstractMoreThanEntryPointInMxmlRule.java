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
package com.adobe.ac.pmd.rules.mxml;

import java.util.List;

import com.adobe.ac.pmd.nodes.IAttribute;
import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPosition;

/**
 * @author xagnetti
 */
abstract class AbstractMoreThanEntryPointInMxmlRule extends AbstractAstFlexRule
{
   private int lastPublicVarLine = 0;
   private int publicVarCount    = 0;

   /**
    * @return
    */
   public abstract int getThreshold();

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#isConcernedByTheCurrentFile
    * ()
    */
   @Override
   public final boolean isConcernedByTheCurrentFile()
   {
      return getCurrentFile().isMxml();
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolations(com.adobe
    * .ac.pmd.nodes.IClass)
    */
   @Override
   protected void findViolations( final IClass classNode )
   {
      publicVarCount = 0;
      lastPublicVarLine = 0;

      super.findViolations( classNode );

      if ( publicVarCount > getThreshold() )
      {
         addViolation( ViolationPosition.create( lastPublicVarLine,
                                                 lastPublicVarLine,
                                                 0,
                                                 getCurrentFile().getLineAt( lastPublicVarLine - 1 ).length() ) );
      }
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
      if ( function.isPublic()
            && function.isSetter() )
      {
         publicVarCount++;
         lastPublicVarLine = function.getInternalNode().getLine();
      }
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolationsFromAttributes
    * (java.util.List)
    */
   @Override
   protected void findViolationsFromAttributes( final List< IAttribute > variables )
   {
      for ( final IAttribute attribute : variables )
      {
         if ( attribute.isPublic() )
         {
            publicVarCount++;
            lastPublicVarLine = attribute.getInternalNode().getLine();
         }
      }
   }
}
