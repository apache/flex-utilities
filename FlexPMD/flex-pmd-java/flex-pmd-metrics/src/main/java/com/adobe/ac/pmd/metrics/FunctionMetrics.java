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

import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IFunction;

public final class FunctionMetrics extends AbstractNamedMetrics
{
   static FunctionMetrics create( final String packageFullName,
                                  final IClass classNode,
                                  final IFunction function,
                                  final int asDocs,
                                  final int multipleDoc )
   {
      return new FunctionMetrics( function.getStatementNbInBody(), // NOPMD
                                  function.getName(),
                                  packageFullName.compareTo( "" ) == 0 ? classNode.getName()
                                                                      : packageFullName
                                                                            + "." + classNode.getName(),
                                  function.getCyclomaticComplexity(),
                                  asDocs,
                                  multipleDoc );
   }

   private FunctionMetrics( final int nonCommentStatements,
                            final String name,
                            final String packageName,
                            final int ccn,
                            final int asDocs,
                            final int multiLineCommentsToBeSet )
   {
      super( nonCommentStatements, name, packageName, ccn, asDocs, multiLineCommentsToBeSet );
   }

   public String getContreteXml()
   {
      return "";
   }

   @Override
   public String getFullName()
   {
      return getPackageName().compareTo( "" ) == 0 ? getName()
                                                  : getPackageName()
                                                        + "::" + getName();
   }

   @Override
   public String getMetricsName()
   {
      return "function";
   }

   @Override
   protected int getNcss()
   {
      return 1;
   }
}
