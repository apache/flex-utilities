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
package com.adobe.ac.pmd.metrics.maven.utils;

import org.apache.maven.project.MavenProject;
import org.dom4j.Document;

public final class ModuleReport
{
    /**
     * The MavenProject associated with the report.
     */
    private MavenProject module;

    /**
     * The Report associated with the MavenProject
     */
    private Document     report;

    public ModuleReport( final MavenProject project,
                         final Document document )
    {
        module = project;
        report = document;
    }

    public Document getJavancssDocument()
    {
        return report;
    }

    public MavenProject getModule()
    {
        return module;
    }

    public void setModule( final MavenProject project )
    {
        this.module = project;
    }

    public void setReport( final Document javancssDocument )
    {
        this.report = javancssDocument;
    }
}