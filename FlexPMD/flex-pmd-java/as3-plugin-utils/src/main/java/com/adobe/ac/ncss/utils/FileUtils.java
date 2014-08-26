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
package com.adobe.ac.ncss.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.logging.Logger;

import com.adobe.ac.utils.StackTraceUtils;

/**
 * @author xagnetti
 */
public final class FileUtils
{
   public static class FilePathComparator implements Comparator< File >
   {
      public int compare( final File arg0,
                          final File arg1 )
      {
         return arg0.getAbsolutePath().compareTo( arg1.getAbsolutePath() );
      }
   }

   public static final Logger LOGGER = Logger.getLogger( FileUtils.class.getName() );

   /**
    * @param line
    * @return
    */
   public static boolean isLineACorrectStatement( final String line )
   {
      return line.compareTo( "" ) != 0
            && lrtrim( line ).compareTo( "{" ) != 0 && lrtrim( line ).compareTo( "}" ) != 0
            && line.endsWith( ";" );
   }

   /**
    * @param directory
    * @param filter
    * @param recurse
    * @return
    */
   public static Collection< File > listFiles( final File directory,
                                               final FilenameFilter filter,
                                               final boolean recurse )
   {
      final ArrayList< File > files = listFilesRecurse( directory,
                                                        filter,
                                                        recurse );
      Collections.sort( files,
                        new FilePathComparator() );
      return files;
   }

   /**
    * @param sourceDirectory
    * @param filter
    * @param recurse
    * @return
    */
   public static Collection< File > listFiles( final List< File > sourceDirectory,
                                               final FilenameFilter filter,
                                               final boolean recurse )
   {
      final ArrayList< File > files = new ArrayList< File >();

      for ( final File topDirectory : sourceDirectory )
      {
         files.addAll( listFilesRecurse( topDirectory,
                                         filter,
                                         recurse ) );
      }

      Collections.sort( files,
                        new FilePathComparator() );
      return files;
   }

   /**
    * @param file
    * @return
    */
   public static List< String > readFile( final File file )
   {
      final List< String > result = new ArrayList< String >();

      BufferedReader inReader = null;
      try
      {
         final Reader reader = new InputStreamReader( new FileInputStream( file ), "UTF-8" );
         inReader = new BufferedReader( reader );

         String line = readLine( inReader );

         while ( line != null )
         {
            result.add( line );
            line = readLine( inReader );
         }
         inReader.close();
      }
      catch ( final IOException e )
      {
         StackTraceUtils.print( e );
      }
      return result;
   }

   private static ArrayList< File > listFilesRecurse( final File directory,
                                                      final FilenameFilter filter,
                                                      final boolean recurse )
   {
      final ArrayList< File > files = new ArrayList< File >();
      final File[] entries = directory.listFiles();

      if ( entries != null )
      {
         for ( final File entry : entries )
         {
            if ( filter == null
                  || filter.accept( directory,
                                    entry.getName() ) )
            {
               files.add( entry );
            }
            if ( recurse
                  && entry.isDirectory() )
            {
               files.addAll( listFilesRecurse( entry,
                                               filter,
                                               recurse ) );
            }
         }
      }
      return files;
   }

   private static String lrtrim( final String source )
   {
      return ltrim( rtrim( source ) );
   }

   /* remove leading whitespace */
   private static String ltrim( final String source )
   {
      return source.replaceAll( "^\\s+",
                                "" );
   }

   private static String readLine( final BufferedReader inReader ) throws IOException
   {
      final String line = inReader.readLine();

      if ( line != null )
      {
         return line.replaceAll( "\uFEFF",
                                 "" );
      }
      return null;
   }

   /* remove trailing whitespace */
   private static String rtrim( final String source )
   {
      return source.replaceAll( "\\s+$",
                                "" );
   }

   private FileUtils()
   {
   }
}
