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
package com.adobe.ac.pmd.rules.architecture;

import com.adobe.ac.pmd.rules.core.AbstractAstFlexRuleTest;
import com.adobe.ac.pmd.rules.core.AbstractFlexRule;
import com.adobe.ac.pmd.rules.core.ViolationPosition;

public class UseInternalClassOutsideApiClassTest extends AbstractAstFlexRuleTest
{
   @Override
   protected ExpectedViolation[] getExpectedViolatingFiles()
   {
      return new ExpectedViolation[]
      { new ExpectedViolation( "functional.func2.restricted.Func2RestrictedClass.as", new ViolationPosition[]
       { new ViolationPosition( 22 ) } ),
                  new ExpectedViolation( "functional.func1.restricted.Func1RestrictedClass.as",
                                         new ViolationPosition[]
                                         { new ViolationPosition( 23 ) } ),
                  new ExpectedViolation( "functional.func2.api.Func2ExposedClass.as", new ViolationPosition[]
                  { new ViolationPosition( 22 ) } ),
                  new ExpectedViolation( "functional.func1.api.Func1ExposedClass.as", new ViolationPosition[]
                  { new ViolationPosition( 24 ) } ),
                  new ExpectedViolation( "functional.FunctionalClient.as", new ViolationPosition[]
                  { new ViolationPosition( 22 ),
                              new ViolationPosition( 24 ) } ) };
   }

   @Override
   protected AbstractFlexRule getRule()
   {
      return new UseInternalClassOutsideApiClass();
   }
}