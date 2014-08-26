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
import java.util.Map;

import com.adobe.ac.pmd.files.IFlexFile;

/**
 * This is a base class for any FlexPMD rule test case.
 * 
 * @author xagnetti
 */
public class FlexPmdTestBase // NO_UCD
{
   protected static final String    BEGIN_LINE_NOT_CORRECT        = "Begining line is not correct";     // NO_UCD
   protected static final String    END_LINE_NOT_CORRECT          = "Ending line is not correct";       // NO_UCD
   protected static final String    VIOLATIONS_NUMBER_NOT_CORRECT = "Violations number is not correct"; // NO_UCD

   /**
    * Test files placeholder. The key is the qualified file name
    */
   private Map< String, IFlexFile > testFiles                     = ResourcesManagerTest.getInstance()
                                                                                        .getTestFiles();

   /**
    * 
    */
   protected FlexPmdTestBase()
   {
   }

   /**
    * @return
    */
   protected File getTestDirectory() // NO_UCD
   {
      return ResourcesManagerTest.getInstance().getTestRootDirectory();
   }

   /**
    * @return
    */
   protected final Map< String, IFlexFile > getTestFiles() // NO_UCD
   {
      return testFiles;
   }

   /**
    * @param testFilesToBeSet
    */
   protected final void setTestFiles( final Map< String, IFlexFile > testFilesToBeSet )
   {
      testFiles = testFilesToBeSet;
   }
}