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

import java.util.List;

import com.adobe.ac.pmd.rules.core.AbstractAstFlexRuleTest;
import com.adobe.ac.pmd.rules.core.AbstractFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPosition;
import org.junit.Ignore;

@Ignore("This test requires test-data that was not donated to Apache")
public class VariableNameEndingWithNumericRuleTest extends AbstractAstFlexRuleTest
{
   @Override
   protected ExpectedViolation[] getExpectedViolatingFiles()
   {
      return new ExpectedViolation[]
      { new ExpectedViolation( "PngEncoder.as", new ViolationPosition[]
       { new ViolationPosition( 388 ),
                   new ViolationPosition( 424 ),
                   new ViolationPosition( 442 ) } ),
                  new ExpectedViolation( "src.epg.StateExit_AS2.as", new ViolationPosition[]
                  { new ViolationPosition( 62 ),
                              new ViolationPosition( 63 ),
                              new ViolationPosition( 69 ),
                              new ViolationPosition( 70 ),
                              new ViolationPosition( 71 ),
                              new ViolationPosition( 60 ) } ),
                  new ExpectedViolation( "com.adobe.ac.ncss.BigModel.as", new ViolationPosition[]
                  { new ViolationPosition( 82 ),
                              new ViolationPosition( 86 ),
                              new ViolationPosition( 90 ),
                              new ViolationPosition( 94 ),
                              new ViolationPosition( 98 ) } ),
                  new ExpectedViolation( "cairngorm.LightController.as", new ViolationPosition[]
                  { new ViolationPosition( 115 ),
                              new ViolationPosition( 134 ),
                              new ViolationPosition( 153 ),
                              new ViolationPosition( 172 ),
                              new ViolationPosition( 191 ) } ),
                  new ExpectedViolation( "com.adobe.ac.ncss.BigImporterModel.as", new ViolationPosition[]
                  { new ViolationPosition( 62 ),
                              new ViolationPosition( 62 ),
                              new ViolationPosition( 62 ),
                              new ViolationPosition( 62 ),
                              new ViolationPosition( 62 ),
                              new ViolationPosition( 64 ) } ) };
   }

   @Override
   protected List< String > getIgnoreFiles()
   {
      final List< String > files = super.getIgnoreFiles();

      files.add( "bug.FlexPMD181.as" );
      return files;
   }

   @Override
   protected AbstractFlexRule getRule()
   {
      return new VariableNameEndingWithNumericRule();
   }
}
