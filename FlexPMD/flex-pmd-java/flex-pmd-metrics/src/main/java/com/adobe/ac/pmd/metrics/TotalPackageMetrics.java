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

import java.text.MessageFormat;
import java.util.List;

public final class TotalPackageMetrics implements IMetrics
{
   public static TotalPackageMetrics create( final List< PackageMetrics > packageMetrics )
   {
      int nonCommentStatement = 0;
      int functions = 0;
      int classes = 0;
      int asDocs = 0;
      int multipleLineComments = 0;

      for ( final PackageMetrics metrics : packageMetrics )
      {
         nonCommentStatement += metrics.getNonCommentStatements();
         functions += metrics.getFunctions();
         classes += metrics.getClasses();
         asDocs += metrics.getAsDocs();
         multipleLineComments += metrics.getMultiLineComments();
      }
      return new TotalPackageMetrics( nonCommentStatement, functions, classes, asDocs, multipleLineComments );
   }

   private final int totalAsDocs;
   private final int totalClasses;
   private final int totalFunctions;
   private final int totalMultiLineComment;
   private final int totalStatements;

   private TotalPackageMetrics( final int totalStatementsToBeSet,
                                final int totalFunctionsToBeSet,
                                final int totalClassesToBeSet,
                                final int totalAsDocsToBeSet,
                                final int totalMultiLineCommentToBeSet )
   {
      super();

      totalStatements = totalStatementsToBeSet;
      totalFunctions = totalFunctionsToBeSet;
      totalClasses = totalClassesToBeSet;
      totalAsDocs = totalAsDocsToBeSet;
      totalMultiLineComment = totalMultiLineCommentToBeSet;
   }

   public String getContreteXml()
   {
      return new StringBuffer().append( MessageFormat.format( "<total>"
                                                                    + "<classes>{0}</classes>"
                                                                    + "<functions>{1}</functions>"
                                                                    + "<ncss>{2}</ncss>"
                                                                    + "<javadocs>{3}</javadocs>"
                                                                    + "<javadoc_lines>{3}</javadoc_lines>"
                                                                    + "<single_comment_lines>0</single_comment_lines>"
                                                                    + "<multi_comment_lines>{4}</multi_comment_lines>"
                                                                    + "</total>",
                                                              String.valueOf( totalClasses ),
                                                              String.valueOf( totalFunctions ),
                                                              String.valueOf( totalStatements ),
                                                              String.valueOf( totalAsDocs ),
                                                              String.valueOf( totalMultiLineComment ) ) )
                               .toString();
   }

   public int getTotalAsDocs()
   {
      return totalAsDocs;
   }

   public int getTotalClasses()
   {
      return totalClasses;
   }

   public int getTotalFunctions()
   {
      return totalFunctions;
   }

   public int getTotalMultiLineComment()
   {
      return totalMultiLineComment;
   }

   public int getTotalStatements()
   {
      return totalStatements;
   }
}
