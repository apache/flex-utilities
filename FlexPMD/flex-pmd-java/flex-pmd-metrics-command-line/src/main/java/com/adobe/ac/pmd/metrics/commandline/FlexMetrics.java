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
package com.adobe.ac.pmd.metrics.commandline;

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.logging.Level;
import java.util.logging.Logger;

import net.sourceforge.pmd.PMDException;
import net.sourceforge.pmd.cpd.ReportException;

import org.dom4j.DocumentException;

import com.adobe.ac.pmd.CommandLineOptions;
import com.adobe.ac.pmd.CommandLineUtils;
import com.adobe.ac.pmd.LoggerUtils;
import com.martiansoftware.jsap.JSAP;
import com.martiansoftware.jsap.JSAPException;
import com.martiansoftware.jsap.JSAPResult;
import com.martiansoftware.jsap.UnspecifiedParameterException;

public final class FlexMetrics
{
   private static JSAPResult   config;
   private static final Logger LOGGER = Logger.getLogger( FlexMetrics.class.getName() );

   public static void main( final String[] args ) throws JSAPException,
                                                 URISyntaxException,
                                                 IOException,
                                                 ReportException,
                                                 PMDException,
                                                 DocumentException
   {
      new LoggerUtils().loadConfiguration();
      startFlexMetrics( args );
      LOGGER.info( "FlexMetrics terminated" );
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
                           + FlexMetrics.class.getName() + " " + jsap.getUsage() );
      }

      return config.success();
   }

   static double getDoubleParameter( final CommandLineOptions option )
   {
      return config.getDouble( option.toString() );
   }

   static String getParameterValue( final CommandLineOptions option )
   {
      return config.getString( option.toString() );
   }

   static boolean startFlexMetrics( final String[] args ) throws JSAPException,
                                                         PMDException,
                                                         URISyntaxException,
                                                         IOException,
                                                         DocumentException
   {
      if ( areCommandLineOptionsCorrect( args ) )
      {
         final File sourceDirectory = new File( getParameterValue( CommandLineOptions.SOURCE_DIRECTORY ) );
         final File outputDirectory = new File( getParameterValue( CommandLineOptions.OUTPUT ) );
         double mxmlFactor = 0;
         try
         {
            mxmlFactor = getDoubleParameter( CommandLineOptions.MXML_FACTOR );
         }
         catch ( final UnspecifiedParameterException e )
         {
         }

         new com.adobe.ac.pmd.metrics.engine.FlexMetrics( sourceDirectory, mxmlFactor ).execute( outputDirectory );
      }

      return config.success();
   }

   private static JSAPResult parseCommandLineArguments( final String[] args,
                                                        final JSAP jsap ) throws JSAPException
   {
      CommandLineUtils.registerParameter( jsap,
                                          CommandLineOptions.SOURCE_DIRECTORY,
                                          true );
      CommandLineUtils.registerParameter( jsap,
                                          CommandLineOptions.MXML_FACTOR,
                                          false );
      CommandLineUtils.registerParameter( jsap,
                                          CommandLineOptions.OUTPUT,
                                          true );

      return jsap.parse( args );
   }

   private FlexMetrics()
   {
   }
}
