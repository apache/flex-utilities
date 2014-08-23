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
package com.adobe.ac.cpd.commandline;

import java.io.File;
import java.util.List;

public class FlexCpdParameters
{
   private final Integer      minimumTokenCount;
   private final File         outputFile;
   private final File         sourceDirectory;
   private final List< File > sourceList;

   public FlexCpdParameters( final File outputFileToBeSet,
                             final Integer minimumTokenCountToBeSet,
                             final File sourceDirectoryToBeSet,
                             final List< File > sourceListToBeSet )
   {
      super();
      minimumTokenCount = minimumTokenCountToBeSet;
      outputFile = outputFileToBeSet;
      sourceDirectory = sourceDirectoryToBeSet;
      sourceList = sourceListToBeSet;
   }

   public final Integer getMinimumTokenCount()
   {
      return minimumTokenCount;
   }

   public final File getOutputFile()
   {
      return outputFile;
   }

   public final File getSourceDirectory()
   {
      return sourceDirectory;
   }

   public List< File > getSourceList()
   {
      return sourceList;
   }
}
