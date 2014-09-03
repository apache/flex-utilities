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
package com.adobe.ac.pmd.rules.architecture;

import java.util.Locale;
import java.util.regex.Matcher;

import com.adobe.ac.pmd.rules.core.AbstractRegexpBasedRule;
import com.adobe.ac.pmd.rules.core.ViolationPriority;

/**
 * @author xagnetti
 */
public class ViewComponentReferencedInModelRule extends AbstractRegexpBasedRule // NO_UCD
{
   private static final String ALERT_CLASS_NAME           = "Alert";
   private static final String FLEX_CONTROLS_PACKAGE_NAME = "mx.controls";
   private static final String MODEL_CLASS_SUFFIX         = "model";
   private static final String MODEL_PACKAGE_NAME         = ".model";
   private static final String VIEW_PACKAGE_NAME          = ".view";

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
      return ".*import (.*);?.*";
   }

   /*
    * (non-Javadoc)
    * @see
    * com.adobe.ac.pmd.rules.core.AbstractFlexRule#isConcernedByTheCurrentFile()
    */
   @Override
   protected final boolean isConcernedByTheCurrentFile()
   {
      return !getCurrentFile().isMxml()
            && getCurrentFile().getFullyQualifiedName()
                               .toLowerCase( Locale.ENGLISH )
                               .contains( MODEL_CLASS_SUFFIX );
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
      final String importedClass = matcher.group( 1 );

      return importedClass.contains( FLEX_CONTROLS_PACKAGE_NAME )
            && !importedClass.contains( ALERT_CLASS_NAME ) || importedClass.contains( VIEW_PACKAGE_NAME )
            && !importedClass.contains( MODEL_PACKAGE_NAME );
   }
}
