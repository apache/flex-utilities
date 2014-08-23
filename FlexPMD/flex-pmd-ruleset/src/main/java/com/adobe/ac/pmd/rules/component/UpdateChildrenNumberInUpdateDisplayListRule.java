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
package com.adobe.ac.pmd.rules.component;

import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public class UpdateChildrenNumberInUpdateDisplayListRule extends AbstractAstFlexRule // NO_UCD
{
   private static final String[] METHOD_NAMES        =
                                                     { "addChild",
               "addChildAt",
               "removeChild",
               "removeChildAt"                      };
   private static final String   UPDATE_DISPLAY_LIST = "updateDisplayList";

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolations(com.adobe
    * .ac.pmd.nodes.IFunction)
    */
   @Override
   protected final void findViolations( final IFunction function )
   {
      if ( function.getName().equals( UPDATE_DISPLAY_LIST ) )
      {
         for ( final String methodName : METHOD_NAMES )
         {
            for ( final IParserNode statement : function.findPrimaryStatementsInBody( methodName ) )
            {
               addViolation( statement );
            }
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
      return ViolationPriority.HIGH;
   }
}
