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

import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertTrue;

import java.io.File;
import java.io.IOException;

import org.dom4j.DocumentException;
import org.junit.Test;

import com.adobe.ac.pmd.FlexPmdTestBase;
import com.adobe.ac.pmd.metrics.ProjectMetrics;

public class FlexMetricsTest extends FlexPmdTestBase
{
   private static final int     TOTAL_CLASSES_NUMBER   = 99;
   private static final int     TOTAL_FUNCTIONS_NUMBER = 320;
   private final FlexMetrics    flexMetrics;
   private final ProjectMetrics projectMetrics;

   public FlexMetricsTest()
   {
      super();

      flexMetrics = new FlexMetrics( getTestDirectory(), 0 );
      projectMetrics = flexMetrics.loadMetrics();
   }

   @Test
   public void execute() throws DocumentException,
                        IOException
   {
      final File outputFile = new File( "target/javancss.xml" );

      flexMetrics.execute( outputFile );

      assertTrue( outputFile.exists() );
   }

   @Test
   public void loadAverageMetrics()
   {
      assertEquals( 5,
                    Math.round( projectMetrics.getAverageFunctions().getAverageStatements() ) );
      assertEquals( 3,
                    Math.round( projectMetrics.getAverageObjects().getAverageFunctions() ) );
      assertEquals( 16,
                    Math.round( projectMetrics.getAverageObjects().getAverageStatements() ) );
      assertEquals( 31,
                    Math.round( projectMetrics.getAverageObjects().getAverageDocs() ) );
      assertEquals( 2,
                    Math.round( projectMetrics.getAverageObjects().getAverageMultipleComments() + 0.95 ) );
   }

   @Test
   public void loadClassMetrics()
   {
      assertEquals( TOTAL_CLASSES_NUMBER,
                    projectMetrics.getClasses().size() );
      assertEquals( 0,
                    projectMetrics.getClasses().get( 3 ).getFunctions() );
      assertEquals( "bug.FlexPMD233a",
                    projectMetrics.getClasses().get( 10 ).getFullName() );
      assertEquals( 1,
                    projectMetrics.getClasses().get( 10 ).getNonCommentStatements() );
/*      assertEquals( "bug.FlexPMD60",
                    projectMetrics.getClasses().get( 12 ).getFullName() );
      assertEquals( 7,
                    projectMetrics.getClasses().get( 12 ).getMultiLineComments() );
*/      assertEquals( "bug.FlexPMD61",
                    projectMetrics.getClasses().get( 12 ).getFullName() );
      assertEquals( 3,
                    projectMetrics.getClasses().get( 12 ).getFunctions() );
      assertEquals( 9,
                    projectMetrics.getClasses().get( 12 ).getNonCommentStatements() );
      assertEquals( "cairngorm.FatController",
                    projectMetrics.getClasses().get( 19 ).getFullName() );
      assertEquals( 3,
                    projectMetrics.getClasses().get( 19 ).getAsDocs() );
   }

   @Test
   public void loadFunctionMetrics()
   {
      assertEquals( TOTAL_FUNCTIONS_NUMBER,
                    projectMetrics.getFunctions().size() );
/*      assertEquals( "TestEvent",
                    projectMetrics.getFunctions().get( 103 ).getName() );
      assertEquals( 3,
                    projectMetrics.getFunctions().get( 103 ).getNonCommentStatements() );
*/      assertEquals( "clone",
                    projectMetrics.getFunctions().get( 103 ).getName() );
      assertEquals( 2,
                    projectMetrics.getFunctions().get( 103 ).getNonCommentStatements() );
      assertEquals( "BugDemo",
                    projectMetrics.getFunctions().get( 106 ).getName() );
      assertEquals( 10,
                    projectMetrics.getFunctions().get( 106 ).getNonCommentStatements() );
   }

   @Test
   public void loadPackageMetrics()
   {
      assertEquals( 28,
                    projectMetrics.getPackages().size() );
      assertEquals( "",
                    projectMetrics.getPackages()
                                  .get( projectMetrics.getPackages().size() - 1 )
                                  .getPackageName() );
      assertEquals( 16,
                    projectMetrics.getPackages().get( 1 ).getClasses() );
      assertEquals( "bug",
                    projectMetrics.getPackages().get( 1 ).getFullName() );
      assertEquals( 103,
                    projectMetrics.getPackages().get( 1 ).getFunctions() );
      assertEquals( 399,
                    projectMetrics.getPackages().get( 1 ).getNonCommentStatements() );
      assertEquals( "bug",
                    projectMetrics.getPackages().get( 1 ).getPackageName() );
   }

   @Test
   public void loadTotalPackageMetrics()
   {
      assertEquals( TOTAL_CLASSES_NUMBER,
                    projectMetrics.getTotalPackages().getTotalClasses() );
      assertEquals( TOTAL_FUNCTIONS_NUMBER,
                    projectMetrics.getTotalPackages().getTotalFunctions() );
      assertEquals( 1583,
                    projectMetrics.getTotalPackages().getTotalStatements() );
      assertEquals( 3037,
                    projectMetrics.getTotalPackages().getTotalAsDocs() );
      assertEquals( 96,
                    projectMetrics.getTotalPackages().getTotalMultiLineComment() );
   }

   @Test
   public void testBug157()
   {
      assertEquals( "org.as3commons.concurrency.thread",
                    projectMetrics.getPackageMetrics().get( 23 ).getFullName() );

   }
}
