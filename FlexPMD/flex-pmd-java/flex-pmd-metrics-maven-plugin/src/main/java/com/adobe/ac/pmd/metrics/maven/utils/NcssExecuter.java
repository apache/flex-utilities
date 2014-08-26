package com.adobe.ac.pmd.metrics.maven.utils;

/*
 * Copyright 2004-2005 The Apache Software Foundation.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import java.io.File;
import java.io.IOException;

import org.apache.maven.reporting.MavenReportException;
import org.dom4j.DocumentException;

import com.adobe.ac.pmd.metrics.engine.FlexMetrics;

public final class NcssExecuter
{
   private final double mxmlFactor;
   private final File   outputDirectory;
   private final File   sourceLocation;

   public NcssExecuter( final File sourceLocationToBeSet,
                        final File outputDirectoryToBeSet,
                        final double mxmlFactorToBeSet )
   {
      sourceLocation = sourceLocationToBeSet;
      outputDirectory = outputDirectoryToBeSet;
      mxmlFactor = mxmlFactorToBeSet;
   }

   public void execute() throws MavenReportException,
                        DocumentException,
                        IOException
   {
      new FlexMetrics( sourceLocation, mxmlFactor ).execute( outputDirectory );
   }
}
