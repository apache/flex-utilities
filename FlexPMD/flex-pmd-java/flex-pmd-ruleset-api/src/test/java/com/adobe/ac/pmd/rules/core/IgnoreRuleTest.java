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

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.util.List;

import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.IFlexViolation;
import com.adobe.ac.pmd.files.IFlexFile;

public class IgnoreRuleTest extends FlexPmdTestBase
{
   private class IgnoredRule extends AbstractFlexRule
   {
      private final IFlexFile currentFile;

      protected IgnoredRule( final IFlexFile file )
      {
         super();
         currentFile = file;
      }

      @Override
      public String getName()
      {
         return "com.adobe.ac.Ignored";
      }

      @Override
      protected List< IFlexViolation > findViolationsInCurrentFile()
      {
         return null;
      }

      @Override
      protected IFlexFile getCurrentFile()
      {
         return currentFile;
      }

      @Override
      protected ViolationPriority getDefaultPriority()
      {
         return ViolationPriority.LOW;
      }

      @Override
      protected boolean isConcernedByTheCurrentFile()
      {
         return true;
      }
   }
   private static final String AS3_LINE  = "var i : int;";
   private static final String MXML_LINE = "addedToStage=\"callLater( myFunction )\"";

   private final IgnoredRule   ruleWithAsFile;
   private final IgnoredRule   ruleWithMxmlFile;

   public IgnoreRuleTest()
   {
      ruleWithAsFile = new IgnoredRule( getTestFiles().get( "AbstractRowData.as" ) );
      ruleWithMxmlFile = new IgnoredRule( getTestFiles().get( "Main.mxml" ) );
   }

   @Test
   public final void testIsViolationIgnored()
   {
      isIgnored( " NO PMD" );
   }

   @Test
   public final void testIsViolationIgnoredCollapsed()
   {
      isIgnored( " NOPMD" );
   }

   @Test
   public final void testIsViolationIgnoredWithFullCollapsed()
   {
      isIgnored( "NOPMD" );
   }

   @Test
   public final void testIsViolationIgnoredWithLowerCase()
   {
      isIgnored( " No PMD" );
   }

   private void isIgnored( final String noPmd )
   {
      assertTrue( ruleWithAsFile.isViolationIgnored( AS3_LINE
            + " //" + noPmd ) );
      assertFalse( ruleWithAsFile.isViolationIgnored( AS3_LINE
            + " //" + noPmd + " AlertShow" ) );
      assertTrue( ruleWithAsFile.isViolationIgnored( AS3_LINE
            + " //" + noPmd + " IgnoreTest$Ignored" ) );
      assertTrue( ruleWithAsFile.isViolationIgnored( AS3_LINE
            + " //" + noPmd + " adobe.ac.pmd.rules.core.IgnoreTest$Ignored" ) );
      assertFalse( ruleWithAsFile.isViolationIgnored( AS3_LINE ) );
      assertTrue( ruleWithMxmlFile.isViolationIgnored( MXML_LINE
            + " <!--" + noPmd ) );
      assertFalse( ruleWithMxmlFile.isViolationIgnored( MXML_LINE
            + " <!--" + noPmd + " AlertShow" ) );
      assertTrue( ruleWithMxmlFile.isViolationIgnored( MXML_LINE
            + " <!--" + noPmd + " IgnoreTest$Ignored" ) );
      assertTrue( ruleWithMxmlFile.isViolationIgnored( MXML_LINE
            + " <!--" + noPmd + " adobe.ac.pmd.rules.core.IgnoreTest$Ignored" ) );
      assertFalse( ruleWithMxmlFile.isViolationIgnored( MXML_LINE ) );
   }
}
