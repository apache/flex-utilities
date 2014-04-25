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
package com.adobe.ac.pmd.engines;

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;

import junit.framework.TestCase;
import net.sourceforge.pmd.PMDException;

import org.junit.Test;
import org.xml.sax.SAXException;

import com.adobe.ac.pmd.FlexPmdViolations;

public abstract class AbstractTestFlexPmdEngineTest extends TestCase
{
   private static final String OUTPUT_DIRECTORY_URL = "target/report/";

   public AbstractTestFlexPmdEngineTest( final String name )
   {
      super( name );
   }

   @Test
   public final void testExecuteReport() throws PMDException,
                                        SAXException,
                                        URISyntaxException,
                                        IOException
   {
      final URL sourceDirectoryResource = getClass().getResource( "/test" );

      assertNotNull( "Source directory is not found as a resource",
                     sourceDirectoryResource );

      assertNotNull( "Source directory is not found as a resource",
                     sourceDirectoryResource.toURI() );

      final File sourceDirectory = new File( sourceDirectoryResource.toURI().getPath() );
      final File outputDirectory = new File( OUTPUT_DIRECTORY_URL );

      getFlexPmdEngine( sourceDirectory,
                        outputDirectory,
                        "",
                        null ).executeReport( new FlexPmdViolations() );

      onTestExecuteReportDone();
   }

   protected abstract AbstractFlexPmdEngine getFlexPmdEngine( final File sourceDirectory,
                                                              final File outputDirectory,
                                                              final String packageToExclude,
                                                              final File ruleSet ) throws URISyntaxException,
                                                                                  IOException;

   protected abstract void onTestExecuteReportDone();
}