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
import java.net.URL;

import net.sourceforge.pmd.PMDException;

import org.junit.Test;

import com.adobe.ac.pmd.engines.FlexPmdXmlEngine;

import junit.framework.TestCase;

public abstract class AbstractEntireRulesetTest extends TestCase
{

   protected static final String OUTPUT_DIRECTORY_URL = "target/report/";

   public AbstractEntireRulesetTest()
   {
      super();
   }

   protected abstract int getRulesNb();

   protected abstract int getViolatedFilesNb();

   protected abstract String getRuleSetPath();

   public AbstractEntireRulesetTest( String name )
   {
      super( name );
   }

   @Test
   public void testLoadRuleSet() throws URISyntaxException,
                                   PMDException,
                                   IOException
   {
      final File sourceDirectory = new File( getClass().getResource( "/test" ).toURI().getPath() );
      final URL ruleSetUrl = getClass().getResource( getRuleSetPath() );
   
      assertNotNull( "RuleSet has not been found",
                     ruleSetUrl );
   
      assertNotNull( "RuleSet has not been found",
                     ruleSetUrl.toURI() );
   
      assertNotNull( "RuleSet has not been found",
                     ruleSetUrl.toURI().getPath() );
   
      final File outputDirectory = new File( OUTPUT_DIRECTORY_URL );
      final File ruleSetFile = new File( ruleSetUrl.toURI().getPath() );
      final FlexPmdXmlEngine engine = new FlexPmdXmlEngine( new FlexPmdParameters( "",
                                                                                   outputDirectory,
                                                                                   ruleSetFile,
                                                                                   sourceDirectory ) );
      final FlexPmdViolations flexPmdViolations = new FlexPmdViolations();
   
      engine.executeReport( flexPmdViolations );
   
      assertEquals( "Number of rules found is not correct",
                    getRulesNb(),
                    engine.getRuleSet().size() );
      assertEquals( getViolatedFilesNb(),
                    flexPmdViolations.getViolations().size() );
   }

}