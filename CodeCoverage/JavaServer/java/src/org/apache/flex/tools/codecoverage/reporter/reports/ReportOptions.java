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

package org.apache.flex.tools.codecoverage.reporter.reports;

import java.util.Collection;

/**
 *  Code Coverage Report options. 
 *
 */
public class ReportOptions 
{
    private Collection<String> includeFilters;
    private Collection<String> excludeFilters;
    private boolean showPackages = true;
    private boolean showFiles = true;
    private boolean showMethods = true;
    private boolean showUnexecutedDetails = false;
    
    /**
     * Constructor.
     * 
     * @param includeFilters User specified include filters. 
     * Equivalent to the -includes command line argument. 
     * @param excludeFilters User specified exclude filters.
     * Equivalent to the -excludes command line argument. 
     * @param showPackages Determines if packages are listed in the report.
     * Equivalent to the -showPackages command line argument.
     * @param showFiles Determines if files are listed in the report. Files
     * will not be show if packages are not shown.
     * Equivalent to the -showFiles command line argument.
     * @param showMethods Determines if method are listed in the report.
     * Equivalent to the -showMethods command line argument.
     * @param showUnexecutedDetails Determines if unexecuted lines and methods are
     * listed in the report.
     * Equivalent to the -showUnexecutedDetails command line argument. 
     */
    public ReportOptions(Collection<String> includeFilters,
            Collection<String> excludeFilters, boolean showPackages,
            boolean showFiles, boolean showMethods,
            boolean showUnexecutedDetails)
    {
        super();
        this.includeFilters = includeFilters;
        this.excludeFilters = excludeFilters;
        this.showPackages = showPackages;
        this.showFiles = showFiles;
        this.showMethods = showMethods;
        this.showUnexecutedDetails = showUnexecutedDetails;
    }

    /**
     * User specified include filters. 
     * Equivalent to the -includes command line argument.
     *  
     * @return Collection of user filters.
     */
    public Collection<String> getIncludeFilters()
    {
        return includeFilters;
    }
    
    /**
     * Equivalent to the -includes command line argument.
     *  
     * @param includeFilters Collection of filters to include classes in the 
     * report. 
     */
    public void setIncludeFilters(Collection<String> includeFilters)
    {
        this.includeFilters = includeFilters;
    }

    /**
     * User specified exclude filters.
     * Equivalent to the -excludes command line argument. 
     * 
     * @return Collection of filters to exclude classes from the report.
     */
    public Collection<String> getExcludeFilters()
    {
        return excludeFilters;
    }

    /**
     * Equivalent to the -excludes command line argument. 
     *
     * @param excludeFilters Collection of filters to exclude classes from
     * the report.
     */
    public void setExcludeFilters(Collection<String> excludeFilters)
    {
        this.excludeFilters = excludeFilters;
    }
    
    /**
     * Determines if packages are listed in the report.
     * Equivalent to the -showPackages command line argument.
     * 
     * @return true if packages are listed in the report, false otherwise.
     */
    public boolean isShowPackages()
    {
        return showPackages;
    }

    /**
     * Determines if packages are listed in the report.
     * Equivalent to the -showPackages command line argument.
     * 
     * @param showPackages Set to true to show packages in the report.
     */
    public void setShowPackages(boolean showPackages)
    {
        this.showPackages = showPackages;
    }

    /**
     * Determines if files are listed in the report.
     * Equivalent to the -showFiles command line argument.
     * 
     * @return true if files are listed in the report, false otherwise.
     */
    public boolean isShowFiles()
    {
        return showFiles;
    }
    
    /**
     * Determines if files are listed in the report.
     * Equivalent to the -showFiles command line argument.
     * 
     * @param showFiles Set to true to show files in the report.
     */
    public void setShowFiles(boolean showFiles)
    {
        this.showFiles = showFiles;
    }
    
    /**
     * Determines if methods are listed in the report.
     * Equivalent to the -showMethods command line argument.
     * 
     * @return true if methods are listed in the report, false otherwise.
     */
    public boolean isShowMethods()
    {
        return showMethods;
    }

    /**
     * Determines if methods are listed in the report.
     * Equivalent to the -showMethods command line argument.
     * 
     * @param showFiles Set to true to show methods in the report.
     */
    public void setShowMethods(boolean showMethods)
    {
        this.showMethods = showMethods;
    }
    
    /**
     * Determines if unexecuted lines and unexecuted methods are listed in the
     * report.
     * Equivalent to the -showUnexecutedDetails command line argument.
     * 
     * @return true if unexecuted lines and unexecuted are listed in the 
     * report, false otherwise.
     */
    public boolean isShowUnexecutedDetails()
    {
        return showUnexecutedDetails;
    }

    /**
     * Determines if unexecuted lines and unexecuted methods are listed in the
     * report.
     * Equivalent to the -showUnexecutedDetails command line argument.
     * 
     * @param showUnexecutedDetails Set to true to show methods in the report.
     */
    public void setShowUnexecutedDetails(boolean showUnexecutedDetails)
    {
        this.showUnexecutedDetails = showUnexecutedDetails;
    }

}
