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
package com.adobe.ac.pmd.rules.unused;

import com.adobe.ac.pmd.rules.core.AbstractAstFlexRuleTest;
import com.adobe.ac.pmd.rules.core.AbstractFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPosition;
import org.junit.Ignore;

@Ignore("This test requires test-data that was not donated to Apache")
public class UnusedLocalVariableRuleTest extends AbstractAstFlexRuleTest
{
   @Override
   protected ExpectedViolation[] getExpectedViolatingFiles()
   {
      return new ExpectedViolation[]
      { new ExpectedViolation( "src.epg.StateExit_AS2.as", new ViolationPosition[]
       { new ViolationPosition( 62 ),
                   new ViolationPosition( 63 ),
                   new ViolationPosition( 67 ),
                   new ViolationPosition( 68 ),
                   new ViolationPosition( 69 ),
                   new ViolationPosition( 70 ),
                   new ViolationPosition( 71 ),
                   new ViolationPosition( 72 ),
                   new ViolationPosition( 73 ),
                   new ViolationPosition( 74 ),
                   new ViolationPosition( 75 ),
                   new ViolationPosition( 76 ),
                   new ViolationPosition( 77 ) } ),
                  new ExpectedViolation( "DeleteButtonRenderer.mxml", new ViolationPosition[]
                  { new ViolationPosition( 69 ) } ),
                  new ExpectedViolation( "com.adobe.ac.ncss.VoidConstructor.as", new ViolationPosition[]
                  { new ViolationPosition( 40 ) } ),
                  new ExpectedViolation( "RadonDataGrid.as", new ViolationPosition[]
                  { new ViolationPosition( 100 ),
                              new ViolationPosition( 101 ) } ),
                  new ExpectedViolation( "com.adobe.ac.ncss.BigModel.as", new ViolationPosition[]
                  { new ViolationPosition( 47 ) } ),
                  new ExpectedViolation( "UnboundMetadata.as", new ViolationPosition[]
                  { new ViolationPosition( 50 ) } ),
                  new ExpectedViolation( "com.adobe.ac.ncss.BigImporterModel.as", new ViolationPosition[]
                  { new ViolationPosition( 64 ) } ),
                  new ExpectedViolation( "GenericType.as", new ViolationPosition[]
                  { new ViolationPosition( 46 ) } ),
                  new ExpectedViolation( "ErrorToltipSkin.as", new ViolationPosition[]
                  { new ViolationPosition( 163 ),
                              new ViolationPosition( 165 ),
                              new ViolationPosition( 166 ),
                              new ViolationPosition( 183 ),
                              new ViolationPosition( 184 ) } ),
                  new ExpectedViolation( "bug.Duane.mxml", new ViolationPosition[]
                  { new ViolationPosition( 68 ) } ),
                  new ExpectedViolation( "bug.FlexPMD88.as", new ViolationPosition[]
                  { new ViolationPosition( 42 ),
                              new ViolationPosition( 43 ),
                              new ViolationPosition( 44 ),
                              new ViolationPosition( 45 ) } ),
                  new ExpectedViolation( "flexpmd114.a.Test.as", new ViolationPosition[]
                  { new ViolationPosition( 42 ) } ),
                  new ExpectedViolation( "flexpmd114.b.Test.as", new ViolationPosition[]
                  { new ViolationPosition( 42 ) } ),
                  new ExpectedViolation( "flexpmd114.c.Test.as", new ViolationPosition[]
                  { new ViolationPosition( 42 ) } ) };
   }

   @Override
   protected AbstractFlexRule getRule()
   {
      return new UnusedLocalVariableRule();
   }
}
