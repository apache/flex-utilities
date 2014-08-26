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
import static org.junit.Assert.fail;

import java.io.File;
import java.net.URL;
import java.util.Locale;

import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.testing.stubs.MavenProjectStub;
import org.codehaus.doxia.site.renderer.DefaultSiteRenderer;
import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdParameters;
import com.adobe.ac.pmd.FlexPmdTestBase;

public class FlexPmdMojoTest extends FlexPmdTestBase
{
   @Test
   public void testExecuteReport()
   {
      executeReport( false,
                     null );
   }

   @Test
   public void testExecuteReportFailOnError()
   {
      executeReport( true,
                     null );
   }

   @Test
   public void testExecuteReportWithCustomRuleset()
   {
      final URL resource = this.getClass().getResource( "/rulesets/broken_pmd.xml" );
      executeReport( true,
                     new File( resource.getFile() ) );
   }

   private void executeReport( final boolean failOnError,
                               final File ruleset )
   {
      final File outputDirectoryToBeSet = new File( "target/pmd" );

      outputDirectoryToBeSet.mkdirs();

      final FlexPmdMojo mojo = new FlexPmdMojo( new MavenProjectStub(),
                                                new FlexPmdParameters( "",
                                                                       failOnError,
                                                                       false,
                                                                       outputDirectoryToBeSet,
                                                                       ruleset,
                                                                       getTestDirectory() ) );

      mojo.setSiteRenderer( new DefaultSiteRenderer() );
      assertNotNull( "",
                     mojo.getName( Locale.ENGLISH ) );

      try
      {
         mojo.execute();
         if ( failOnError )
         {
            fail( "One expection should have been thrown" );
         }
      }
      catch ( final MojoExecutionException e )
      {
         if ( !failOnError )
         {
            fail( "No expections should have been thrown" );
         }
      }
      finally
      {
         new File( "target/pmd.xml" ).delete();
      }
   }
}
