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
package com.adobe.ac.pmd.maven;

import static org.junit.Assert.assertNotNull;

import java.io.File;
import java.util.Locale;
import java.util.ResourceBundle;

import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.testing.stubs.MavenProjectStub;
import org.codehaus.doxia.site.renderer.DefaultSiteRenderer;
import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdParameters;
import com.adobe.ac.pmd.FlexPmdTestBase;

public class FlexPmdReportMojoTest extends FlexPmdTestBase
{
   @Test
   public void testExecuteReport() throws MojoExecutionException
   {
      new File( "target/site" ).mkdirs();
      final FlexPmdReportMojo mojo = new FlexPmdReportMojo( new MavenProjectStub(),
                                                            new FlexPmdParameters( "",
                                                                                   false,
                                                                                   false,
                                                                                   new File( "target" ),
                                                                                   null,
                                                                                   getTestDirectory() ) );

      mojo.setSiteRenderer( new DefaultSiteRenderer() );
      assertNotNull( "",
                     mojo.getName( Locale.ENGLISH ) );

      mojo.execute();
   }

   @Test
   public void testExecuteReportOnNoViolationsSourcePath() throws MojoExecutionException
   {
      new File( "target/site" ).mkdirs();
      final FlexPmdReportMojo mojo = new FlexPmdReportMojo( new MavenProjectStub(),
                                                            new FlexPmdParameters( "",
                                                                                   false,
                                                                                   false,
                                                                                   new File( "target" ),
                                                                                   null,
                                                                                   new File( getTestDirectory().getAbsoluteFile()
                                                                                         + "/fu" ) ) );

      mojo.setSiteRenderer( new DefaultSiteRenderer() );
      assertNotNull( "",
                     mojo.getName( Locale.ENGLISH ) );

      mojo.execute();
   }

   @Test
   public void testGetBundle()
   {
      final Locale[] availableLocales = Locale.getAvailableLocales();
      final ResourceBundle bundle = AbstractFlexPmdMojo.getBundle( availableLocales[ 0 ] );
      final ResourceBundle englishBundle = AbstractFlexPmdMojo.getBundle( Locale.ENGLISH );

      assertNotNull( "",
                     bundle );
      assertNotNull( "",
                     englishBundle );
   }
}
