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
package com.adobe.ac.pmd.rules.parsley;

import com.adobe.ac.pmd.rules.core.AbstractAstFlexRuleTest;
import com.adobe.ac.pmd.rules.core.AbstractFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPosition;

public class MisplacedMetaDataRuleTest extends AbstractAstFlexRuleTest
{
   @Override
   protected ExpectedViolation[] getExpectedViolatingFiles()
   {
      return new ExpectedViolation[]
      { new ExpectedViolation( "parsley.MisplacedMetaData.as", new ViolationPosition[]
      { new ViolationPosition( 36, 36 ),
                  new ViolationPosition( 37, 37 ),
                  new ViolationPosition( 38, 38 ),
                  new ViolationPosition( 39, 39 ),
                  new ViolationPosition( 40, 40 ),
                  new ViolationPosition( 41, 41 ),
                  new ViolationPosition( 42, 42 ),
                  new ViolationPosition( 43, 43 ),
                  new ViolationPosition( 46, 46 ),
                  new ViolationPosition( 51, 51 ),
                  new ViolationPosition( 52, 52 ),
                  new ViolationPosition( 53, 53 ),
                  new ViolationPosition( 54, 54 ),
                  new ViolationPosition( 55, 55 ),
                  new ViolationPosition( 56, 56 ),
                  new ViolationPosition( 57, 57 ),
                  new ViolationPosition( 58, 58 ),
                  new ViolationPosition( 21, 21 ),
                  new ViolationPosition( 22, 22 ),
                  new ViolationPosition( 23, 23 ),
                  new ViolationPosition( 24, 24 ),
                  new ViolationPosition( 25, 25 ),
                  new ViolationPosition( 26, 26 ),
                  new ViolationPosition( 27, 27 ),
                  new ViolationPosition( 28, 28 ),
                  new ViolationPosition( 29, 29 ),
                  new ViolationPosition( 30, 30 ),
                  new ViolationPosition( 31, 31 ),
                  new ViolationPosition( 32, 32 ),
                  new ViolationPosition( 33, 33 ), } ) };
   }

   @Override
   protected AbstractFlexRule getRule()
   {
      return new MisplacedMetaDataRule();
   }
}
