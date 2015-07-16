/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

package org.apache.flex.tools.codecoverage.reporter;

import java.util.Set;
import java.util.TreeSet;

/**
 *  Summary of a package's coverage information.
 *  Contains coverage summary of all of the files in the package.
 */
public class PackageSummaryInfo
{
    private Set<String> filesInPackage = new TreeSet<String>();
    private SummaryInfo summaryInfo = new AggregateSummaryInfo();
    
    /**
     * Set of files in a package.
     * 
     * @return The set files in the package. Each item in the
     * set is a combined package name/filename in the following
     * format: "packageName;filename".
     */
    public Set<String> getFilesInPackage()
    {
        return filesInPackage;
    }

    /**
     * Add a file to this package summary info.
     * 
     * @param packageName The package name to add the summary info to.
     * @param filename The name of file to add to the package.
     */
    public void addFile(final String packageName, final String filename)
    {
        filesInPackage.add(packageName + ";" + filename);
    }
    
    /**
     * The rolled up summary info for a package.
     * 
     * @return SummaryInfo
     */
    public SummaryInfo getSummaryInfo()
    {
        return summaryInfo;
    }
    
    /**
     * Aggregate summary info to this package.
     * 
     * @param info The summary info.
     */
    public void add(final SummaryInfo info)
    {
        summaryInfo.add(info);
    }
    
}
