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

public class AvoidDeclarationInLoopRuleTest extends AbstractAstFlexRuleTest
{
   @Override
   protected ExpectedViolation[] getExpectedViolatingFiles()
   {
      return new ExpectedViolation[]
      { new ExpectedViolation( "bug.FlexPMD181.as", new ViolationPosition[]
       { new ViolationPosition( 2338 ) } ),
                  new ExpectedViolation( "bug.FlexPMD88.as", new ViolationPosition[]
                  { new ViolationPosition( 48 ) } ),
                  new ExpectedViolation( "com.adobe.ac.ncss.mxml.IterationsList.mxml",
                                         new ViolationPosition[]
                                         { new ViolationPosition( 53 ),
                                                     new ViolationPosition( 64 ),
                                                     new ViolationPosition( 76 ) } ),
                  new ExpectedViolation( "com.adobe.ac.ncss.TestResult.as", new ViolationPosition[]
                  { new ViolationPosition( 136 ),
                              new ViolationPosition( 150 ) } ),
                  new ExpectedViolation( "Looping.as", new ViolationPosition[]
                  { new ViolationPosition( 63 ) } ),
                  new ExpectedViolation( "PngEncoder.as", new ViolationPosition[]
                  { new ViolationPosition( 205 ),
                              new ViolationPosition( 224 ),
                              new ViolationPosition( 340 ),
                              new ViolationPosition( 341 ),
                              new ViolationPosition( 342 ),
                              new ViolationPosition( 343 ),
                              new ViolationPosition( 344 ),
                              new ViolationPosition( 345 ),
                              new ViolationPosition( 346 ),
                              new ViolationPosition( 347 ),
                              new ViolationPosition( 350 ),
                              new ViolationPosition( 351 ),
                              new ViolationPosition( 352 ),
                              new ViolationPosition( 353 ),
                              new ViolationPosition( 358 ),
                              new ViolationPosition( 368 ),
                              new ViolationPosition( 369 ),
                              new ViolationPosition( 370 ),
                              new ViolationPosition( 371 ),
                              new ViolationPosition( 373 ),
                              new ViolationPosition( 374 ),
                              new ViolationPosition( 387 ),
                              new ViolationPosition( 388 ),
                              new ViolationPosition( 389 ),
                              new ViolationPosition( 390 ),
                              new ViolationPosition( 391 ),
                              new ViolationPosition( 392 ),
                              new ViolationPosition( 393 ),
                              new ViolationPosition( 394 ),
                              new ViolationPosition( 397 ),
                              new ViolationPosition( 398 ),
                              new ViolationPosition( 399 ),
                              new ViolationPosition( 400 ),
                              new ViolationPosition( 405 ),
                              new ViolationPosition( 415 ),
                              new ViolationPosition( 416 ),
                              new ViolationPosition( 417 ),
                              new ViolationPosition( 418 ),
                              new ViolationPosition( 420 ),
                              new ViolationPosition( 421 ),
                              new ViolationPosition( 592 ),
                              new ViolationPosition( 595 ),
                              new ViolationPosition( 597 ),
                              new ViolationPosition( 617 ),
                              new ViolationPosition( 618 ),
                              new ViolationPosition( 619 ),
                              new ViolationPosition( 620 ) } ),
                  new ExpectedViolation( "RadonDataGrid.as", new ViolationPosition[]
                  { new ViolationPosition( 188 ) } ) };
   }

   @Override
   protected AbstractFlexRule getRule()
   {
      return new AvoidDeclarationInLoopRule();
   }
}
