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

import com.adobe.ac.pmd.rules.core.AbstractAstFlexRuleTest;
import com.adobe.ac.pmd.rules.core.AbstractFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPosition;

public class AvoidInstanciationInLoopRuleTest extends AbstractAstFlexRuleTest
{
   @Override
   protected ExpectedViolation[] getExpectedViolatingFiles()
   {
      return new ExpectedViolation[]
      { new ExpectedViolation( "PngEncoder.as", new ViolationPosition[]
       { new ViolationPosition( 238 ),
                   new ViolationPosition( 265 ),
                   new ViolationPosition( 272 ) } ),
                  new ExpectedViolation( "Looping.as", new ViolationPosition[]
                  { new ViolationPosition( 31 ),
                              new ViolationPosition( 34 ),
                              new ViolationPosition( 38 ),
                              new ViolationPosition( 44 ),
                              new ViolationPosition( 47 ),
                              new ViolationPosition( 51 ),
                              new ViolationPosition( 56 ),
                              new ViolationPosition( 59 ),
                              new ViolationPosition( 63 ) } ) };
   }

   @Override
   protected AbstractFlexRule getRule()
   {
      return new AvoidInstanciationInLoopRule();
   }
}
