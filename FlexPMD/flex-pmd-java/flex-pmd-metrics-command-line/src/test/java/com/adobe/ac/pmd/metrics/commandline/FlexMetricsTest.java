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
package com.adobe.ac.pmd.metrics.commandline;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.io.File;
import java.util.logging.Logger;

import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;

public class FlexMetricsTest extends FlexPmdTestBase
{
   @Test
   public void testStartFlexMetrics()
   {
      try
      {
         final File outputFile = File.createTempFile( "metrics",
                                                      "" );
         FlexMetrics.startFlexMetrics( new String[]
         { "-s",
                     getTestDirectory().getAbsolutePath(),
                     "-o",
                     outputFile.getAbsolutePath() } );

         assertTrue( "outputFile has not been created",
                     outputFile.exists() );
         assertTrue( "outputFile is empty",
                     outputFile.length() > 0 );
      }
      catch ( final Exception e )
      {
         Logger.getAnonymousLogger().warning( e.getMessage() );
         fail();
      }
   }
}
