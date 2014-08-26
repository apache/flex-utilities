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
package com.adobe.ac.pmd.ant;

import java.io.File;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.Task;

import com.adobe.ac.pmd.FlexPmdParameters;
import com.adobe.ac.pmd.FlexPmdViolations;
import com.adobe.ac.pmd.LoggerUtils;
import com.adobe.ac.pmd.engines.FlexPmdXmlEngine;
import com.adobe.ac.pmd.engines.PmdEngineUtils;

public class FlexPmdAntTask extends Task // NO_UCD
{
   private boolean failOnError;
   private boolean failOnRuleViolation;
   private File    outputDirectory;
   private String  packageToExclude;
   private File    ruleSet;
   private File    sourceDirectory;

   @Override
   public final void execute()
   {
      try
      {
         presetParameters();

         new LoggerUtils().loadConfiguration();

         final FlexPmdXmlEngine engine = new FlexPmdXmlEngine( new FlexPmdParameters( packageToExclude,
                                                                                      outputDirectory,
                                                                                      ruleSet,
                                                                                      sourceDirectory ) );
         final FlexPmdViolations violations = new FlexPmdViolations();

         engine.executeReport( violations );

         if ( failOnError )
         {
            final String message = PmdEngineUtils.findFirstViolationError( violations );

            if ( message.length() > 0 )
            {
               throw new BuildException( message );
            }
         }
         if ( failOnRuleViolation
               && !violations.getViolations().isEmpty() )
         {
            throw new BuildException( "At least one violation has been found" );
         }
      }
      catch ( final Exception e )
      {
         throw new BuildException( e );
      }
   }

   public final String getPackageToExclude()
   {
      return packageToExclude;
   }

   public final void setFailOnError( final boolean failOnErrorToBeSet )
   {
      failOnError = failOnErrorToBeSet;
   }

   public final void setFailOnRuleViolation( final boolean failOnRuleViolation )
   {
      this.failOnRuleViolation = failOnRuleViolation;
   }

   public final void setOutputDirectory( final File outputDirectoryToBeSet )
   {
      outputDirectory = outputDirectoryToBeSet;
   }

   public final void setPackageToExclude( final String packageToExcludeToBeSet )
   {
      packageToExclude = packageToExcludeToBeSet;
   }

   public final void setRuleSet( final File ruleSetToBeSet )
   {
      ruleSet = ruleSetToBeSet;
   }

   public final void setSourceDirectory( final File sourceDirectoryToBeSet )
   {
      sourceDirectory = sourceDirectoryToBeSet;
   }

   private void presetParameters()
   {
      if ( packageToExclude == null )
      {
         packageToExclude = "";
      }
   }
}
