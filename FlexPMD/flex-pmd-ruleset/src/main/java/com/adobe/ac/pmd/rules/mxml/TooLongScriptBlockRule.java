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
package com.adobe.ac.pmd.rules.mxml;

import java.util.ArrayList;
import java.util.List;

import com.adobe.ac.pmd.IFlexViolation;
import com.adobe.ac.pmd.files.IMxmlFile;
import com.adobe.ac.pmd.rules.core.ViolationPosition;
import com.adobe.ac.pmd.rules.core.ViolationPriority;
import com.adobe.ac.pmd.rules.core.thresholded.AbstractMaximizedFlexRule;

/**
 * @author xagnetti
 */
public class TooLongScriptBlockRule extends AbstractMaximizedFlexRule
{
   public static final int DEFAULT_THRESHOLD = 50;
   private int             linesInScriptBlock;

   /*
    * (non-Javadoc)
    * @seecom.adobe.ac.pmd.rules.core.thresholded.IThresholdedRule#
    * getActualValueForTheCurrentViolation()
    */
   public final int getActualValueForTheCurrentViolation()
   {
      return linesInScriptBlock;
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.thresholded.IThresholdedRule#getDefaultThreshold
    * ()
    */
   public final int getDefaultThreshold()
   {
      return DEFAULT_THRESHOLD;
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractFlexRule#isConcernedByTheCurrentFile()
    */
   @Override
   public final boolean isConcernedByTheCurrentFile()
   {
      return getCurrentFile().isMxml();
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractFlexRule#findViolationsInCurrentFile()
    */
   @Override
   protected final List< IFlexViolation > findViolationsInCurrentFile()
   {
      final List< IFlexViolation > violations = new ArrayList< IFlexViolation >();
      final IMxmlFile mxml = ( IMxmlFile ) getCurrentFile();

      linesInScriptBlock = mxml.getEndingScriptBlock()
            - mxml.getBeginningScriptBlock();

      if ( linesInScriptBlock >= getThreshold() )
      {
         addViolation( violations,
                       new ViolationPosition( mxml.getBeginningScriptBlock(), mxml.getEndingScriptBlock() ) );
      }
      return violations;
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
}
