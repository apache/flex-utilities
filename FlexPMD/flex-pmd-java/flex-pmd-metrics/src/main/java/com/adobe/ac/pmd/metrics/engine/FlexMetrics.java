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

import java.io.File;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.logging.Logger;

import net.sourceforge.pmd.PMDException;

import com.adobe.ac.ncss.filters.FlexFilter;
import com.adobe.ac.ncss.utils.FileUtils;
import com.adobe.ac.pmd.files.FileSetUtils;
import com.adobe.ac.pmd.files.IFlexFile;
import com.adobe.ac.pmd.metrics.AverageClassMetrics;
import com.adobe.ac.pmd.metrics.AverageFunctionMetrics;
import com.adobe.ac.pmd.metrics.ClassMetrics;
import com.adobe.ac.pmd.metrics.InternalFunctionMetrics;
import com.adobe.ac.pmd.metrics.MetricUtils;
import com.adobe.ac.pmd.metrics.PackageMetrics;
import com.adobe.ac.pmd.metrics.ProjectMetrics;
import com.adobe.ac.pmd.metrics.TotalPackageMetrics;
import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IPackage;

public final class FlexMetrics extends AbstractMetrics
{
   private static final FlexFilter       FLEX_FILTER = new FlexFilter();
   private static final Logger           LOGGER      = Logger.getLogger( FlexMetrics.class.getName() );

   private final Map< String, IPackage > asts;
   private final double                  mxmlFactor;

   public FlexMetrics( final File sourceDirectoryPath,
                       final double mxmlFactorToBeSet )
   {
      super( sourceDirectoryPath );

      asts = initAst();
      mxmlFactor = mxmlFactorToBeSet;
   }

   @Override
   public ProjectMetrics loadMetrics()
   {
      final ProjectMetrics metrics = new ProjectMetrics();

      for ( final File directory : getNonEmptyDirectories() )
      {
         final Collection< File > classesInPackage = FileUtils.listFiles( directory,
                                                                          FLEX_FILTER,
                                                                          false );

         if ( directory.isDirectory()
               && !classesInPackage.isEmpty() )
         {
            final String packageFullName = MetricUtils.getQualifiedName( getSourceDirectory(),
                                                                         directory );
            int functionsInPackage = 0;
            int ncssInPackage = 0;
            int asDocsInPackage = 0;
            int multipleLineCommentInPackage = 0;
            final int importsInPackage = 0;

            for ( final File fileInPackage : classesInPackage )
            {
               IClass classNode = null;
               InternalFunctionMetrics functionMetrics = null;
               final IFlexFile file = com.adobe.ac.pmd.files.impl.FileUtils.create( fileInPackage,
                                                                                    getSourceDirectory() );
               if ( asts.containsKey( file.getFullyQualifiedName() )
                     && asts.get( file.getFullyQualifiedName() ).getClassNode() != null )
               {
                  classNode = asts.get( file.getFullyQualifiedName() ).getClassNode();
                  functionsInPackage += classNode.getFunctions().size();
                  functionMetrics = InternalFunctionMetrics.create( metrics,
                                                                    packageFullName,
                                                                    classNode );
                  asDocsInPackage += functionMetrics.getAsDocsInClass();
                  multipleLineCommentInPackage += functionMetrics.getMultipleLineCommentInClass();
                  ncssInPackage += functionMetrics.getNcssInClass();
               }
               final ClassMetrics classMetrics = ClassMetrics.create( packageFullName,
                                                                      fileInPackage,
                                                                      functionMetrics,
                                                                      classNode,
                                                                      file,
                                                                      mxmlFactor );
               asDocsInPackage += classMetrics.getAsDocs();
               multipleLineCommentInPackage += classMetrics.getMultiLineComments();
               metrics.getClassMetrics().add( classMetrics );
            }
            metrics.getPackageMetrics().add( PackageMetrics.create( classesInPackage,
                                                                    packageFullName,
                                                                    functionsInPackage,
                                                                    ncssInPackage,
                                                                    asDocsInPackage,
                                                                    multipleLineCommentInPackage,
                                                                    importsInPackage ) );
         }
      }
      setFinalMetrics( metrics );

      return metrics;
   }

   private Map< String, IPackage > initAst()
   {
      Map< String, IPackage > result = new LinkedHashMap< String, IPackage >();
      try
      {
         result = FileSetUtils.computeAsts( com.adobe.ac.pmd.files.impl.FileUtils.computeFilesList( getSourceDirectory(),
                                                                                                    null,
                                                                                                    "",
                                                                                                    null ) );
      }
      catch ( final PMDException e )
      {
         LOGGER.warning( e.getMessage() );
      }
      return result;
   }

   private void setFinalMetrics( final ProjectMetrics metrics )
   {
      metrics.setTotalPackages( TotalPackageMetrics.create( metrics.getPackageMetrics() ) );
      metrics.setAverageFunctions( AverageFunctionMetrics.create( metrics.getFunctionMetrics(),
                                                                  metrics.getTotalPackages() ) );
      metrics.setAverageObjects( AverageClassMetrics.create( metrics.getClassMetrics(),
                                                             metrics.getTotalPackages() ) );
   }
}