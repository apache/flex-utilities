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
import java.util.Locale;

import com.adobe.ac.pmd.nodes.IConstant;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

public class CapitalizeConstantsRule extends AbstractAstFlexRule
{
   @Override
   protected void findViolationsFromConstants( final List< IConstant > constants )
   {
      for ( final IConstant constant : constants )
      {
         if ( nameContainsLowerCase( constant.getName() ) )
         {
            addViolation( constant,
                          constant.getName() );
         }
      }
   }

   @Override
   protected ViolationPriority getDefaultPriority()
   {
      return ViolationPriority.NORMAL;
   }

   private boolean nameContainsLowerCase( final String name )
   {
      return name.toUpperCase( Locale.getDefault() ).compareTo( name ) != 0;
   }
}
