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
package com.adobe.ac.cpd.commandline;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URISyntaxException;

import net.sourceforge.pmd.PMDException;
import net.sourceforge.pmd.cpd.ReportException;

import org.junit.Test;

import com.adobe.ac.pmd.CommandLineOptions;
import com.adobe.ac.pmd.FlexPmdTestBase;
import com.martiansoftware.jsap.JSAPException;

public class FlexCPDTest extends FlexPmdTestBase
{
   @Test
   public void testAreCommandLineOptionsCorrect() throws FileNotFoundException,
                                                 JSAPException,
                                                 PMDException,
                                                 URISyntaxException
   {
      assertFalse( FlexCPD.areCommandLineOptionsCorrect( new String[]
      {} ) );

      assertFalse( FlexCPD.areCommandLineOptionsCorrect( new String[]
      { "-y",
                  "sourceDirectory",
                  "-p",
                  "outPutDirectory" } ) );

      assertTrue( FlexCPD.areCommandLineOptionsCorrect( new String[]
      { "-s",
                  "sourceDirectory",
                  "-o",
                  "target",
                  "-m",
                  "50" } ) );

      assertTrue( FlexCPD.areCommandLineOptionsCorrect( new String[]
      { "-s",
                  "sourceDirectory",
                  "-o",
                  "target" } ) );
   }

   @Test
   public void testGetCommandLineValue() throws JSAPException
   {
      FlexCPD.areCommandLineOptionsCorrect( new String[]
      { "-s",
                  "sourceDirectory",
                  "-o",
                  "target",
                  "-m",
                  "25" } );

      assertEquals( "sourceDirectory",
                    FlexCPD.getParameterValue( CommandLineOptions.SOURCE_DIRECTORY ) );
      assertEquals( "target",
                    FlexCPD.getParameterValue( CpdCommandLineOptions.OUTPUT_FILE ) );
      assertEquals( "25",
                    FlexCPD.getParameterValue( CpdCommandLineOptions.MINIMUM_TOKENS ) );
   }

   @Test
   public void testStartFlexCPD() throws JSAPException,
                                 PMDException,
                                 URISyntaxException,
                                 IOException,
                                 ReportException
   {
      final String[] args = new String[]
      { "-s",
                  getTestDirectory().getAbsolutePath(),
                  "-o",
                  new File( "target/cpd.xml" ).getAbsolutePath(),
                  "--excludePackage",
                  "cairngorm." };

      FlexCPD.startFlexCPD( args );
   }
}
