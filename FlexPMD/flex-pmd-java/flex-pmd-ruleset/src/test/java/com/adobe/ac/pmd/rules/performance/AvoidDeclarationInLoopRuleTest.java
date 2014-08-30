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
       { new ViolationPosition( 2326 ) } ),
                  new ExpectedViolation( "bug.FlexPMD88.as", new ViolationPosition[]
                  { new ViolationPosition( 36 ) } ),
                  new ExpectedViolation( "com.adobe.ac.ncss.mxml.IterationsList.mxml",
                                         new ViolationPosition[]
                                         { new ViolationPosition( 39 ),
                                                     new ViolationPosition( 50 ),
                                                     new ViolationPosition( 62 ) } ),
                  new ExpectedViolation( "com.adobe.ac.ncss.TestResult.as", new ViolationPosition[]
                  { new ViolationPosition( 123 ),
                              new ViolationPosition( 137 ) } ),
                  new ExpectedViolation( "Looping.as", new ViolationPosition[]
                  { new ViolationPosition( 51 ) } ),
                  new ExpectedViolation( "PngEncoder.as", new ViolationPosition[]
                  { new ViolationPosition( 188 ),
                              new ViolationPosition( 207 ),
                              new ViolationPosition( 323 ),
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
                              new ViolationPosition( 341 ),
                              new ViolationPosition( 351 ),
                              new ViolationPosition( 352 ),
                              new ViolationPosition( 353 ),
                              new ViolationPosition( 354 ),
                              new ViolationPosition( 356 ),
                              new ViolationPosition( 357 ),
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
                              new ViolationPosition( 383 ),
                              new ViolationPosition( 388 ),
                              new ViolationPosition( 398 ),
                              new ViolationPosition( 399 ),
                              new ViolationPosition( 400 ),
                              new ViolationPosition( 401 ),
                              new ViolationPosition( 403 ),
                              new ViolationPosition( 404 ),
                              new ViolationPosition( 575 ),
                              new ViolationPosition( 578 ),
                              new ViolationPosition( 580 ),
                              new ViolationPosition( 600 ),
                              new ViolationPosition( 601 ),
                              new ViolationPosition( 602 ),
                              new ViolationPosition( 603 ) } ),
                  new ExpectedViolation( "RadonDataGrid.as", new ViolationPosition[]
                  { new ViolationPosition( 176 ) } ) };
   }

   @Override
   protected AbstractFlexRule getRule()
   {
      return new AvoidDeclarationInLoopRule();
   }
}
