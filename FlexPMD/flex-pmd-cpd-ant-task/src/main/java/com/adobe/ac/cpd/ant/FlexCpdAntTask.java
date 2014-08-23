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
package com.adobe.ac.cpd.ant;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import net.sourceforge.pmd.cpd.CPD;
import net.sourceforge.pmd.cpd.FileReporter;
import net.sourceforge.pmd.cpd.Renderer;
import net.sourceforge.pmd.cpd.ReportException;
import net.sourceforge.pmd.cpd.XMLRenderer;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.DirectoryScanner;
import org.apache.tools.ant.Project;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.types.FileSet;

import com.adobe.ac.cpd.FlexLanguage;
import com.adobe.ac.cpd.FlexTokenizer;
import com.adobe.ac.pmd.LoggerUtils;

public class FlexCpdAntTask extends Task
{
   private String                encoding          = System.getProperty( "file.encoding" );
   private final List< FileSet > filesets          = new ArrayList< FileSet >();
   private int                   minimumTokenCount = FlexTokenizer.DEFAULT_MINIMUM_TOKENS;
   private File                  outputFile;

   public void addFileset( final FileSet set )
   {
      filesets.add( set );
   }

   @Override
   public void execute()
   {
      try
      {
         validateFields();
         new LoggerUtils().loadConfiguration();

         log( "Starting run, minimumTokenCount is "
                    + minimumTokenCount,
              Project.MSG_INFO );

         log( "Tokenizing files",
              Project.MSG_INFO );
         final CPD cpd = new CPD( minimumTokenCount, new FlexLanguage() );
         cpd.setEncoding( encoding );
         tokenizeFiles( cpd );

         log( "Starting to analyze code",
              Project.MSG_INFO );
         final long timeTaken = analyzeCode( cpd );
         log( "Done analyzing code; that took "
               + timeTaken + " milliseconds" );

         log( "Generating report",
              Project.MSG_INFO );
         report( cpd );
      }
      catch ( final IOException ioe )
      {
         log( ioe.toString(),
              Project.MSG_ERR );
         throw new BuildException( "IOException during task execution", ioe );
      }
      catch ( final ReportException re )
      {
         log( re.toString(),
              Project.MSG_ERR );
         throw new BuildException( "ReportException during task execution", re );
      }
   }

   public void setEncoding( final String encodingValue )
   {
      encoding = encodingValue;
   }

   public void setMinimumTokenCount( final int minimumTokenCountToBeSet )
   {
      minimumTokenCount = minimumTokenCountToBeSet;
   }

   public void setOutputFile( final File outputFileToBeSet )
   {
      outputFile = outputFileToBeSet;
   }

   private long analyzeCode( final CPD cpd )
   {
      final long start = System.currentTimeMillis();
      cpd.go();
      final long stop = System.currentTimeMillis();
      return stop
            - start;
   }

   private File getFile( final DirectoryScanner directoryScanner,
                         final String includedFile )
   {
      final File file = new File( directoryScanner.getBasedir()
            + System.getProperty( "file.separator" ) + includedFile );
      log( "Tokenizing "
                 + file.getAbsolutePath(),
           Project.MSG_VERBOSE );
      return file;
   }

   private void report( final CPD cpd ) throws ReportException
   {
      final Renderer renderer = new XMLRenderer( encoding );
      FileReporter reporter;
      if ( outputFile == null )
      {
         reporter = new FileReporter( encoding );
      }
      else if ( outputFile.isAbsolute() )
      {
         reporter = new FileReporter( outputFile, encoding );
      }
      else
      {
         reporter = new FileReporter( new File( getProject().getBaseDir(), outputFile.toString() ), encoding );
      }
      reporter.report( renderer.render( cpd.getMatches() ) );
   }

   private void tokenizeFiles( final CPD cpd ) throws IOException
   {
      for ( final FileSet fileSet : filesets )
      {
         final DirectoryScanner directoryScanner = fileSet.getDirectoryScanner( getProject() );
         final String[] includedFiles = directoryScanner.getIncludedFiles();
         for ( final String includedFile : includedFiles )
         {
            cpd.add( getFile( directoryScanner,
                              includedFile ) );
         }
      }
   }

   private void validateFields()
   {
      if ( minimumTokenCount == 0 )
      {
         throw new BuildException( "minimumTokenCount is required and must be greater than zero" );
      }
      else if ( filesets.isEmpty() )
      {
         throw new BuildException( "Must include at least one FileSet" );
      }
   }
}
