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
package com.adobe.ac.pmd.rules.flexunit;

import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IFunction;
import com.adobe.ac.pmd.nodes.MetaData;
import com.adobe.ac.pmd.rules.core.AbstractAstFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public final class EmptyUnitTest extends AbstractAstFlexRule
{
   private static final String[] ASSERTIONS = new String[]
                                            { "assertEquals",
               "assertObjectEquals",
               "assertMatch",
               "assertNoMatch",
               "assertContained",
               "assertNotContained",
               "assertStrictlyEquals",
               "assertTrue",
               "assertFalse",
               "assertNull",
               "assertNotNull",
               "assertUndefined",
               "assertNotUndefined",
               "assertThat",
               "handleEvent",
               "assertEvents",
               "fail"                      };

   private boolean               isExtendingTestCase;

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolations(com.adobe
    * .ac.pmd.nodes.IClass)
    */
   @Override
   protected void findViolations( final IClass classNode )
   {
      isExtendingTestCase = classNode.getExtensionName() != null
            && classNode.getExtensionName().endsWith( "TestCase" );

      super.findViolations( classNode );
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractAstFlexRule#findViolations(com.adobe
    * .ac.pmd.nodes.IFunction)
    */
   @Override
   protected void findViolations( final IFunction function )
   {
      super.findViolations( function );

      if ( isExtendingTestCase
            && function.getName().startsWith( "test" )
            && function.findPrimaryStatementInBody( ASSERTIONS ).isEmpty() )
      {
         addViolation( function );
      }
      if ( !function.getMetaData( MetaData.TEST ).isEmpty()
            && function.findPrimaryStatementInBody( ASSERTIONS ).isEmpty() )
      {
         addViolation( function );
      }
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.rules.core.AbstractFlexRule#getDefaultPriority()
    */
   @Override
   protected ViolationPriority getDefaultPriority()
   {
      return ViolationPriority.NORMAL;
   }
}
