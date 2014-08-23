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

import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.SchemaFactory;

import org.xml.sax.SAXException;

import com.adobe.ac.pmd.engines.AbstractFlexPmdEngine;
import com.adobe.ac.pmd.engines.AbstractTestFlexPmdEngineTest;
import com.adobe.ac.pmd.engines.FlexPMDFormat;
import com.adobe.ac.pmd.engines.FlexPmdXmlEngine;

public class FlexPmdXmlEngineTest extends AbstractTestFlexPmdEngineTest
{
   private static final String OUTPUT_DIRECTORY_URL = "target/report/";

   public FlexPmdXmlEngineTest( final String name )
   {
      super( name );
   }

   @Override
   protected AbstractFlexPmdEngine getFlexPmdEngine( final File sourceDirectory,
                                                     final File outputDirectory,
                                                     final String packageToExclude,
                                                     final File ruleSet ) throws URISyntaxException,
                                                                         IOException
   {
      return new FlexPmdXmlEngine( new FlexPmdParameters( packageToExclude,
                                                          outputDirectory,
                                                          ruleSet,
                                                          sourceDirectory ) );
   }

   @Override
   protected void onTestExecuteReportDone()
   {
      final File outXmlReport = new File( OUTPUT_DIRECTORY_URL
            + FlexPMDFormat.XML.toString() );

      final SchemaFactory factory = SchemaFactory.newInstance( "http://www.w3.org/2001/XMLSchema" );

      final URL schemaResource = getClass().getResource( "/pmd.xsd" );

      assertNotNull( "pmd.xsd is not loaded",
                     schemaResource );

      try
      {
         factory.newSchema( schemaResource ).newValidator().validate( new StreamSource( outXmlReport ) );
      }
      catch ( final SAXException e )
      {
         fail( e.getMessage() );
      }
      catch ( final IOException e )
      {
         fail( e.getMessage() );
      }
   }
}
