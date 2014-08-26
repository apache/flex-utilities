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

import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public class TrueFalseConditionRule extends AbstractAstFlexRule // NO_UCD
{
   private static final int FALSE = 2;
   private static final int TRUE  = 1;

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.rules.core.AbstractFlexRule#getDefaultPriority()
    */
   @Override
   protected ViolationPriority getDefaultPriority()
   {
      return ViolationPriority.HIGH;
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#visitCondition(com.adobe
    * .ac.pmd.parser.IParserNode)
    */
   @Override
   protected void visitCondition( final IParserNode condition )
   {
      super.visitCondition( condition );

      final int conditionChidrenHaveBooleans = conditionChidrenHaveBooleans( condition );

      if ( conditionChidrenHaveBooleans > 0 )
      {
         addViolation( condition,
                       ( conditionChidrenHaveBooleans == TRUE ? ""
                                                             : "!" )
                             + "condition" );
      }
   }

   private int conditionChidrenHaveBooleans( final IParserNode condition )
   {
      if ( condition != null )
      {
         for ( final IParserNode child : condition.getChildren() )
         {
            if ( child.getStringValue() != null )
            {
               if ( child.getStringValue().compareTo( "true" ) == 0 )
               {
                  return TRUE;
               }
               if ( child.getStringValue().compareTo( "false" ) == 0 )
               {
                  return FALSE;
               }
            }
         }
      }
      return 0;
   }
}
