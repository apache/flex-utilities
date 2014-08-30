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
package com.adobe.ac.pmd.rules.naming;

import com.adobe.ac.pmd.rules.core.AbstractAstFlexRuleTest;
import com.adobe.ac.pmd.rules.core.AbstractFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPosition;

public class WronglyNamedVariableRuleTest extends AbstractAstFlexRuleTest
{
   @Override
   protected ExpectedViolation[] getExpectedViolatingFiles()
   {
       return new ExpectedViolation[]
      { new ExpectedViolation( "PngEncoder.as", new ViolationPosition[]
       { new ViolationPosition( 323 ),
                   new ViolationPosition( 324 ),
                   new ViolationPosition( 325 ),
                   new ViolationPosition( 326 ),
                   new ViolationPosition( 327 ),
                   new ViolationPosition( 328 ),
                   new ViolationPosition( 329 ),
                   new ViolationPosition( 330 ),
                   new ViolationPosition( 333 ),
                   new ViolationPosition( 334 ),
                   new ViolationPosition( 335 ),
                   new ViolationPosition( 336 ),
                   new ViolationPosition( 370 ),
                   new ViolationPosition( 371 ),
                   new ViolationPosition( 372 ),
                   new ViolationPosition( 373 ),
                   new ViolationPosition( 374 ),
                   new ViolationPosition( 375 ),
                   new ViolationPosition( 376 ),
                   new ViolationPosition( 377 ),
                   new ViolationPosition( 380 ),
                   new ViolationPosition( 381 ),
                   new ViolationPosition( 382 ),
                   new ViolationPosition( 383 ) } ),
                  new ExpectedViolation( "GenericType.as", new ViolationPosition[]
                  { new ViolationPosition( 32 ),
                              new ViolationPosition( 34 ) } ),
                  new ExpectedViolation( "com.adobe.ac.ncss.ConfigProxy.as", new ViolationPosition[]
                  { new ViolationPosition( 30 ) } ),
                  new ExpectedViolation( "bug.FlexPMD141a.mxml", new ViolationPosition[]
                  { new ViolationPosition( 26 ) } ),
                  new ExpectedViolation( "AbstractRowData.as", new ViolationPosition[]
                  { new ViolationPosition( 40 ) } ) };
   }

   @Override
   protected AbstractFlexRule getRule()
   {
      return new WronglyNamedVariableRule();
   }
}
