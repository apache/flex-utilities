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
package com.adobe.ac.pmd.rules.style;

import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IField;
import com.adobe.ac.pmd.nodes.IVariable;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public class BadFormatLoggerRule extends AbstractAstFlexRule
{
   private static final String CORRECT_LOGGER_NAME            = "LOG";
   private static final String LOGGER_INTERFACE               = "ILogger";
   private static final String MESSAGE_LOGGER_NAME_IS_NOT_LOG = "The logger name is not LOG";
   private static final String MESSAGE_NOT_INITIALIZED        = "The logger is not initialized";
   private static final String MESSAGE_SHOULD_BE_CONSTANT     = "A logger should be constant";

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolations(com.adobe
    * .ac.pmd.nodes.IClass)
    */
   @Override
   protected final void findViolations( final IClass classNode )
   {
      for ( final IVariable field : classNode.getAttributes() )
      {
         if ( field.getType().toString().equals( LOGGER_INTERFACE ) )
         {
            addViolation( field.getInternalNode(),
                          field.getInternalNode(),
                          MESSAGE_SHOULD_BE_CONSTANT );
         }
      }
      for ( final IField field : classNode.getConstants() )
      {
         if ( field.getType().toString().equals( LOGGER_INTERFACE ) )
         {
            if ( !field.getName().equals( CORRECT_LOGGER_NAME ) )
            {
               addViolation( field.getInternalNode(),
                             field.getInternalNode(),
                             MESSAGE_LOGGER_NAME_IS_NOT_LOG );
            }
            if ( field.getInitializationExpression() == null )
            {
               addViolation( field.getInternalNode(),
                             field.getInternalNode(),
                             MESSAGE_NOT_INITIALIZED );
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
      return ViolationPriority.LOW;
   }
}
