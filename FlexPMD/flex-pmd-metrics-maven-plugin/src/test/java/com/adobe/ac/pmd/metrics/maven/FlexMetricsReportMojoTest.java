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
package com.adobe.ac.pmd.metrics.maven;

import static org.junit.Assert.assertNotNull;

import java.io.File;
import java.util.Locale;

import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.testing.stubs.MavenProjectStub;
import org.codehaus.doxia.site.renderer.DefaultSiteRenderer;
import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;

public class FlexMetricsReportMojoTest extends FlexPmdTestBase
{
   @Test
   public void executeMultipleReport() throws MojoExecutionException
   {
      final MavenProjectStub project = new MavenProjectStub();
      final File outputDirectoryToBeSet = new File( project.getBasedir().getAbsolutePath()
            + "/target/pmd" );
      final FlexMetricsReportMojo mojo = new FlexMetricsReportMojo( project, null, outputDirectoryToBeSet );

      outputDirectoryToBeSet.mkdirs();
      mojo.addReactorProject( new MavenProjectStub() );
      mojo.addReactorProject( new MavenProjectStub() );
      mojo.setLineThreshold( 5 );
      mojo.setSiteRenderer( new DefaultSiteRenderer() );
      mojo.setXmlOutputDirectory( outputDirectoryToBeSet );
      mojo.setTempFileName( "javancss-raw-report.xml" );

      assertNotNull( "",
                     mojo.getName( Locale.ENGLISH ) );

      mojo.execute();
   }

   @Test
   public void executeSingleReport() throws MojoExecutionException
   {
      final File outputDirectoryToBeSet = new File( "target/pmd" );

      outputDirectoryToBeSet.mkdirs();

      final FlexMetricsReportMojo mojo = new FlexMetricsReportMojo( new MavenProjectStub(),
                                                                    getTestDirectory(),
                                                                    outputDirectoryToBeSet );

      mojo.setLineThreshold( 5 );
      mojo.setSiteRenderer( new DefaultSiteRenderer() );
      mojo.setXmlOutputDirectory( outputDirectoryToBeSet );
      mojo.setTempFileName( "javancss-raw-report.xml" );

      assertNotNull( "",
                     mojo.getName( Locale.ENGLISH ) );

      mojo.execute();
   }

   @Test
   public void executeSingleReportOnNonExistingFolder() throws MojoExecutionException
   {
      final File outputDirectoryToBeSet = new File( "target/pmd" );

      outputDirectoryToBeSet.mkdirs();

      final FlexMetricsReportMojo mojo = new FlexMetricsReportMojo( new MavenProjectStub(),
                                                                    new File( "nonExisting" ),
                                                                    outputDirectoryToBeSet );

      mojo.setLineThreshold( 5 );
      mojo.setSiteRenderer( new DefaultSiteRenderer() );
      mojo.setXmlOutputDirectory( outputDirectoryToBeSet );
      mojo.setTempFileName( "javancss-raw-report.xml" );

      assertNotNull( "",
                     mojo.getName( Locale.ENGLISH ) );

      mojo.execute();
   }
}
