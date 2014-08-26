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
package com.adobe.ac.pmd.rules.cairngorm;

/**
 * @author xagnetti
 */
public class ModelLocatorReferencedMoreThanOncePerClassRule extends
                                                           ReferenceModelLocatorOutsideTheMainApplicationRule
{
   private int referencesPerFile;

   /*
    * (non-Javadoc)
    * @seecom.adobe.ac.pmd.rules.cairngorm.
    * ReferenceModelLocatorOutsideTheMainApplicationRule
    * #isViolationDetectedOnThisMatchingLine(java.lang.String)
    */
   @Override
   protected final boolean isViolationDetectedOnThisMatchingLine( final String line )
   {
      if ( !line.contains( "import" )
            && !line.contains( "return" ) )
      {
         referencesPerFile++;
      }
      return referencesPerFile > 1;
   }

   /*
    * (non-Javadoc)
    * @see com.adobe.ac.pmd.rules.core.AbstractFlexRule#onRuleStart()
    */
   @Override
   protected final void onRuleStart()
   {
      referencesPerFile = 0;
   }
}
