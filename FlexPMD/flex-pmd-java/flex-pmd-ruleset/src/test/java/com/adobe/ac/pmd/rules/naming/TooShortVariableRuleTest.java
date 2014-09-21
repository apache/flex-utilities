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

import com.adobe.ac.pmd.rules.core.AbstractRegExpBasedRuleTest;
import com.adobe.ac.pmd.rules.core.AbstractRegexpBasedRule;
import com.adobe.ac.pmd.rules.core.ViolationPosition;

public class TooShortVariableRuleTest extends AbstractRegExpBasedRuleTest
{
   @Override
   protected ExpectedViolation[] getExpectedViolatingFiles()
   {
      return new ExpectedViolation[]
      { new ExpectedViolation( "bug.Duane.mxml", new ViolationPosition[]
       { new ViolationPosition( 54 ) } ),
                  new ExpectedViolation( "bug.FlexPMD233b.mxml", new ViolationPosition[]
                  { new ViolationPosition( 88 ) } ),
                  new ExpectedViolation( "flexpmd114.a.Test.as", new ViolationPosition[]
                  { new ViolationPosition( 30 ) } ),
                  new ExpectedViolation( "flexpmd114.b.Test.as", new ViolationPosition[]
                  { new ViolationPosition( 30 ) } ),
                  new ExpectedViolation( "flexpmd114.c.Test.as", new ViolationPosition[]
                  { new ViolationPosition( 30 ) } ),
                  new ExpectedViolation( "PngEncoder.as", new ViolationPosition[]
                  { new ViolationPosition( 30 ) } ),
                  new ExpectedViolation( "Looping.as", new ViolationPosition[]
                  { new ViolationPosition( 51 ) } ) };
   }

   @Override
   protected String[] getMatchableLines()
   {
      return new String[]
      { "  var toto : int = 0;",
                  "  var i : int = 0;",
                  "var ii : int = 0;",
                  "var iii : int = 0;",
                  "for ( var i : int = 0; i < 10; i++ ){}" };
   }

   @Override
   protected AbstractRegexpBasedRule getRegexpBasedRule()
   {
      return new TooShortVariableRule();
   }

   @Override
   protected String[] getUnmatchableLines()
   {
      return new String[]
      { "function lala() : Number",
                  "lala();" };
   }
}
