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
package com.adobe.ac.pmd.engines;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.net.URISyntaxException;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.logging.Logger;

import net.sourceforge.pmd.PMDException;

import com.adobe.ac.pmd.FlexPmdParameters;
import com.adobe.ac.pmd.FlexPmdViolations;
import com.adobe.ac.pmd.IFlexViolation;
import com.adobe.ac.pmd.files.IFlexFile;

public class FlexPmdXmlEngine extends AbstractFlexPmdEngine
{
   private static final Logger LOGGER = Logger.getLogger( FlexPmdXmlEngine.class.getName() );

   public FlexPmdXmlEngine( final FlexPmdParameters parameters ) throws URISyntaxException,
                                                                IOException
   {
      super( parameters );
   }

   @Override
   protected final void writeReport( final FlexPmdViolations pmd ) throws PMDException
   {
      final File realOutputDirectory = getOutputDirectory();
      final String filePath = realOutputDirectory.getAbsoluteFile()
            + File.separator + FlexPMDFormat.XML.toString();

      makeSureOutputDirectoryExists( realOutputDirectory );

      Writer writter = null;
      try
      {
         LOGGER.finest( "Start writting XML report" );
         LOGGER.info( "Creating report in <"
               + filePath + ">" );

         writter = new OutputStreamWriter( new FileOutputStream( filePath ), "UTF-8" );
         writeReportHeader( writter );
         writeFileViolations( pmd,
                              writter );
         writeReportFooter( writter );
         writter.close();
      }
      catch ( final IOException e )
      {
         throw new PMDException( "Error creating file "
               + filePath, e );
      }
      finally
      {
         finalizeReport( writter );
      }
   }

   private void finalizeReport( final Writer writter )
   {
      LOGGER.finest( "End writting XML report" );

      if ( writter != null )
      {
         try
         {
            LOGGER.finest( "Closing the XML writter" );
            writter.close();
         }
         catch ( final IOException e )
         {
            LOGGER.warning( Arrays.toString( e.getStackTrace() ) );
         }
         LOGGER.finest( "Closed the XML writter" );
      }
   }

   private void formatFileFiolation( final Writer writter,
                                     final IFlexFile sourceFile,
                                     final Collection< IFlexViolation > violations,
                                     final String sourceFilePath ) throws IOException
   {
      if ( !violations.isEmpty() )
      {
         if ( sourceFilePath.charAt( 2 ) == ':' )
         {
            writter.write( "   <file name=\""
                  + sourceFilePath.substring( 1,
                                              sourceFilePath.length() ) + "\">" + getNewLine() );
         }
         else
         {
            writter.write( "   <file name=\""
                  + sourceFilePath + "\">" + getNewLine() );

         }
         for ( final IFlexViolation violation : violations )
         {
            writter.write( violation.toXmlString( sourceFile,
                                                  violation.getRule().getRuleSetName() ) );
         }
         writter.write( "   </file>"
               + getNewLine() );
      }
   }

   private String getNewLine()
   {
      return System.getProperty( "line.separator" );
   }

   private void makeSureOutputDirectoryExists( final File realOutputDirectory )
   {
      if ( !realOutputDirectory.exists()
            && !realOutputDirectory.mkdirs() )
      {
         LOGGER.severe( "Unable to create an output folder" );
      }
   }

   private void writeFileViolations( final FlexPmdViolations pmd,
                                     final Writer writter ) throws IOException
   {
      for ( final IFlexFile sourceFile : pmd.getViolations().keySet() )
      {
         final Collection< IFlexViolation > violations = pmd.getViolations().get( sourceFile );
         final String sourceFilePath = sourceFile.getFilePath();

         formatFileFiolation( writter,
                              sourceFile,
                              violations,
                              sourceFilePath );
      }
   }

   private void writeReportFooter( final Writer writter ) throws IOException
   {
      writter.write( "</pmd>"
            + getNewLine() );
   }

   private void writeReportHeader( final Writer writter ) throws IOException
   {
      writter.write( "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
            + getNewLine() );
      writter.write( "<pmd version=\"4.2.1\" timestamp=\""
            + new Date().toString() + "\">" + getNewLine() );
   }
}
