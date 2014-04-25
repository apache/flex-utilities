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
package com.adobe.ac.cpd.commandline;

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.logging.Level;
import java.util.logging.Logger;

import net.sourceforge.pmd.PMDException;
import net.sourceforge.pmd.cpd.CPD;
import net.sourceforge.pmd.cpd.FileReporter;
import net.sourceforge.pmd.cpd.Renderer;
import net.sourceforge.pmd.cpd.ReportException;
import net.sourceforge.pmd.cpd.XMLRenderer;

import com.adobe.ac.cpd.FlexLanguage;
import com.adobe.ac.cpd.FlexTokenizer;
import com.adobe.ac.pmd.CommandLineOptions;
import com.adobe.ac.pmd.CommandLineUtils;
import com.adobe.ac.pmd.ICommandLineOptions;
import com.adobe.ac.pmd.LoggerUtils;
import com.adobe.ac.pmd.files.IFlexFile;
import com.adobe.ac.pmd.files.impl.FileUtils;
import com.martiansoftware.jsap.JSAP;
import com.martiansoftware.jsap.JSAPException;
import com.martiansoftware.jsap.JSAPResult;

public final class FlexCPD
{
   private static JSAPResult        config;
   private static final String      ENCODING = System.getProperty( "file.encoding" );
   private static final Logger      LOGGER   = Logger.getLogger( FlexCPD.class.getName() );
   private static FlexCpdParameters parameters;

   public static void main( final String[] args ) throws JSAPException,
                                                 URISyntaxException,
                                                 IOException,
                                                 ReportException,
                                                 PMDException
   {
      new LoggerUtils().loadConfiguration();
      startFlexCPD( args );
      LOGGER.info( "FlexCPD terminated" );
      System.exit( 0 ); // NOPMD
   }

   static boolean areCommandLineOptionsCorrect( final String[] args ) throws JSAPException
   {
      final JSAP jsap = new JSAP();
      config = parseCommandLineArguments( args,
                                          jsap );

      if ( !config.success() )
      {
         LOGGER.log( Level.SEVERE,
                     "Usage: java "
                           + FlexCPD.class.getName() + " " + jsap.getUsage() );
      }

      return config.success();
   }

   static String getParameterValue( final ICommandLineOptions option )
   {
      return config.getString( option.toString() );
   }

   static boolean startFlexCPD( final String[] args ) throws JSAPException,
                                                     URISyntaxException,
                                                     IOException,
                                                     ReportException,
                                                     PMDException
   {
      if ( areCommandLineOptionsCorrect( args ) )
      {
         final String minimumTokens = getParameterValue( CpdCommandLineOptions.MINIMUM_TOKENS );
         final String source = getParameterValue( CommandLineOptions.SOURCE_DIRECTORY );
         final File sourceDirectory = source.contains( "," ) ? null
                                                            : new File( source );
         final List< File > sourceList = CommandLineUtils.computeSourceList( source );
         final File outputDirectory = new File( getParameterValue( CpdCommandLineOptions.OUTPUT_FILE ) );

         parameters = new FlexCpdParameters( outputDirectory,
                                             minimumTokens == null ? FlexTokenizer.DEFAULT_MINIMUM_TOKENS
                                                                  : Integer.valueOf( minimumTokens ),
                                             sourceDirectory,
                                             sourceList );
         LOGGER.info( "Starting run, minimumTokenCount is "
               + parameters.getMinimumTokenCount() );

         LOGGER.info( "Tokenizing files" );
         final CPD cpd = new CPD( parameters.getMinimumTokenCount(), new FlexLanguage() );

         cpd.setEncoding( ENCODING );
         tokenizeFiles( cpd );

         LOGGER.info( "Starting to analyze code" );
         final long timeTaken = analyzeCode( cpd );
         LOGGER.info( "Done analyzing code; that took "
               + timeTaken + " milliseconds" );

         LOGGER.info( "Generating report" );
         report( cpd );
      }

      return config.success();
   }

   private static long analyzeCode( final CPD cpd )
   {
      final long start = System.currentTimeMillis();
      cpd.go();
      final long stop = System.currentTimeMillis();
      return stop
            - start;
   }

   private static JSAPResult parseCommandLineArguments( final String[] args,
                                                        final JSAP jsap ) throws JSAPException
   {
      CommandLineUtils.registerParameter( jsap,
                                          CommandLineOptions.SOURCE_DIRECTORY,
                                          true );
      CommandLineUtils.registerParameter( jsap,
                                          CpdCommandLineOptions.OUTPUT_FILE,
                                          true );
      CommandLineUtils.registerParameter( jsap,
                                          CpdCommandLineOptions.MINIMUM_TOKENS,
                                          false );
      CommandLineUtils.registerParameter( jsap,
                                          CommandLineOptions.EXLUDE_PACKAGE,
                                          false );

      return jsap.parse( args );
   }

   private static void report( final CPD cpd ) throws ReportException,
                                              IOException
   {
      if ( !cpd.getMatches().hasNext() )
      {
         LOGGER.info( "No duplicates over "
               + parameters.getMinimumTokenCount() + " tokens found" );
      }
      final Renderer renderer = new XMLRenderer( ENCODING );

      if ( !parameters.getOutputFile().exists() )
      {
         if ( parameters.getOutputFile().createNewFile() == false )
         {
            LOGGER.warning( "Could not create a new output file" );
         }
      }

      final FileReporter reporter = new FileReporter( parameters.getOutputFile(), ENCODING );
      reporter.report( renderer.render( cpd.getMatches() ) );
   }

   private static void tokenizeFiles( final CPD cpd ) throws IOException,
                                                     PMDException
   {
      final Map< String, IFlexFile > files = FileUtils.computeFilesList( parameters.getSourceDirectory(),
                                                                         parameters.getSourceList(),
                                                                         "",
                                                                         null );

      for ( final Entry< String, IFlexFile > fileEntry : files.entrySet() )
      {
         cpd.add( new File( fileEntry.getValue().getFilePath() ) ); // NOPMD
      }
   }

   private FlexCPD()
   {
   }
}
