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
import com.adobe.ac.pmd.rules.core.ViolationPriority;
import com.adobe.ac.pmd.rules.core.thresholded.AbstractMaximizedAstFlexRule;

/**
 * @author xagnetti
 */
public class DeeplyNestedIfRule extends AbstractMaximizedAstFlexRule
{
   private int ifLevel = 0;

   /*
    * (non-Javadoc)
    * @seecom.adobe.ac.pmd.rules.core.thresholded.IThresholdedRule#
    * getActualValueForTheCurrentViolation()
    */
   public final int getActualValueForTheCurrentViolation()
   {
      return ifLevel;
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.thresholded.IThresholdedRule#getDefaultThreshold
    * ()
    */
   public final int getDefaultThreshold()
   {
      return 2;
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

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#visitElse(com.adobe.ac
    * .pmd.parser.IParserNode)
    */
   @Override
   protected final void visitElse( final IParserNode ifNode )
   {
      beforeVisitingIfBlock();

      super.visitElse( ifNode );

      afterVisitingIfBlock( ifNode );
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#visitFunction(com.adobe
    * .ac.pmd.parser.IParserNode,
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule.FunctionType)
    */
   @Override
   protected final void visitFunction( final IParserNode ast,
                                       final FunctionType type )
   {
      ifLevel = 0;

      super.visitFunction( ast,
                           type );
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#visitThen(com.adobe.ac
    * .pmd.parser.IParserNode)
    */
   @Override
   protected final void visitThen( final IParserNode ifNode )
   {
      beforeVisitingIfBlock();

      super.visitThen( ifNode );

      afterVisitingIfBlock( ifNode );
   }

   private void afterVisitingIfBlock( final IParserNode ifNode )
   {
      ifLevel--;
      if ( ifLevel >= getThreshold() )
      {
         addViolation( ifNode );
      }
   }

   private void beforeVisitingIfBlock()
   {
      ifLevel++;
   }
}
