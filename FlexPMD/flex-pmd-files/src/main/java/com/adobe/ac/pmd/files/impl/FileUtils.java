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
package com.adobe.ac.pmd.files.impl;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import net.sourceforge.pmd.PMDException;

import com.adobe.ac.ncss.filters.FlexFilter;
import com.adobe.ac.pmd.files.IFlexFile;

/**
 * @author xagnetti
 */
public final class FileUtils
{
   /**
    * @param source
    * @param sourceList
    * @param packageToExclude
    * @param excludePatterns
    * @return
    * @throws PMDException
    */
   public static Map< String, IFlexFile > computeFilesList( final File source,
                                                            final List< File > sourceList,
                                                            final String packageToExclude,
                                                            final List< String > excludePatterns ) throws PMDException
   {
      final Map< String, IFlexFile > files = new LinkedHashMap< String, IFlexFile >();
      final FlexFilter flexFilter = new FlexFilter();
      final Collection< File > foundFiles = getFlexFiles( source,
                                                          sourceList,
                                                          flexFilter );

      for ( final File sourceFile : foundFiles )
      {
         final AbstractFlexFile file = create( sourceFile,
                                               source );

         if ( ( "".equals( packageToExclude ) || !file.getFullyQualifiedName().startsWith( packageToExclude ) )
               && !currentPackageIncludedInExcludePatterns( file.getFullyQualifiedName(),
                                                            excludePatterns ) )
         {
            files.put( file.getFullyQualifiedName(),
                       file );
         }
      }

      return files;
   }

   /**
    * @param sourceFile
    * @param sourceDirectory
    * @return
    */
   public static AbstractFlexFile create( final File sourceFile,
                                          final File sourceDirectory )
   {
      AbstractFlexFile file;

      if ( sourceFile.getName().endsWith( ".as" ) )
      {
         file = new As3File( sourceFile, sourceDirectory );
      }
      else
      {
         file = new MxmlFile( sourceFile, sourceDirectory );
      }

      return file;
   }

   /**
    * @param file
    * @return
    * @throws IOException
    */
   public static String[] readLines( final File file ) throws IOException
   {
      final List< String > lines = com.adobe.ac.ncss.utils.FileUtils.readFile( file );

      return lines.toArray( new String[ lines.size() ] );
   }

   private static boolean currentPackageIncludedInExcludePatterns( final String fullyQualifiedName,
                                                                   final List< String > excludePatterns )
   {
      if ( excludePatterns != null )
      {
         for ( final String excludePattern : excludePatterns )
         {
            if ( fullyQualifiedName.startsWith( excludePattern ) )
            {
               return true;
            }
         }
      }
      return false;
   }

   private static Collection< File > getFlexFiles( final File source,
                                                   final List< File > sourceList,
                                                   final FlexFilter flexFilter ) throws PMDException
   {
      if ( source == null
            && sourceList == null )
      {
         throw new PMDException( "sourceDirectory is not specified", null );
      }
      Collection< File > foundFiles;
      if ( source == null )
      {
         foundFiles = com.adobe.ac.ncss.utils.FileUtils.listFiles( sourceList,
                                                                   flexFilter,
                                                                   true );
      }
      else
      {
         if ( source.isDirectory() )
         {
            foundFiles = com.adobe.ac.ncss.utils.FileUtils.listFiles( source,
                                                                      flexFilter,
                                                                      true );
         }
         else
         {
            foundFiles = new ArrayList< File >();
            foundFiles.add( source );
         }
      }
      if ( foundFiles.isEmpty() )
      {
         return new ArrayList< File >();
      }
      return foundFiles;
   }

   private FileUtils()
   {
   }
}
