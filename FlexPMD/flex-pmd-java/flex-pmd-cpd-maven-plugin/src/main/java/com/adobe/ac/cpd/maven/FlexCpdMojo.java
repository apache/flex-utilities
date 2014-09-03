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
package com.adobe.ac.cpd.maven;

import java.io.File;
import java.io.IOException;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.Map.Entry;

import net.sourceforge.pmd.PMDException;
import net.sourceforge.pmd.cpd.CPD;
import net.sourceforge.pmd.cpd.FileReporter;
import net.sourceforge.pmd.cpd.Renderer;
import net.sourceforge.pmd.cpd.ReportException;
import net.sourceforge.pmd.cpd.XMLRenderer;

import org.apache.maven.project.MavenProject;
import org.apache.maven.reporting.AbstractMavenReport;
import org.apache.maven.reporting.MavenReportException;
import org.codehaus.doxia.site.renderer.SiteRenderer;

import com.adobe.ac.cpd.FlexLanguage;
import com.adobe.ac.pmd.LoggerUtils;
import com.adobe.ac.pmd.files.IFlexFile;
import com.adobe.ac.pmd.files.impl.FileUtils;

/**
 * @author xagnetti
 * @goal check
 * @phase verify
 */
public class FlexCpdMojo extends AbstractMavenReport
{
   private static final String OUTPUT_NAME = "cpd";

   protected static ResourceBundle getBundle( final Locale locale )
   {
      return ResourceBundle.getBundle( "flexPmd",
                                       locale,
                                       FlexCpdMojo.class.getClassLoader() ); // NOPMD
   }

   private final String encoding = System.getProperty( "file.encoding" );

   /**
    * Location of the file.
    * 
    * @parameter expression="25"
    * @required
    */
   private int          minimumTokenCount;

   /**
    * Location of the file.
    * 
    * @parameter expression="${project.build.directory}"
    * @required
    */
   private File         outputDirectory;

   /**
    * @parameter expression="${project}"
    * @required
    * @readonly
    */
   private MavenProject project;

   /**
    * @parameter 
    *            expression="${component.org.codehaus.doxia.site.renderer.SiteRenderer}"
    * @required
    * @readonly
    */
   private SiteRenderer siteRenderer;

   /**
    * Specifies the location of the source files to be used.
    * 
    * @parameter expression="${project.build.sourceDirectory}"
    * @required
    * @readonly
    */
   private File         sourceDirectory;

   public FlexCpdMojo()
   {
      super();
   }

   public FlexCpdMojo( final File outputDirectoryToBeSet,
                       final File sourceDirectoryToBeSet,
                       final MavenProject projectToBeSet )
   {
      super();
      outputDirectory = outputDirectoryToBeSet;
      sourceDirectory = sourceDirectoryToBeSet;
      project = projectToBeSet;
      minimumTokenCount = 25;
   }

   public String getDescription( final Locale locale )
   {
      return getBundle( locale ).getString( "report.flexCpd.description" );
   }

   public final String getName( final Locale locale )
   {
      return getBundle( locale ).getString( "report.flexCpd.name" );
   }

   public final String getOutputName()
   {
      return OUTPUT_NAME;
   }

   void setSiteRenderer( final SiteRenderer site )
   {
      siteRenderer = site;
   }

   @Override
   protected void executeReport( final Locale locale ) throws MavenReportException
   {
      new LoggerUtils().loadConfiguration();

      final CPD cpd = new CPD( minimumTokenCount, new FlexLanguage() );

      try
      {
         final Map< String, IFlexFile > files = FileUtils.computeFilesList( sourceDirectory,
                                                                            null,
                                                                            "",
                                                                            null );

         for ( final Entry< String, IFlexFile > fileEntry : files.entrySet() )
         {
            cpd.add( new File( fileEntry.getValue().getFilePath() ) ); // NOPMD
         }

         cpd.go();

         report( cpd );
      }
      catch ( final PMDException e )
      {
         throw new MavenReportException( "", e );
      }
      catch ( final IOException e )
      {
         throw new MavenReportException( "", e );
      }
      catch ( final ReportException e )
      {
         throw new MavenReportException( "", e );
      }
   }

   @Override
   protected String getOutputDirectory()
   {
      return outputDirectory.getAbsolutePath();
   }

   @Override
   protected MavenProject getProject()
   {
      return project;
   }

   @Override
   protected SiteRenderer getSiteRenderer()
   {
      return siteRenderer;
   }

   private void report( final CPD cpd ) throws ReportException
   {
      final Renderer renderer = new XMLRenderer( encoding );
      final FileReporter reporter = new FileReporter( new File( outputDirectory.getAbsolutePath(),
                                                                OUTPUT_NAME
                                                                      + ".xml" ), encoding );
      reporter.report( renderer.render( cpd.getMatches() ) );
   }

}
