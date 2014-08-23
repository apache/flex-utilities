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
import com.adobe.ac.pmd.nodes.IConstant;
import com.adobe.ac.pmd.nodes.IField;
import com.adobe.ac.pmd.nodes.MetaData;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public class ArrayFieldWithNoArrayElementTypeRule extends AbstractAstFlexRule
{
   private static final String ARRAY_TYPE = "Array";

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#isConcernedByTheCurrentFile
    * ()
    */
   @Override
   public boolean isConcernedByTheCurrentFile()
   {
      return getCurrentFile().isMxml();
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolationsFromAttributes
    * (java.util.List)
    */
   @Override
   protected final void findViolationsFromAttributes( final List< IAttribute > variables )
   {
      findViolationFromFieds( variables );
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolationsFromConstants
    * (java.util.List)
    */
   @Override
   protected void findViolationsFromConstants( final List< IConstant > constants )
   {
      findViolationFromFieds( constants );
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

   private void findViolationFromFieds( final List< ? extends IField > fields )
   {
      for ( final IField variable : fields )
      {
         if ( ARRAY_TYPE.equals( variable.getType().toString() )
               && variable.getMetaData( MetaData.ARRAY_ELEMENT_TYPE ) == null )
         {
            addViolation( variable,
                          variable.getName() );
         }
      }
   }
}
