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
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import junit.framework.Assert;
import net.sourceforge.pmd.PMDException;

import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.files.IFlexFile;

public class FileUtilsTest extends FlexPmdTestBase
{
   @Test
   public void testComputeFilesList() throws PMDException
   {
      Map< String, IFlexFile > files;
      files = FileUtils.computeFilesList( getTestDirectory(),
                                          null,
                                          "",
                                          null );

      Assert.assertEquals( 99,
                           files.size() );

      final List< String > excludePatterns = new ArrayList< String >();
      excludePatterns.add( "bug" );
      files = FileUtils.computeFilesList( getTestDirectory(),
                                          null,
                                          "",
                                          excludePatterns );

      Assert.assertEquals( 83,
                           files.size() );
   }

   @Test
   public void testComputeFilesListWithEmptySourceFolder() throws PMDException
   {
      final Map< String, IFlexFile > files = FileUtils.computeFilesList( new File( getTestDirectory().getAbsolutePath()
                                                                               + "/" + "empty/emptyFolder" ),
                                                                         null,
                                                                         "",
                                                                         null );

      Assert.assertEquals( 1,
                           files.size() );
   }

   @Test
   public void testComputeFilesListWithoutSource()
   {
      try
      {
         FileUtils.computeFilesList( null,
                                     null,
                                     "",
                                     null );
         Assert.fail();
      }
      catch ( final PMDException e )
      {
         Assert.assertEquals( "sourceDirectory is not specified",
                              e.getMessage() );
      }
   }

   @Test
   public void testComputeFilesListWithSourceFile() throws PMDException
   {
      final Map< String, IFlexFile > files = FileUtils.computeFilesList( new File( getTestFiles().get( "AbstractRowData.as" )
                                                                                                 .getFilePath() ),
                                                                         null,
                                                                         "",
                                                                         null );

      Assert.assertEquals( 1,
                           files.size() );
   }

   @Test
   public void testComputeFilesListWithSourceList() throws PMDException
   {
      final List< File > sourceList = new ArrayList< File >();

      sourceList.add( getTestDirectory() );
      final Map< String, IFlexFile > files = FileUtils.computeFilesList( null,
                                                                         sourceList,
                                                                         "",
                                                                         null );

      Assert.assertEquals( 99,
                           files.size() );
   }
}
