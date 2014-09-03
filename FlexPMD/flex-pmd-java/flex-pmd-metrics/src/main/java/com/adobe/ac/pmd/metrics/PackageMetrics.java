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
import java.text.MessageFormat;
import java.util.Collection;

public final class PackageMetrics extends AbstractPackagedMetrics
{
   public static PackageMetrics create( final Collection< File > classesInPackage,
                                        final String packageFullName,
                                        final int functionsInPackage,
                                        final int ncssInPackage,
                                        final int asDocsInPackage,
                                        final int multipleLineCommentInPackage,
                                        final int imports )
   {
      return new PackageMetrics( ncssInPackage,// NOPMD
                                 functionsInPackage,
                                 classesInPackage.size(),
                                 packageFullName,
                                 asDocsInPackage,
                                 multipleLineCommentInPackage,
                                 imports );
   }

   private final int classes;
   private final int functions;
   private final int imports;

   private PackageMetrics( final int nonCommentStatements,
                           final int functionsToBeSet,
                           final int classesToBeSet,
                           final String packageName,
                           final int asDocs,
                           final int multiLineComments,
                           final int importsToBeSet )
   {
      super( nonCommentStatements, packageName, 0, asDocs, multiLineComments );
      functions = functionsToBeSet;
      classes = classesToBeSet;
      imports = importsToBeSet;
   }

   public int getClasses()
   {
      return classes;
   }

   public String getContreteXml()
   {
      return new StringBuffer().append( MessageFormat.format( "<functions>{0}</functions>"
                                                                    + "<classes>{1}</classes>",
                                                              String.valueOf( functions ),
                                                              String.valueOf( classes ) ) ).toString();
   }

   @Override
   public String getFullName()
   {
      return getPackageName();
   }

   public int getFunctions()
   {
      return functions;
   }

   @Override
   public String getMetricsName()
   {
      return "package";
   }

   @Override
   protected int getNcss()
   {
      return imports + 1;
   }
}