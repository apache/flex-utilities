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
package com.adobe.ac.pmd.commandline;

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import net.sourceforge.pmd.PMDException;

import com.adobe.ac.pmd.CommandLineOptions;
import com.adobe.ac.pmd.CommandLineUtils;
import com.adobe.ac.pmd.FlexPmdParameters;
import com.adobe.ac.pmd.FlexPmdViolations;
import com.adobe.ac.pmd.LoggerUtils;
import com.adobe.ac.pmd.engines.FlexPmdXmlEngine;
import com.martiansoftware.jsap.JSAP;
import com.martiansoftware.jsap.JSAPException;
import com.martiansoftware.jsap.JSAPResult;

public final class FlexPMD // NO_UCD
{
   private static JSAPResult   config;
   private static final Logger LOGGER = Logger.getLogger( FlexPMD.class.getName() );

   /**
    * @param args
    * @throws JSAPException
    * @throws PMDException
    * @throws URISyntaxException
    * @throws IOException
    * @throws Exception
    */
   public static void main( final String[] args ) throws JSAPException,
                                                 PMDException,
                                                 URISyntaxException,
                                                 IOException
   {
      new LoggerUtils().loadConfiguration();
      startFlexPMD( args );
      LOGGER.info( "FlexPMD terminated" );
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
                           + FlexPMD.class.getName() + " " + jsap.getUsage() );
      }

      return config.success();
   }

   static String getParameterValue( final CommandLineOptions option )
   {
      return config.getString( option.toString() );
   }

   static boolean startFlexPMD( final String[] args ) throws JSAPException,
                                                     PMDException,
                                                     URISyntaxException,
                                                     IOException
   {
      if ( areCommandLineOptionsCorrect( args ) )
      {
         final String rulesetRef = getParameterValue( CommandLineOptions.RULE_SET );
         final String excludePackage = getParameterValue( CommandLineOptions.EXLUDE_PACKAGE );
         final String source = getParameterValue( CommandLineOptions.SOURCE_DIRECTORY );
         final File sourceDirectory = source.contains( "," ) ? null
                                                            : new File( source );
         final List< File > sourceList = CommandLineUtils.computeSourceList( source );
         final File outputDirectory = new File( getParameterValue( CommandLineOptions.OUTPUT ) );
         final FlexPmdParameters parameters = new FlexPmdParameters( excludePackage == null ? ""
                                                                                           : excludePackage,
                                                                     outputDirectory,
                                                                     rulesetRef == null ? null
                                                                                       : new File( rulesetRef ),
                                                                     sourceDirectory,
                                                                     sourceList );
         final FlexPmdXmlEngine engine = new FlexPmdXmlEngine( parameters );

         engine.executeReport( new FlexPmdViolations() );
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
                                          CommandLineOptions.OUTPUT,
                                          true );
      CommandLineUtils.registerParameter( jsap,
                                          CommandLineOptions.RULE_SET,
                                          false );
      CommandLineUtils.registerParameter( jsap,
                                          CommandLineOptions.EXLUDE_PACKAGE,
                                          false );

      return jsap.parse( args );
   }

   private FlexPMD()
   {
   }
}
