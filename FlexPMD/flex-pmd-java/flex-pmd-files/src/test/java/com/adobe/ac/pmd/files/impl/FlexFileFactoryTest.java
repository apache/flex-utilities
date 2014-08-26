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

import static org.junit.Assert.assertTrue;

import java.io.File;

import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.files.IAs3File;
import com.adobe.ac.pmd.files.IFlexFile;
import com.adobe.ac.pmd.files.IMxmlFile;

public class FlexFileFactoryTest extends FlexPmdTestBase
{
   @Test
   public void testCreate()
   {
      assertTrue( "",
                  create( new File( getTestFiles().get( "AbstractRowData.as" ).getFilePath() ),
                          new File( "" ) ) instanceof IAs3File );
      assertTrue( "",
                  create( new File( getTestFiles().get( "Main.mxml" ).getFilePath() ),
                          new File( "" ) ) instanceof IMxmlFile );
      assertTrue( "",
                  create( new File( getTestFiles().get( "com.adobe.ac.ncss.mxml.IterationsList.mxml" )
                                                  .getFilePath() ),
                          new File( "" ) ) instanceof IMxmlFile );
   }

   private IFlexFile create( final File sourceFile,
                             final File sourceDirectory )
   {
      IFlexFile file;

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
}
