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
package com.adobe.ac.pmd.rules.core;

import static org.junit.Assert.assertEquals;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.IFlexViolation;
import com.adobe.ac.pmd.rules.core.AbstractFlexRuleTest.AssertPosition;

public class EmptyRuleTest extends FlexPmdTestBase
{
   @Test
   public void addViolationEmptyRule()
   {
      final List< IFlexViolation > violatons = new EmptyRule().processFile( null,
                                                                            null,
                                                                            null );

      assertEquals( 1,
                    violatons.size() );

      final IFlexViolation firstViolation = violatons.get( 0 );

      assertEquals( 0,
                    firstViolation.getBeginLine() );
      assertEquals( 0,
                    firstViolation.getEndLine() );
      assertEquals( "emptyMessage. description",
                    firstViolation.getRuleMessage() );
   }

   @Test
   public void addViolationWarningRule()
   {
      final List< IFlexViolation > violatons = new WarningRule().processFile( null,
                                                                              null,
                                                                              null );

      assertEquals( 1,
                    violatons.size() );

      final IFlexViolation firstViolation = violatons.get( 0 );

      assertEquals( 0,
                    firstViolation.getBeginLine() );
      assertEquals( 0,
                    firstViolation.getEndLine() );
      assertEquals( "warning message",
                    firstViolation.getRuleMessage() );
   }

   @Test
   public void testBuildFailuresMessage()
   {
      final ArrayList< AssertPosition > position = new ArrayList< AssertPosition >();

      position.add( AssertPosition.create( "message",
                                           1,
                                           2 ) );

      assertEquals( "message: expected <1> but actually <2>\n",
                    AbstractFlexRuleTest.buildFailuresMessage( position ).toString() );
   }

   @Test
   public void testBuildFailureViolations()
   {
      final ViolationPosition[] expectedPositions = new ViolationPosition[]
      { new ViolationPosition( 0 ) };
      final ArrayList< IFlexViolation > violations = new ArrayList< IFlexViolation >();

      violations.add( new Violation( new ViolationPosition( 1 ), new EmptyRule(), null ) );

      final List< AssertPosition > positions = AbstractFlexRuleTest.buildFailureViolations( "",
                                                                                            expectedPositions,
                                                                                            violations );

      assertEquals( 2,
                    positions.size() );
      assertEquals( "Begining line is not correct at 0th violation on ",
                    positions.get( 0 ).message );
      assertEquals( "Ending line is not correct at 0th violation on ",
                    positions.get( 1 ).message );
   }

   @Test
   public void testBuildMessageName()
   {
      final Map< String, List< IFlexViolation >> violatedFiles = new LinkedHashMap< String, List< IFlexViolation > >();
      final ArrayList< IFlexViolation > emptyList = new ArrayList< IFlexViolation >();

      violatedFiles.put( "file1",
                         emptyList );

      violatedFiles.put( "file2",
                         emptyList );

      assertEquals( "file1 should not contain any violations  (0 found)\n"
                          + "file2 should not contain any violations  (0 found)\n",
                    AbstractFlexRuleTest.buildMessageName( violatedFiles ).toString() );

      final ArrayList< IFlexViolation > oneItemList = new ArrayList< IFlexViolation >();

      oneItemList.add( new Violation( new ViolationPosition( 0 ), new EmptyRule(), null ) );
      violatedFiles.put( "file2",
                         oneItemList );

      assertEquals( "file1 should not contain any violations  (0 found)\n"
                          + "file2 should not contain any violations  (1 found at 0:0)\n",
                    AbstractFlexRuleTest.buildMessageName( violatedFiles ).toString() );
   }
}
