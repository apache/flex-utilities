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

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import java.io.FileNotFoundException;
import java.net.URISyntaxException;
import java.util.HashSet;
import java.util.Set;

import junit.framework.Assert;

import org.junit.Before;
import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.files.IAs3File;
import com.adobe.ac.pmd.files.IMxmlFile;

public class AbstractFlexFileTest extends FlexPmdTestBase
{
   private IAs3File  as3;
   private IMxmlFile mainMxml;
   private IMxmlFile mxml;

   @Before
   public void init() throws FileNotFoundException,
                     URISyntaxException
   {
      as3 = ( IAs3File ) getTestFiles().get( "AbstractRowData.as" );
      mainMxml = ( IMxmlFile ) getTestFiles().get( "Main.mxml" );
      mxml = ( IMxmlFile ) getTestFiles().get( "com.adobe.ac.ncss.mxml.IterationsList.mxml" );
   }

   @Test
   public void testContains()
   {
      assertTrue( as3.contains( "logger",
                                buildSetContaining( 0 ) ) );
      assertFalse( as3.contains( "loggerr",
                                 buildSetContaining( 0 ) ) );
      assertFalse( as3.contains( "addEventListener",
                                 buildSetContaining( 97,
                                                     102 ) ) );
   }

   @Test
   public void testEquals()
   {
      Assert.assertTrue( as3.equals( as3 ) );
      Assert.assertFalse( mxml.equals( as3 ) );
      Assert.assertFalse( as3.equals( mxml ) );
   }

   @Test
   public void testFlexPMD152()
   {
      Assert.assertEquals( "com.something",
                           AbstractFlexFile.computePackageName( "C:/somePath/ProjectName/com/something/Test.mxml",
                                                                "C:/somePath/ProjectName",
                                                                "Test.mxml",
                                                                "/" ) );

      Assert.assertEquals( "com.something",
                           AbstractFlexFile.computePackageName( "C:/somePath/ProjectName/com/something/Test.mxml",
                                                                "C:/somePath/ProjectName/",
                                                                "Test.mxml",
                                                                "/" ) );
   }

   @Test
   public void testGetClassName()
   {
      assertEquals( "AbstractRowData.as",
                    as3.getClassName() );
      assertEquals( "IterationsList.mxml",
                    mxml.getClassName() );
   }

   @Test
   public void testGetFileName()
   {
      Assert.assertEquals( "AbstractRowData.as",
                           as3.getFilename() );
   }

   @Test
   public void testGetFilePath()
   {
      assertNotNull( as3.getFilePath() );
      assertNotNull( mxml.getFilePath() );
      assertNotNull( mainMxml.getFilePath() );
   }

   @Test
   public void testGetPackageName()
   {
      assertEquals( "",
                    as3.getPackageName() );
      assertEquals( "com.adobe.ac.ncss.mxml",
                    mxml.getPackageName() );
   }

   @Test
   public void testGetPath()
   {
      assertEquals( "AbstractRowData.as",
                    as3.getFullyQualifiedName() );
      assertEquals( "com.adobe.ac.ncss.mxml.IterationsList.mxml",
                    mxml.getFullyQualifiedName() );
   }

   @Test
   public void testIsMainApplication()
   {
      assertFalse( as3.isMainApplication() );
      assertFalse( mxml.isMainApplication() );
      assertTrue( mainMxml.isMainApplication() );
   }

   @Test
   public void testIsMxml()
   {
      assertFalse( as3.isMxml() );
      assertTrue( mxml.isMxml() );
   }

   private Set< Integer > buildSetContaining( final int... lines )
   {

      final HashSet< Integer > hashSet = new HashSet< Integer >();

      for ( final int line : lines )
      {
         hashSet.add( line );
      }
      return hashSet;
   }
}
