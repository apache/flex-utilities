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
package com.adobe.ac.pmd;

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;

import net.sourceforge.pmd.PMDException;

import org.junit.Test;

import com.adobe.ac.pmd.engines.FlexPmdXmlEngine;

public class AllInOneRulesetTest extends AbstractEntireRulesetTest
{
   @Test
   public void testLoadUncorrectRuleSet() throws URISyntaxException,
                                         PMDException,
                                         IOException
   {
      final File sourceDirectory = new File( getClass().getResource( "/test" ).toURI().getPath() );
      final File outputDirectory = new File( OUTPUT_DIRECTORY_URL );

      final FlexPmdXmlEngine engine = new FlexPmdXmlEngine( new FlexPmdParameters( "",
                                                                                   outputDirectory,
                                                                                   new File( "nonExist" ),
                                                                                   sourceDirectory ) );

      engine.executeReport( new FlexPmdViolations() );
   }

   @Override
   protected String getRuleSetPath()
   {
      return "/allInOneRuleset.xml";
   }

   @Override
   protected int getRulesNb()
   {
      return 43;
   }

   @Override
   protected int getViolatedFilesNb()
   {
      return 46;
   }
}
