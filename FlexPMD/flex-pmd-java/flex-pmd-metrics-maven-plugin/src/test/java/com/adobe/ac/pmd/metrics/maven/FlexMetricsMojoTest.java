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

import java.io.File;

import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugin.testing.stubs.MavenProjectStub;
import org.codehaus.doxia.site.renderer.DefaultSiteRenderer;
import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;

public class FlexMetricsMojoTest extends FlexPmdTestBase
{
   private static final String TEMP_FILE_NAME = "javancss-raw-report.xml";

   @Test
   public void executeReport() throws MojoExecutionException,
                              MojoFailureException
   {
      final MavenProjectStub project = new MavenProjectStub();
      final File outputDirectoryToBeSet = new File( project.getBasedir().getAbsolutePath()
            + "/target/pmd" );
      final FlexMetricsReportMojo reportMojo = new FlexMetricsReportMojo( project,
                                                                          getTestDirectory(),
                                                                          outputDirectoryToBeSet );
      final FlexMetricsMojo mojo = new FlexMetricsMojo( outputDirectoryToBeSet, getTestDirectory() );

      outputDirectoryToBeSet.mkdirs();
      reportMojo.setLineThreshold( 5 );
      reportMojo.setSiteRenderer( new DefaultSiteRenderer() );
      reportMojo.setXmlOutputDirectory( outputDirectoryToBeSet );
      reportMojo.setTempFileName( TEMP_FILE_NAME );
      reportMojo.execute();

      mojo.setXmlOutputDirectory( outputDirectoryToBeSet );
      mojo.setTempFileName( TEMP_FILE_NAME );
      mojo.setCcnLimit( 50 );
      mojo.setFailOnViolation( true );
      mojo.setNcssLimit( 200 );

      mojo.execute();
   }
}
