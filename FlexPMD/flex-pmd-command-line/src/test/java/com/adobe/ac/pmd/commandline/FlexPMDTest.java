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
package com.adobe.ac.pmd.commandline;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URISyntaxException;

import junit.framework.Assert;
import net.sourceforge.pmd.PMDException;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.io.SAXReader;
import org.junit.Test;

import com.adobe.ac.pmd.CommandLineOptions;
import com.adobe.ac.pmd.FlexPmdTestBase;
import com.martiansoftware.jsap.JSAPException;

public class FlexPMDTest extends FlexPmdTestBase
{
   @Test
   public void testAreCommandLineOptionsCorrect() throws FileNotFoundException,
                                                 JSAPException,
                                                 PMDException,
                                                 URISyntaxException
   {
      assertFalse( FlexPMD.areCommandLineOptionsCorrect( new String[]
      {} ) );

      assertFalse( FlexPMD.areCommandLineOptionsCorrect( new String[]
      { "-y",
                  "sourceDirectory",
                  "-p",
                  "outPutDirectory" } ) );

      assertTrue( FlexPMD.areCommandLineOptionsCorrect( new String[]
      { "-s",
                  "sourceDirectory",
                  "-o",
                  "target",
                  "-r",
                  "valid.xml" } ) );

      assertTrue( FlexPMD.areCommandLineOptionsCorrect( new String[]
      { "-s",
                  "sourceDirectory",
                  "-o",
                  "target" } ) );
   }

   @Test
   public void testFlexPMD114() throws JSAPException,
                               PMDException,
                               URISyntaxException,
                               IOException,
                               DocumentException
   {
      final String[] args = new String[]
      { "-s",
                  getTestDirectory().getAbsolutePath()
                        + File.separatorChar + "flexpmd114",
                  "-o",
                  new File( "target/test2" ).getAbsolutePath() };

      FlexPMD.startFlexPMD( args );

      assertEquals( 3,
                    loadDocument( new File( "target/test2/pmd.xml" ) ).selectNodes( "//pmd/file" ).size() );
   }

   @Test
   public void testFlexPMD88() throws JSAPException,
                              PMDException,
                              URISyntaxException,
                              IOException,
                              DocumentException
   {
      final String[] args = new String[]
      { "-s",
                  getTestDirectory().getAbsolutePath()
                        + File.separatorChar + "bug" + File.separatorChar + "FlexPMD88.as",
                  "-o",
                  new File( "target/test3" ).getAbsolutePath() };

      FlexPMD.startFlexPMD( args );

      Assert.assertTrue( loadDocument( new File( "target/test3/pmd.xml" ) ).selectNodes( "//pmd/file[1]/violation" )
                                                                           .size() > 0 );
   }

   @Test
   public void testGetCommandLineValue() throws JSAPException
   {
      FlexPMD.areCommandLineOptionsCorrect( new String[]
      { "-s",
                  "sourceDirectory",
                  "-o",
                  "target",
                  "-r",
                  "valid.xml" } );

      assertEquals( "sourceDirectory",
                    FlexPMD.getParameterValue( CommandLineOptions.SOURCE_DIRECTORY ) );
      assertEquals( "target",
                    FlexPMD.getParameterValue( CommandLineOptions.OUTPUT ) );
      assertEquals( "valid.xml",
                    FlexPMD.getParameterValue( CommandLineOptions.RULE_SET ) );
   }

   @Test
   public void testStartFlexPMD() throws JSAPException,
                                 PMDException,
                                 URISyntaxException,
                                 IOException
   {
      final String[] args = new String[]
      { "-s",
                  getTestDirectory().getAbsolutePath(),
                  "-o",
                  new File( "target/test" ).getAbsolutePath(),
                  "--excludePackage",
                  "cairngorm." };

      FlexPMD.startFlexPMD( args );
   }

   @Test
   public void testStartFlexPMDOnAFile() throws JSAPException,
                                        PMDException,
                                        URISyntaxException,
                                        IOException
   {
      final String filePath = getTestFiles().get( "AbstractRowData.as" ).getFilePath();

      final String[] args = new String[]
      { "-s",
                  filePath,
                  "-o",
                  new File( "target/test" ).getAbsolutePath(),
                  "--excludePackage",
                  "cairngorm." };

      FlexPMD.startFlexPMD( args );
   }

   @Test
   public void testStartFlexPMDOnSeveralFolders() throws JSAPException,
                                                 PMDException,
                                                 URISyntaxException,
                                                 IOException
   {
      final String[] args = new String[]
      { "-s",
                  new File( "target/test/bug" ).getAbsolutePath()
                        + "," + new File( "target/test/cairngorm" ).getAbsolutePath(),
                  "-o",
                  new File( "target/test" ).getAbsolutePath(), };

      FlexPMD.startFlexPMD( args );
   }

   private Document loadDocument( final File outputFile ) throws DocumentException
   {
      return new SAXReader().read( outputFile );
   }
}
