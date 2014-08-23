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

import com.adobe.ac.pmd.nodes.IAsDocHolder;
import com.adobe.ac.pmd.nodes.ICommentHolder;
import com.adobe.ac.pmd.parser.IParserNode;

public final class MetricUtils
{
   public static int computeAsDocs( final IAsDocHolder attribute )
   {
      return attribute.getAsDoc() == null ? 0
                                         : computeNbOfLines( attribute.getAsDoc().getStringValue() );
   }

   public static int computeMultiLineComments( final ICommentHolder commentHolder )
   {
      int lines = 0;

      for ( final IParserNode comment : commentHolder.getMultiLinesComment() )
      {
         lines += comment.getStringValue() == null ? 0
                                                  : MetricUtils.computeNbOfLines( comment.getStringValue() );
      }
      return lines;
   }

   public static int computeNbOfLines( final String lines )
   {
      return lines.split( "\\n" ).length;
   }

   public static String getQualifiedName( final File sourceDirectory,
                                          final File file )
   {
      final String qualifiedName = file.getAbsolutePath().replace( sourceDirectory.getAbsolutePath(),
                                                                   "" ).replace( "/",
                                                                                 "." ).replace( "\\",
                                                                                                "." ).trim();

      if ( qualifiedName.length() > 0
            && qualifiedName.charAt( 0 ) == '.' )
      {
         return qualifiedName.substring( 1 );
      }

      return qualifiedName;
   }

   private MetricUtils()
   {
   }
}
