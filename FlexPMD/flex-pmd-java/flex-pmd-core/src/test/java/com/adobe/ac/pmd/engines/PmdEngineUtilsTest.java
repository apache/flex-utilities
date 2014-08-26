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
package com.adobe.ac.pmd.engines;

import static org.junit.Assert.assertEquals;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.FlexPmdViolations;
import com.adobe.ac.pmd.IFlexViolation;
import com.adobe.ac.pmd.files.IFlexFile;
import com.adobe.ac.pmd.rules.core.AbstractFlexRule;
import com.adobe.ac.pmd.rules.core.IFlexRule;
import com.adobe.ac.pmd.rules.core.Violation;
import com.adobe.ac.pmd.rules.core.ViolationPosition;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

public class PmdEngineUtilsTest extends FlexPmdTestBase
{
   private class ErrorRule extends AbstractFlexRule implements IFlexRule
   {
      @Override
      protected List< IFlexViolation > findViolationsInCurrentFile()
      {
         return new ArrayList< IFlexViolation >();
      }

      @Override
      protected ViolationPriority getDefaultPriority()
      {
         return ViolationPriority.HIGH;
      }

      @Override
      protected boolean isConcernedByTheCurrentFile()
      {
         return true;
      }
   }

   private class WarningRule extends AbstractFlexRule
   {
      @Override
      protected List< IFlexViolation > findViolationsInCurrentFile()
      {
         return new ArrayList< IFlexViolation >();
      }

      @Override
      protected ViolationPriority getDefaultPriority()
      {
         return ViolationPriority.NORMAL;
      }

      @Override
      protected boolean isConcernedByTheCurrentFile()
      {
         return true;
      }
   }

   @Test
   public void testFindFirstViolationError()
   {
      final FlexPmdViolations violations = new FlexPmdViolations();
      final List< IFlexViolation > abstractRowDataViolations = new ArrayList< IFlexViolation >();

      assertEquals( "",
                    PmdEngineUtils.findFirstViolationError( violations ) );

      final IFlexFile abstractRowDataFlexFile = getTestFiles().get( "AbstractRowData.as" );

      abstractRowDataViolations.add( new Violation( new ViolationPosition( 0 ),
                                                    new ErrorRule(),
                                                    abstractRowDataFlexFile ) );
      abstractRowDataViolations.add( new Violation( new ViolationPosition( 0 ),
                                                    new WarningRule(),
                                                    abstractRowDataFlexFile ) );
      violations.getViolations().put( abstractRowDataFlexFile,
                                      abstractRowDataViolations );
      assertEquals( "An error violation has been found on the file AbstractRowData.as at line 0, with the rule"
                          + " \"com.adobe.ac.pmd.engines.PmdEngineUtilsTest$ErrorRule\": \n",
                    PmdEngineUtils.findFirstViolationError( violations ) );
   }
}
