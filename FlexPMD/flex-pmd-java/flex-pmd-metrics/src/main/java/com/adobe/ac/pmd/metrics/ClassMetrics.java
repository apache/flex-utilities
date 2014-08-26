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

import java.io.File;

import com.adobe.ac.pmd.files.IFlexFile;
import com.adobe.ac.pmd.nodes.IClass;

public final class ClassMetrics extends AbstractNamedMetrics
{
   public static ClassMetrics create( final String packageFullName,
                                      final File fileInPackage,
                                      final InternalFunctionMetrics functionMetrics,
                                      final IClass classNode,
                                      final IFlexFile file,
                                      final double mxmlFactor )
   {
      final int average = classNode == null ? 0
                                           : ( int ) Math.round( classNode.getAverageCyclomaticComplexity() );
      final int asDocs = ( classNode == null
            || classNode.getAsDoc() == null ? 0
                                           : MetricUtils.computeNbOfLines( classNode.getAsDoc()
                                                                                    .getStringValue() ) )
            + ( functionMetrics == null ? 0
                                       : functionMetrics.getAsDocsInClass() );
      final int multiLineComments = ( classNode == null ? 0
                                                       : MetricUtils.computeMultiLineComments( classNode ) )
            + ( functionMetrics == null ? 0
                                       : functionMetrics.getMultipleLineCommentInClass() );
      final int nonCommentStatements = computeStatements( functionMetrics,
                                                          file,
                                                          mxmlFactor );
      return new ClassMetrics( nonCommentStatements, // NOPMD
                               classNode == null ? 0
                                                : classNode.getFunctions().size(),
                               fileInPackage.getName().replace( ".as",
                                                                "" ).replace( ".mxml",
                                                                              "" ),
                               packageFullName,
                               average,
                               asDocs,
                               multiLineComments,
                               classNode );
   }

   private static int computeStatements( final InternalFunctionMetrics functionMetrics,
                                         final IFlexFile file,
                                         final double mxmlFactor )
   {
      int stts = functionMetrics == null ? 0
                                        : functionMetrics.getNcssInClass();
      if ( file.isMxml() )
      {
         stts += file.getLinesNb()
               * mxmlFactor;
      }
      return stts;
   }

   private final IClass classNode;
   private final int    functions;

   private ClassMetrics( final int nonCommentStatements,
                         final int functionsToBeSet,
                         final String name,
                         final String packageName,
                         final int ccn,
                         final int asDocs,
                         final int multiLineCommentsToBeSet,
                         final IClass classNodeToBeSet )
   {
      super( nonCommentStatements, name, packageName, ccn, asDocs, multiLineCommentsToBeSet );

      functions = functionsToBeSet;
      this.classNode = classNodeToBeSet;
   }

   public String getContreteXml()
   {
      return "<functions>"
            + functions + "</functions>";
   }

   @Override
   public String getFullName()
   {
      return getPackageName().compareTo( "" ) == 0 ? getName()
                                                  : getPackageName()
                                                        + "." + getName();
   }

   public int getFunctions()
   {
      return functions;
   }

   @Override
   public String getMetricsName()
   {
      return "object";
   }

   @Override
   protected int getNcss()
   {
      if ( classNode == null )
      {
         return 1;
      }
      return 1
            + classNode.getAttributes().size() + classNode.getConstants().size() + functions;
   }
}
