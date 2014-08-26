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
package com.adobe.ac.pmd.rules.core;

import java.util.ArrayList;
import java.util.List;

import com.adobe.ac.pmd.IFlexViolation;
import com.adobe.ac.pmd.rules.core.ViolationPosition;
import com.adobe.ac.pmd.rules.core.ViolationPriority;
import com.adobe.ac.pmd.rules.core.thresholded.AbstractMaximizedFlexRule;

public class EmptyRule extends AbstractMaximizedFlexRule
{
   public int getActualValueForTheCurrentViolation()
   {
      return 0;
   }

   public int getDefaultThreshold()
   {
      return 10;
   }

   @Override
   public String getDescription()
   {
      return "description";
   }

   @Override
   public String getMessage()
   {
      return "emptyMessage";
   }

   @Override
   public int getThreshold()
   {
      return getDefaultThreshold();
   }

   @Override
   public final boolean isConcernedByTheCurrentFile()
   {
      return true;
   }

   @Override
   protected List< IFlexViolation > findViolationsInCurrentFile()
   {
      final ArrayList< IFlexViolation > violations = new ArrayList< IFlexViolation >();

      addViolation( violations,
                    new ViolationPosition( 0 ) );

      return violations;
   }

   @Override
   protected ViolationPriority getDefaultPriority()
   {
      return ViolationPriority.LOW;
   }
}
