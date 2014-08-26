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
package com.adobe.ac.pmd;

import java.io.File;
import java.util.List;

public class FlexPmdParameters
{
   private final String       excludePackage;
   private final boolean      failOnError;
   private final boolean      failOnRuleViolation;
   private final File         outputDirectory;
   private final File         ruleSet;
   private final File         source;
   private final List< File > sourceList;

   public FlexPmdParameters( final String excludePackageToBeSet,
                             final boolean failOnErrorToBeSet,
                             final boolean failOnRuleViolationToBeSet,
                             final File outputDirectoryToBeSet,
                             final File ruleSetToBeSet,
                             final File sourceToBeSet )
   {
      this( excludePackageToBeSet,
            failOnErrorToBeSet,
            failOnRuleViolationToBeSet,
            outputDirectoryToBeSet,
            ruleSetToBeSet,
            sourceToBeSet,
            null );
   }

   public FlexPmdParameters( final String excludePackageToBeSet,
                             final boolean failOnErrorToBeSet,
                             final boolean failOnRuleViolationToBeSet,
                             final File outputDirectoryToBeSet,
                             final File ruleSetToBeSet,
                             final File sourceToBeSet,
                             final List< File > sourceListToBeSet )
   {
      super();
      excludePackage = excludePackageToBeSet;
      failOnError = failOnErrorToBeSet;
      failOnRuleViolation = failOnRuleViolationToBeSet;
      outputDirectory = outputDirectoryToBeSet;
      ruleSet = ruleSetToBeSet;
      source = sourceToBeSet;
      sourceList = sourceListToBeSet;
   }

   public FlexPmdParameters( final String excludePackageToBeSet,
                             final File outputDirectoryToBeSet,
                             final File ruleSetToBeSet,
                             final File sourceToBeSet )
   {
      this( excludePackageToBeSet, false, false, outputDirectoryToBeSet, ruleSetToBeSet, sourceToBeSet, null );
   }

   public FlexPmdParameters( final String excludePackageToBeSet,
                             final File outputDirectoryToBeSet,
                             final File ruleSetToBeSet,
                             final File sourceToBeSet,
                             final List< File > sourceListToBeSet )
   {
      this( excludePackageToBeSet,
            false,
            false,
            outputDirectoryToBeSet,
            ruleSetToBeSet,
            sourceToBeSet,
            sourceListToBeSet );
   }

   public final String getExcludePackage()
   {
      return excludePackage;
   }

   public final File getOutputDirectory()
   {
      return outputDirectory;
   }

   public final File getRuleSet()
   {
      return ruleSet;
   }

   public final File getSource()
   {
      return source;
   }

   public List< File > getSourceList()
   {
      return sourceList;
   }

   public final boolean isFailOnError()
   {
      return failOnError;
   }

   public boolean isFailOnRuleViolation()
   {
      return failOnRuleViolation;
   }
}
