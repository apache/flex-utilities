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
package com.adobe.ac.pmd;

import java.io.File;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.logging.Logger;

import net.sourceforge.pmd.PMDException;

import com.adobe.ac.pmd.files.IFlexFile;
import com.adobe.ac.pmd.files.impl.FileUtils;
import com.adobe.ac.utils.StackTraceUtils;

/**
 * Internal utility which finds out the test resources, and map them to their
 * qualified names.
 * 
 * @author xagnetti
 */
public final class ResourcesManagerTest
{
   private static ResourcesManagerTest instance = null;
   private static final Logger         LOGGER   = Logger.getLogger( ResourcesManagerTest.class.getName() );

   /**
    * @return
    */
   public static synchronized ResourcesManagerTest getInstance() // NOPMD
   {
      if ( instance == null )
      {
         try
         {
            new LoggerUtils().loadConfiguration();
            instance = new ResourcesManagerTest( "/test" );
         }
         catch ( final URISyntaxException e )
         {
            LOGGER.warning( StackTraceUtils.print( e ) );
         }
         catch ( final PMDException e )
         {
            LOGGER.warning( StackTraceUtils.print( e ) );
         }
      }
      return instance;
   }

   private final Map< String, IFlexFile > testFiles;
   private final File                     testRootDirectory;

   private ResourcesManagerTest( final String directory ) throws URISyntaxException,
                                                         PMDException
   {
      final URL resource = this.getClass().getResource( directory );

      if ( resource == null )
      {
         LOGGER.severe( directory
               + " folder is not found in the resource" );
         testRootDirectory = null;
         testFiles = new LinkedHashMap< String, IFlexFile >();
      }
      else
      {
         testRootDirectory = new File( resource.toURI().getPath() );
         testFiles = FileUtils.computeFilesList( testRootDirectory,
                                                 null,
                                                 "",
                                                 null );
      }
   }

   /**
    * @return
    */
   public Map< String, IFlexFile > getTestFiles()
   {
      return testFiles;
   }

   protected File getTestRootDirectory()
   {
      return testRootDirectory;
   }
}
