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

import com.adobe.ac.pmd.nodes.IAttribute;
import com.adobe.ac.pmd.nodes.IClass;
import com.adobe.ac.pmd.nodes.IFunction;

public final class InternalFunctionMetrics
{
   public static InternalFunctionMetrics create( final ProjectMetrics metrics,
                                                 final String packageFullName,
                                                 final IClass classNode )
   {
      int ncssInClass = 0;
      int asDocsInClass = 0;
      int multipleLineCommentInClass = 0;

      for ( final IFunction function : classNode.getFunctions() )
      {
         final int multipleDoc = MetricUtils.computeMultiLineComments( function );
         final int asDocs = MetricUtils.computeAsDocs( function );

         ncssInClass += function.getStatementNbInBody();
         multipleLineCommentInClass += multipleDoc;

         asDocsInClass += asDocs;

         metrics.getFunctionMetrics().add( FunctionMetrics.create( packageFullName,
                                                                   classNode,
                                                                   function,
                                                                   asDocs,
                                                                   multipleDoc ) );
      }

      for ( final IAttribute attribute : classNode.getAttributes() )
      {
         asDocsInClass += MetricUtils.computeAsDocs( attribute );
      }

      return new InternalFunctionMetrics( ncssInClass, asDocsInClass, multipleLineCommentInClass );
   }

   private final int asDocsInClass;
   private final int multipleLineCommentInClass;
   private final int ncssInClass;

   private InternalFunctionMetrics( final int ncssInClassToBeSet,
                                    final int asDocsInClassToBeSet,
                                    final int multipleLineCommentInClassToBeSet )
   {
      ncssInClass = ncssInClassToBeSet;
      asDocsInClass = asDocsInClassToBeSet;
      multipleLineCommentInClass = multipleLineCommentInClassToBeSet;
   }

   public int getAsDocsInClass()
   {
      return asDocsInClass;
   }

   public int getMultipleLineCommentInClass()
   {
      return multipleLineCommentInClass;
   }

   public int getNcssInClass()
   {
      return ncssInClass;
   }
}