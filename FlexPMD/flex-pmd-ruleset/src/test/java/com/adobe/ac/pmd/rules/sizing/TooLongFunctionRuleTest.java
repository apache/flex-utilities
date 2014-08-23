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
package com.adobe.ac.pmd.rules.sizing;

import java.util.LinkedHashMap;

import com.adobe.ac.pmd.rules.core.AbstractAstFlexRuleTest;
import com.adobe.ac.pmd.rules.core.AbstractFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPosition;

public class TooLongFunctionRuleTest extends AbstractAstFlexRuleTest
{
   @Override
   protected ExpectedViolation[] getExpectedViolatingFiles()
   {
      new LinkedHashMap< String, ViolationPosition[] >();

      return new ExpectedViolation[]
      { new ExpectedViolation( "cairngorm.FatController.as", new ViolationPosition[]
       { new ViolationPosition( 97 ) } ),
                  new ExpectedViolation( "com.adobe.ac.ncss.NestedSwitch.as", new ViolationPosition[]
                  { new ViolationPosition( 35 ) } ),
                  new ExpectedViolation( "com.adobe.ac.ncss.LongSwitch.as", new ViolationPosition[]
                  { new ViolationPosition( 39 ) } ),
                  new ExpectedViolation( "ErrorToltipSkin.as", new ViolationPosition[]
                  { new ViolationPosition( 156 ) } ),
                  new ExpectedViolation( "PngEncoder.as", new ViolationPosition[]
                  { new ViolationPosition( 150 ),
                              new ViolationPosition( 335 ),
                              new ViolationPosition( 548 ) } ),
                  new ExpectedViolation( "RadonDataGrid.as", new ViolationPosition[]
                  { new ViolationPosition( 84 ) } ) };
   }

   @Override
   protected AbstractFlexRule getRule()
   {
      return new TooLongFunctionRule();
   }
}
