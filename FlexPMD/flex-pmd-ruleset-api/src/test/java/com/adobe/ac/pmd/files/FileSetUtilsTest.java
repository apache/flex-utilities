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
package com.adobe.ac.pmd.files;

import junit.framework.Assert;
import net.sourceforge.pmd.PMDException;

import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;

public class FileSetUtilsTest extends FlexPmdTestBase
{
   @Test
   public void buildAst() throws PMDException
   {
      FileSetUtils.buildAst( getTestFiles().get( "bug.Duane.mxml" ) );
   }

   @Test
   public void testBuildMessage()
   {
      Assert.assertEquals( "While building AST on bug.Duane.mxml, an error occured: message",
                           FileSetUtils.buildLogMessage( getTestFiles().get( "bug.Duane.mxml" ),
                                                         "message" ) );
   }

   @Test
   public void testComputeAsts() throws PMDException
   {
      FileSetUtils.computeAsts( getTestFiles() );
   }
}
