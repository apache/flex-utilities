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

import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public class UseObjectTypeRule extends AbstractUseForbiddenTypeRule // NO_UCD
{
   private boolean isResponder;

   /*
    * (non-Javadoc)
    * @seecom.adobe.ac.pmd.rules.maintanability.forbiddentypes.
    * AbstractUseForbiddenTypeRule#findViolations(com.adobe.ac.pmd.nodes.IClass)
    */
   @Override
   protected void findViolations( final IClass classNode )
   {
      for ( final IParserNode implementation : classNode.getImplementations() )
      {
         if ( "IResponder".equals( implementation.getStringValue() ) )
         {
            isResponder = true;
            break;
         }
      }

      super.findViolations( classNode );
   }

   /*
    * (non-Javadoc)
    * @seecom.adobe.ac.pmd.rules.maintanability.forbiddentypes.
    * AbstractUseForbiddenTypeRule
    * #findViolationsInParametersList(com.adobe.ac.pmd.nodes.IFunction)
    */
   @Override
   protected void findViolationsInParametersList( final IFunction function )
   {
      if ( !isResponderImplementation( function ) )
      {
         super.findViolationsInParametersList( function );
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

   /*
    * (non-Javadoc)
    * @seecom.adobe.ac.pmd.rules.maintanability.forbiddentypes.
    * AbstractUseForbiddenTypeRule#getForbiddenType()
    */
   @Override
   protected String getForbiddenType()
   {
      return "Object";
   }

   private boolean isResponderImplementation( final IFunction function )
   {
      return isResponder
            && ( function.getName().equals( "result" ) || function.getName().equals( "fault" ) );
   }
}
