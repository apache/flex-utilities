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

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import junit.framework.TestCase;

import org.junit.Test;

import com.adobe.ac.ncss.filters.FlexFilter;

public class TestFileUtils extends TestCase
{
   @Test
   public void testIsLineACorrectStatement()
   {
      assertFalse( FileUtils.isLineACorrectStatement( "    { " ) );
      assertFalse( FileUtils.isLineACorrectStatement( "    } " ) );
      assertFalse( FileUtils.isLineACorrectStatement( "{" ) );
      assertFalse( FileUtils.isLineACorrectStatement( "}" ) );
      assertFalse( FileUtils.isLineACorrectStatement( "    class MyModel " ) );
      assertFalse( FileUtils.isLineACorrectStatement( "class MyModel" ) );
      assertFalse( FileUtils.isLineACorrectStatement( "function lala() : void" ) );
      assertFalse( FileUtils.isLineACorrectStatement( "var i : int" ) );
      assertFalse( FileUtils.isLineACorrectStatement( "lalla; cdcdvf" ) );
      assertTrue( FileUtils.isLineACorrectStatement( "var i : int;" ) );
      assertTrue( FileUtils.isLineACorrectStatement( "  foo( bar );" ) );
      assertTrue( FileUtils.isLineACorrectStatement( "lalla;" ) );
   }

   @Test
   public void testListFiles()
   {
      assertEquals( 12,
                    FileUtils.listFiles( new File( "src/test/resources" ),
                                         new FlexFilter(),
                                         true ).size() );

      final List< File > sourceDirectory = new ArrayList< File >();

      sourceDirectory.add( new File( "src/test/resources/com/adobe/ac/ncss/flexunit" ) );
      sourceDirectory.add( new File( "src/test/resources/com/adobe/ac/ncss/mxml" ) );

      assertEquals( 12,
                    FileUtils.listFiles( sourceDirectory,
                                         new FlexFilter(),
                                         true ).size() );

      assertEquals( 0,
                    FileUtils.listFiles( new File( "./src/main/java" ),
                                         new FlexFilter(),
                                         true ).size() );
   }

   @Test
   public void testReadFile() throws IOException
   {
      assertEquals( 61,
                    FileUtils.readFile( new File( "./src/test/resources/com/adobe/ac/ncss/mxml/IterationsList.mxml" ) )
                             .size() );

      assertEquals( 0,
                    FileUtils.readFile( new File( "./DoNotExistFile.as" ) ).size() );
   }
}
