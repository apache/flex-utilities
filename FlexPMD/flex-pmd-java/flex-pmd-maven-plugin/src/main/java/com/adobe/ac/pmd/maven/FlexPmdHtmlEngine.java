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

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;
import java.util.ResourceBundle;

import net.sourceforge.pmd.PMDException;
import net.sourceforge.pmd.Report;
import net.sourceforge.pmd.RuleContext;
import net.sourceforge.pmd.renderers.HTMLRenderer;

import org.apache.maven.plugin.pmd.PmdFileInfo;
import org.apache.maven.plugin.pmd.PmdReportListener;
import org.apache.maven.project.MavenProject;
import org.codehaus.doxia.sink.Sink;

import com.adobe.ac.pmd.FlexPmdParameters;
import com.adobe.ac.pmd.FlexPmdViolations;
import com.adobe.ac.pmd.IFlexViolation;
import com.adobe.ac.pmd.engines.AbstractFlexPmdEngine;
import com.adobe.ac.pmd.engines.FlexPMDFormat;
import com.adobe.ac.pmd.files.IFlexFile;

class FlexPmdHtmlEngine extends AbstractFlexPmdEngine
{
   private final boolean        aggregate;
   private final ResourceBundle bundle;
   private final MavenProject   project;
   private final Sink           sink;

   protected FlexPmdHtmlEngine( final Sink sinkToBeSet,
                                final ResourceBundle bundleToBeSet,
                                final boolean aggregateToBeSet,
                                final MavenProject projectToBeSet,
                                final FlexPmdParameters parameters )
   {
      super( parameters );

      sink = sinkToBeSet;
      bundle = bundleToBeSet;
      aggregate = aggregateToBeSet;
      project = projectToBeSet;
   }

   @Override
   protected final void writeReport( final FlexPmdViolations pmd ) throws PMDException
   {
      writeReport( getOutputDirectory(),
                   computeReport( pmd ) );
   }

   private Report computeReport( final FlexPmdViolations pmd )
   {
      final Report report = new Report();
      final RuleContext ruleContext = new RuleContext();
      final PmdReportListener reportSink = new PmdReportListener( sink, bundle, aggregate );

      report.addListener( reportSink );
      ruleContext.setReport( report );
      reportSink.beginDocument();
      report.start();

      for ( final IFlexFile file : pmd.getViolations().keySet() )
      {
         final File javaFile = new File( file.getFilePath() ); // NOPMD
         final List< IFlexViolation > violations = pmd.getViolations().get( file );

         reportSink.beginFile( javaFile,
                               new PmdFileInfo( project, javaFile.getParentFile(), "" ) ); // NOPMD
         ruleContext.setSourceCodeFilename( file.getPackageName()
               + "." + file.getClassName() );

         for ( final IFlexViolation violation : violations )
         {
            report.addRuleViolation( violation );
            reportSink.ruleViolationAdded( violation );
         }
         reportSink.endFile( javaFile );
      }

      reportSink.endDocument();
      report.end();

      return report;
   }

   private void writeReport( final File outputDirectory,
                             final Report report ) throws PMDException
   {
      final HTMLRenderer renderer = new HTMLRenderer( "", "" );

      try
      {
         final FileWriter fileWriter = new FileWriter( new File( outputDirectory.getAbsolutePath()
               + "/" + FlexPMDFormat.HTML.toString() ) );

         renderer.render( fileWriter,
                          report );
         renderer.getWriter().flush();
         fileWriter.close();
      }
      catch ( final IOException e )
      {
         throw new PMDException( "unable to write the HTML report", e );
      }
   }
}
