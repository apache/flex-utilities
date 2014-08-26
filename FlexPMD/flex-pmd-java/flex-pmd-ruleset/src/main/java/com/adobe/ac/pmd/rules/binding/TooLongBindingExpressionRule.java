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
package com.adobe.ac.pmd.rules.binding;

import java.util.regex.Matcher;

import com.adobe.ac.pmd.rules.core.ViolationPriority;
import com.adobe.ac.pmd.rules.core.thresholded.AbstractMaximizedRegexpBasedRule;

/**
 * @author xagnetti
 */
public class TooLongBindingExpressionRule extends AbstractMaximizedRegexpBasedRule // NO_UCD
{
   private int currentCount;

   /*
    * (non-Javadoc)
    * @seecom.adobe.ac.pmd.rules.core.thresholded.IThresholdedRule#
    * getActualValueForTheCurrentViolation()
    */
   public final int getActualValueForTheCurrentViolation()
   {
      return currentCount;
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
    * @see com.adobe.ac.pmd.rules.core.AbstractRegexpBasedRule#getRegexp()
    */
   @Override
   protected final String getRegexp()
   {
      return ".*=\"\\{[^']([^\\}]*)[^']\\}\".*";
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractFlexRule#isConcernedByTheCurrentFile()
    */
   @Override
   protected final boolean isConcernedByTheCurrentFile()
   {
      return getCurrentFile().isMxml();
   }

   /*
    * (non-Javadoc)
    * @seecom.adobe.ac.pmd.rules.core.AbstractRegexpBasedRule#
    * isViolationDetectedOnThisMatchingLine(java.lang.String)
    */
   @Override
   protected final boolean isViolationDetectedOnThisMatchingLine( final String line )
   {
      final Matcher matcher = getMatcher( line );

      matcher.matches();
      currentCount = countChar( matcher.group( 1 ),
                                '.' );
      return matcher.matches()
            && currentCount > getThreshold();
   }

   private int countChar( final String input,
                          final char charToSearch )
   {
      int charCount = 0;

      for ( int i = 0; i < input.length(); i++ )
      {
         if ( input.charAt( i ) == charToSearch )
         {
            charCount++;
         }
      }

      return charCount;
   }
}
