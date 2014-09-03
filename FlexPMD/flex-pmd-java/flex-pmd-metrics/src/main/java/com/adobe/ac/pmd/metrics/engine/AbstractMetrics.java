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
package com.adobe.ac.pmd.metrics.engine;

import java.io.File;
import java.io.FileFilter;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.text.MessageFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.logging.Logger;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;

import com.adobe.ac.ncss.filters.FlexFilter;
import com.adobe.ac.pmd.metrics.ClassMetrics;
import com.adobe.ac.pmd.metrics.FunctionMetrics;
import com.adobe.ac.pmd.metrics.PackageMetrics;
import com.adobe.ac.pmd.metrics.ProjectMetrics;

public abstract class AbstractMetrics
{
   private static class DirectoryFilter implements FileFilter
   {
      public boolean accept( final File file )
      {
         return file.isDirectory();
      }
   }

   private static final Logger LOGGER = Logger.getLogger( AbstractMetrics.class.getName() );

   private static Collection< File > listFiles( final File directory,
                                                final FilenameFilter filter,
                                                final boolean recurse )
   {
      final Collection< File > files = new ArrayList< File >();
      final File[] entries = directory.listFiles();
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
            files.addAll( listFiles( entry,
                                     filter,
                                     recurse ) );
         }
      }
      return files;
   }

   private static Collection< File > listNonEmptyDirectories( final File rootDirectory,
                                                              final boolean recurse )
   {
      final Collection< File > files = new ArrayList< File >();
      final File[] entries = rootDirectory.listFiles( new DirectoryFilter() );
      final FlexFilter flexFilter = new FlexFilter();

      for ( final File entry : entries )
      {
         if ( entry.isDirectory()
               && !listFiles( entry,
                              flexFilter,
                              false ).isEmpty() )
         {
            files.add( entry );
         }
         if ( recurse
               && entry.isDirectory() )
         {
            files.addAll( listNonEmptyDirectories( entry,
                                                   recurse ) );
         }
      }
      return files;
   }

   private Collection< File > nonEmptyDirectories = null;
   private File               sourceDirectory     = null;

   public AbstractMetrics( final File sourceDirectoryPath )
   {
      super();
      if ( sourceDirectoryPath != null )
      {
         this.nonEmptyDirectories = listNonEmptyDirectories( sourceDirectoryPath,
                                                             true );
         this.nonEmptyDirectories.add( sourceDirectoryPath );
         this.sourceDirectory = sourceDirectoryPath;
      }
   }

   public void execute( final File outputFile ) throws DocumentException,
                                               IOException
   {
      final String builtReport = buildReport( loadMetrics() );
      final Document document = DocumentHelper.parseText( builtReport );
      final OutputFormat format = OutputFormat.createPrettyPrint();

      if ( !outputFile.exists() )
      {
         if ( outputFile.createNewFile() == false )
         {
            LOGGER.warning( "Could not create a new output file" );
         }
      }

      final XMLWriter writer = new XMLWriter( new FileOutputStream( outputFile ), format );
      writer.write( document );
      writer.close();
   }

   public abstract ProjectMetrics loadMetrics();

   protected Collection< File > getNonEmptyDirectories()
   {
      return nonEmptyDirectories;
   }

   protected File getSourceDirectory()
   {
      return sourceDirectory;
   }

   private String addFunctions( final ProjectMetrics metrics )
   {
      final StringBuffer buffer = new StringBuffer( 250 );

      buffer.append( "<functions>" );

      for ( final FunctionMetrics functionMetrics : metrics.getFunctions() )
      {
         buffer.append( functionMetrics.toXmlString() );
      }

      buffer.append( MessageFormat.format( "<function_averages>"
                                                 + "<ncss>{0}</ncss>" + "<javadocs>{1}</javadocs>"
                                                 + "<javadoc_lines>{1}</javadoc_lines>"
                                                 + "<single_comment_lines>0</single_comment_lines>"
                                                 + "<multi_comment_lines>0</multi_comment_lines>"
                                                 + "</function_averages><ncss>{2}</ncss>" + "</functions>",
                                           String.valueOf( metrics.getAverageFunctions()
                                                                  .getAverageStatements() ),
                                           String.valueOf( metrics.getAverageFunctions().getAverageDocs() ),
                                           String.valueOf( metrics.getTotalPackages().getTotalStatements() ) ) );

      return buffer.toString();
   }

   private String addObjects( final ProjectMetrics metrics )
   {
      final StringBuffer buffer = new StringBuffer( 300 );

      buffer.append( "<objects>" );

      for ( final ClassMetrics classMetrics : metrics.getClasses() )
      {
         buffer.append( classMetrics.toXmlString() );
      }

      buffer.append( MessageFormat.format( "<averages>"
                                                 + "<classes>{0}</classes>" + "<functions>{1}</functions>"
                                                 + "<ncss>{2}</ncss>" + "<javadocs>{3}</javadocs>"
                                                 + "<javadoc_lines>{3}</javadoc_lines>"
                                                 + "<single_comment_lines>0</single_comment_lines>"
                                                 + "<multi_comment_lines>0</multi_comment_lines>"
                                                 + "</averages><ncss>{4}</ncss>" + "</objects>",
                                           String.valueOf( metrics.getClasses().size() ),
                                           String.valueOf( metrics.getAverageObjects().getAverageFunctions() ),
                                           String.valueOf( metrics.getAverageObjects().getAverageStatements() ),
                                           String.valueOf( metrics.getAverageObjects().getAverageDocs() ),
                                           String.valueOf( metrics.getTotalPackages().getTotalStatements() ) ) );
      return buffer.toString();
   }

   private String addPackages( final ProjectMetrics metrics )
   {
      final StringBuffer buffer = new StringBuffer( 228 );

      buffer.append( "<packages>" );

      for ( final PackageMetrics packageMetrics : metrics.getPackages() )
      {
         buffer.append( packageMetrics.toXmlString() );
      }

      buffer.append( metrics.getTotalPackages().getContreteXml() );
      buffer.append( "</packages>" );

      return buffer.toString();
   }

   private String buildReport( final ProjectMetrics metrics )
   {
      final StringBuffer buf = new StringBuffer( 70 );

      buf.append( "<?xml version=\"1.0\"?><javancss><date>"
            + metrics.getDate() + "</date><time>" + metrics.getTime() + "</time>" );

      buf.append( addPackages( metrics ) );
      buf.append( addObjects( metrics ) );
      buf.append( addFunctions( metrics ) );

      buf.append( "</javancss>" );

      return buf.toString();
   }
}