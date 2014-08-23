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
package com.adobe.ac.pmd.maven;

import java.util.Locale;

import net.sourceforge.pmd.PMDException;

import org.apache.maven.project.MavenProject;
import org.apache.maven.reporting.MavenReportException;

import com.adobe.ac.pmd.FlexPmdParameters;
import com.adobe.ac.pmd.FlexPmdViolations;

/**
 * @author xagnetti
 * @goal report
 * @phase site
 */
public class FlexPmdReportMojo extends AbstractFlexPmdMojo
{
   /**
    * Specifies the location of the source files to be used.
    * 
    * @parameter default-value="false"
    * @required
    * @readonly
    */
   private boolean aggregate;

   public FlexPmdReportMojo()
   {
      super();
   }

   public FlexPmdReportMojo( final MavenProject projectToBeSet,
                             final FlexPmdParameters parameters )
   {
      super( projectToBeSet, parameters );
   }

   @Override
   protected void onXmlReportExecuted( final FlexPmdViolations violations,
                                       final Locale locale ) throws MavenReportException
   {
      super.onXmlReportExecuted( violations,
                                 locale );

      final FlexPmdParameters parameters = new FlexPmdParameters( getExcludePackage(),
                                                                  getOutputDirectoryFile(),
                                                                  getRuleSet(),
                                                                  getSourceDirectory() );
      final FlexPmdHtmlEngine flexPmdHtmlEngine = new FlexPmdHtmlEngine( getSink(),
                                                                         getBundle( locale ),
                                                                         aggregate,
                                                                         getProject(),
                                                                         parameters );

      try
      {
         flexPmdHtmlEngine.executeReport( violations );
      }
      catch ( final PMDException e )
      {
         throw new MavenReportException( "An exception has been thrown while executing the HTML report", e );
      }
   }
}
