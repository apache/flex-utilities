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
package com.adobe.ac.pmd.rules.performance;

import com.adobe.ac.pmd.parser.IParserNode;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public final class RecursiveStyleManagerRule extends AbstractAstFlexRule
{
   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.rules.core.AbstractFlexRule#getDefaultPriority()
    */
   @Override
   protected ViolationPriority getDefaultPriority()
   {
      return ViolationPriority.NORMAL;
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#visitMethodCall(com.adobe
    * .ac.pmd.parser.IParserNode)
    */
   @Override
   protected void visitMethodCall( final IParserNode methodCallNode )
   {
      final String methodName = methodCallNode.getChild( 0 ).getStringValue();

      if ( "loadStyles".equals( methodName )
            && ( methodCallNode.getChild( 1 ).numChildren() != 2 || "true".equals( methodCallNode.getChild( 1 )
                                                                                                 .getChild( 1 )
                                                                                                 .getStringValue() ) ) )
      {
         addViolation( methodCallNode );
      }
      super.visitMethodCall( methodCallNode );
   }
}
