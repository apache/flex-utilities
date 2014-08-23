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

import org.junit.Before;
import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.files.IMxmlFile;

public class MxmlFileTest extends FlexPmdTestBase
{
   private IMxmlFile data;

   @Before
   public void setUp()
   {
      data = ( IMxmlFile ) getTestFiles().get( "Main.mxml" );
   }

   @Test
   public void testGetActualScriptBlock()
   {
      assertEquals( Integer.valueOf( 4 ),
                    Integer.valueOf( data.getActualScriptBlock().length ) );
   }

   @Test
   public void testGetSingleLineComment()
   {
      assertEquals( "<!--",
                    data.getSingleLineComment() );
   }
}
