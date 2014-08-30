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

import com.adobe.ac.pmd.rules.core.AbstractRegExpBasedRuleTest;
import com.adobe.ac.pmd.rules.core.AbstractRegexpBasedRule;
import com.adobe.ac.pmd.rules.core.ViolationPosition;

public class DynamicFiltersUsedInPopupTest extends AbstractRegExpBasedRuleTest
{
   @Override
   protected ExpectedViolation[] getExpectedViolatingFiles()
   {
      return new ExpectedViolation[]
      { new ExpectedViolation( "filters.MyPopup.as", new ViolationPosition[]
       { new ViolationPosition( 25 ) } ),
                  new ExpectedViolation( "filters.MyPopup.mxml", new ViolationPosition[]
                  { new ViolationPosition( 27 ),
                              new ViolationPosition( 30 ) } ) };
   }

   @Override
   protected String[] getMatchableLines()
   {
      final String[] lines =
      { "new DropShadowFilter",
                  "new GlowFilter",
                  "mx:DropShadowFilter" };
      return lines;
   }

   @Override
   protected AbstractRegexpBasedRule getRegexpBasedRule()
   {
      return new DynamicFiltersUsedInPopup();
   }

   @Override
   protected String[] getUnmatchableLines()
   {
      final String[] lines =
      { ".filterFunction",
                  "DropShadowfilter(" };
      return lines;
   }
}
