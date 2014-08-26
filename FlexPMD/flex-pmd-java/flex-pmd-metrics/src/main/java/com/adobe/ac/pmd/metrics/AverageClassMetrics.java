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
package com.adobe.ac.pmd.metrics;

import java.util.List;

public final class AverageClassMetrics extends AverageMetricsBase
{
   public static AverageClassMetrics create( final List< ClassMetrics > classMetrics,
                                             final TotalPackageMetrics totalPackageMetrics )
   {
      int functions = 0;

      for ( final ClassMetrics metrics : classMetrics )
      {
         functions += metrics.getFunctions();
      }
      return new AverageClassMetrics( totalPackageMetrics.getTotalStatements(),
                                      functions,
                                      totalPackageMetrics.getTotalAsDocs(),
                                      totalPackageMetrics.getTotalMultiLineComment(),
                                      classMetrics.size() );
   }

   private final double averageFunctions;

   private AverageClassMetrics( final double nonCommentStatements,
                                final double functions,
                                final double asDocs,
                                final double multipleComments,
                                final double totalClassNumber )
   {
      super( totalClassNumber, asDocs, nonCommentStatements, multipleComments );
      averageFunctions = totalClassNumber > 0 ? functions
                                                   / totalClassNumber
                                             : 0;
   }

   public double getAverageFunctions()
   {
      return averageFunctions;
   }
}
