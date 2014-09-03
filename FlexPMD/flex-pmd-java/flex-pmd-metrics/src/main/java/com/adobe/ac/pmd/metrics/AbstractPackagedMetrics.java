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

public abstract class AbstractPackagedMetrics implements IMetrics
{
   private final int    asDocs;
   private final int    ccn;
   private final int    multiLineComments;
   private final int    nonCommentStatements;
   private final String packageName;

   protected AbstractPackagedMetrics( final int nonCommentStatementsToBeSet,
                                      final String packageNameToBeSet,
                                      final int ccnToBeSet,
                                      final int asDocsToBeSet,
                                      final int multiLineCommentsToBeSet )
   {
      super();
      nonCommentStatements = nonCommentStatementsToBeSet;
      packageName = packageNameToBeSet;
      ccn = ccnToBeSet;
      asDocs = asDocsToBeSet;
      multiLineComments = multiLineCommentsToBeSet;
   }

   public int getAsDocs()
   {
      return asDocs;
   }

   public abstract String getFullName();

   public abstract String getMetricsName();

   public int getMultiLineComments()
   {
      return multiLineComments;
   }

   public int getNonCommentStatements()
   {
      return getNcss()
            + nonCommentStatements;
   }

   public String getPackageName()
   {
      return packageName;
   }

   public String toXmlString()
   {
      return new StringBuffer().append( MessageFormat.format( "<{0}><name>{1}</name><ccn>{2}</ccn><ncss>{3}</ncss>"
                                                                    + "<javadocs>{4}</javadocs>"
                                                                    + "<javadoc_lines>{4}</javadoc_lines>"
                                                                    + "<multi_comment_lines>{5}</multi_comment_lines>"
                                                                    + "<single_comment_lines>0</single_comment_lines>"
                                                                    + "{6}</{7}>",
                                                              getMetricsName(),
                                                              getFullName().equals( "" ) ? "."
                                                                                        : getFullName(),
                                                              String.valueOf( ccn ),
                                                              String.valueOf( getNonCommentStatements() ),
                                                              String.valueOf( asDocs ),
                                                              String.valueOf( multiLineComments ),
                                                              getContreteXml(),
                                                              getMetricsName() ) )
                               .toString();
   }

   protected abstract int getNcss();
}
