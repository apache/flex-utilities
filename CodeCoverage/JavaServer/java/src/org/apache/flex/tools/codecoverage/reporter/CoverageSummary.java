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

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Summary of code coverage at the package, file, and method level.
 *
 */
public class CoverageSummary
{
    /**
     *  Used to return the results of splitting the debugfile string. 
     */
    private static class FilePathComponents
    {
        public String packageName;
        public String filename;
    }
    
    private static final TreeSet<String> emptyTreeSet = new TreeSet<String>();

    /**
     * The coverage data being summarized.
     */
    private final CoverageData coverageData;
    
    /**
     * Compiled regex patterns to include only specific files. 
     */
    private final Collection<Pattern> includeFilterPatterns = new ArrayList<Pattern>();
    
    /**
     * Compiled regex patterns to exclude only specific files. 
     */
    private final Collection<Pattern> excludeFilterPatterns = new ArrayList<Pattern>();
    
    /**
     * Coverage summary rolled up to the package level.
     * 
     * Key: package name
     * Value: PackageSummaryInfo
     */
    private final Map<String, PackageSummaryInfo> packageSummaryMap = 
            new TreeMap<String, PackageSummaryInfo>();

    /**
     * Coverage summary rolled up to the file level.
     * 
     * key: package;file
     * value: SummaryInfo.
     */
    private final Map<String, SummaryInfo> fileSummaryMap = 
            new TreeMap<String, SummaryInfo>();
    
    /**
     * Coverage summary for methods.
     * 
     * Key: method name
     * Value: SummaryInfo
     */
    private final Map<String, SummaryInfo> methodSummaryMap = 
            new TreeMap<String, SummaryInfo>();
    
    /**
     * Summary information for all packages being reported.
     */
    private final SummaryInfo overall = new AggregateSummaryInfo();
    
    /**
     * Association of methods in a file.
     * 
     * Key: package;filename
     * Value: Ordered set of method names.
     */
    private final Map<String, TreeSet<String>> methodsInFile =
            new HashMap<String, TreeSet<String>>();

    /**
     * Create a coverage summmary object. The coverage summary object
     * can process the coverage data and provide coverage data by 
     * package, file, and method.
     * 
     * @param coverageData the coverage data to generate the summary from.
     * @param includeFilters Regex filter patterns. Controls which files
     * are included in the coverage summary.
     * @param excludeFilters Regex filter patterns. Controls which files
     * are excluded in the coverage summary.
     * 
     */
    public CoverageSummary(final CoverageData coverageData, 
            final Collection<String> includeFilters,
            final Collection<String> excludeFilters)
    {
        this.coverageData = coverageData;
        
        initializePatterns(includeFilters, excludeFilters);
    }
    
    /**
     * Get the coverage data the summary is generated from.
     * @return the coverage data.
     */
    public CoverageData getCoverageData()
    {
        return coverageData;
    }

    /**
     * Get the aggregate summary info of all the included packages.
     * 
     * @return aggregate summary info.
     */
    public SummaryInfo getOverallSummaryInfo()
    {
        return overall;
    }
    
    /**
     * Entry set of all included packages.
     * 
     * @return Set of packages included in summary data.
     */
    public Set<Map.Entry<String, PackageSummaryInfo>> getPackageSummaryEntrySet()
    {
        return packageSummaryMap.entrySet();
    }
    
    /**
     * Entry set of all files included in the summary data.
     * 
     * @return Entry set
     */
    public Set<Map.Entry<String, SummaryInfo>> getFileSummaryEntrySet()
    {
        return fileSummaryMap.entrySet();
    }

    /**
     * Get the coverage summmary info for a specific file.
     * 
     * @param packageFileKey key formed by calling createPackageFileKey().
     * @return SummaryInfo for the specified file or null the file is
     * not included in the summary data.
     */
    public SummaryInfo getFileSummaryInfo(final String packageFileKey)
    {
        return fileSummaryMap.get(packageFileKey);
    }

    /**
     * Get the summary info for a specific method.
     * 
     * @param methodName The name of the method to get the summary info for.
     * @return SummyInfo for the specified method or null if the method is
     * not included in the summary data.
     */
    public SummaryInfo getMethodSummaryInfo(String methodName)
    {
        return methodSummaryMap.get(methodName);
    }
    
    /**
     * A set of methods declared in the specified file.
     * 
     * @param filename The name of the AS or MXML file.
     * @return Set of method names.
     */
    public Set<String> getMethodsInFile(String filename)
    {
        TreeSet<String> results = methodsInFile.get(filename);
        return results != null ? results : emptyTreeSet;
    }
    
    /**
     * Roll up the coverage data at a method, file, and package level.
     * If include filters and/or exclude filters are specified then
     * they are applied that this time.
     */
    public void processCoverageData()
    {
        // for all packages;files
        for (Map.Entry<String, Map<Integer, LineInfo>> fileEntry : coverageData.entrySet())
        {
            final String packageFile = fileEntry.getKey();
            final FilePathComponents fileComponents = splitPackageFile(packageFile);
            final SummaryInfo summaryInfo = new SummaryInfo();
            summaryInfo.setName(fileComponents.filename);
            
            // for all line numbers; 
            // 1. summary at the file level
            // 2. record execution status for each method.
            for (final Map.Entry<Integer, LineInfo> lineEntry : fileEntry.getValue().entrySet())
            {
                final LineInfo lineInfo = lineEntry.getValue();
                final String methodName = lineInfo.getMethodName();
                
                if (!shouldIncludeFile(fileComponents))
                    continue;
                
                summaryInfo.setLineExecutionStatus(lineInfo.getLineNumber(),
                        methodName, lineInfo.isExecuted());

                addMethodSummaryInfo(fileComponents.packageName,
                        fileComponents.filename, methodName, lineInfo);
            }

            addFileSummaryInfo(fileComponents.packageName,
                    fileComponents.filename, summaryInfo);
        }
    }
    
    /**
     * Determine if a file should be included in the summary.
     * If no include filters or exclude filters are specified then
     * all files are included.
     * 
     * @param pathComponents The package and file name to test.
     * @return true if the package should be included, false otherwise.
     */
    private boolean shouldIncludeFile(final FilePathComponents pathComponents)
    {
        String className = pathComponents.packageName + "." + pathComponents.filename;
        final int index = className.lastIndexOf('.');
        
        assert index != -1 : "no suffix found on filename";
        
        className = className.substring(0, index);
        
        // a class name is included if it is included by the pattern
        // and not exclude by the exclude filters.
        if (!(includeFilterPatterns.size() == 0) && 
            !matches(includeFilterPatterns, className))
        {
            return false;
        }
        
        if (!(excludeFilterPatterns.size() == 0) &&
            matches(excludeFilterPatterns, className))
        {
            return false;
        }
        
        return true;
    }

    /**
     * Utility to test is a string matches one of a set of patterns.
     * 
     * @param patterns Collection of patterns
     * @param value The value to match
     * @return true if the pattern matches, false otherwise.
     */
    private boolean matches(final Collection<Pattern> patterns, final String value)
    {
        for (Pattern pattern : patterns)
        {
            Matcher matcher = pattern.matcher(value);
            if (matcher.matches())
                return true;
        }

        return false;
    }
    
    /**
     * Create a combination package/file key.
     * 
     * @param packageName The package name part of the key.
     * @param filename THe filename part of the key.
     * @return Key for the package/file.
     */
    public String createPackageFileKey(final String packageName, final String filename)
    {
        return packageName + ";" + filename;
    }

    /**
     * Split a sourcePath;package/file string. These string come from the 
     * AS debug_file opcodes and are in the code coverage data files.
     * 
     * @param packageFile The string to split into components.
     * @return FilePathComponents
     */
    private FilePathComponents splitPackageFile(final String packageFile)
    {
        final String[] splitResults = packageFile.split(";");
        String packageName = splitResults.length > 1 ? 
                splitResults[splitResults.length - 2] : "";
        final String filename = splitResults[splitResults.length - 1];
        
        // convert '\' and '/' path separators to '.' package separators.
        if (packageName.length() > 0)
            packageName = packageName.replaceAll("[\\\\/]", ".");
        
        final FilePathComponents results = new FilePathComponents();
        results.packageName = packageName;
        results.filename = filename;
        
        return results;
    }

    /**
     * Aggregate summary information for a file.
     * 
     * This method takes summary information for a file
     * and aggregates them at the file, package, and overall coverage.
     * 
     * @param packageName Package name the summary info is for.
     * @param filename The file name the summary info is for.
     * @param summaryInfo The summary info to aggregate.
     */
    private void addFileSummaryInfo(final String packageName, final String filename, 
            final SummaryInfo summaryInfo)
    {
        if (summaryInfo.getTotalLineCount() == 0)
            return;
        
        // summarize at the package level
        fileSummaryMap.put(createPackageFileKey(packageName, filename), summaryInfo);
        PackageSummaryInfo packageSummaryInfo = packageSummaryMap.get(packageName);
        if (packageSummaryInfo == null)
        {
            packageSummaryInfo = new PackageSummaryInfo();
            packageSummaryInfo.getSummaryInfo().setName(packageName);
            packageSummaryMap.put(packageName, packageSummaryInfo);
        }

        packageSummaryInfo.addFile(packageName, filename);
        packageSummaryInfo.add(summaryInfo);
        
        // summary of all of the packages
        overall.add(summaryInfo);
    }
    
    /**
     * Add line coverage information about a method.
     * 
     * This method aggregates the line coverage information for a method.
     * 
     * @param packageName The name of the package the line info is from.
     * @param filename The name of the file the line info is from.
     * @param methodName The name of the method the line info is from.
     * @param lineInfo The line info.
     */
    private void addMethodSummaryInfo(final String packageName, final String filename, 
            final String methodName, final LineInfo lineInfo)
    {
        // ignore cinit and script init methods.
        if (methodName == null || methodName.isEmpty())
            return;
        
        // method summary info
        SummaryInfo methodSummaryInfo = methodSummaryMap.get(methodName);
        if (methodSummaryInfo == null)
        {
            methodSummaryInfo = new SummaryInfo();
            methodSummaryInfo.setName(methodName);
            methodSummaryMap.put(methodName, methodSummaryInfo);

            final String key = createPackageFileKey(packageName, filename);
            TreeSet<String> treeSet = methodsInFile.get(key);
            if (treeSet == null)
            {
                treeSet = new TreeSet<String>();
                treeSet.add(methodName);
                methodsInFile.put(key, treeSet);                
            }
            
            treeSet.add(methodName);
        }
        
        methodSummaryInfo.setLineExecutionStatus(lineInfo.getLineNumber(),
                methodName, lineInfo.isExecuted());
    }

    /**
     * Initialize the patterns for the include and exclude filters.
     * 
     * @param includeFilters regex strings of classes to include.
     * @param excludeFilters regex strings of classes to exclude.
     */
    private void initializePatterns(final Collection<String> includeFilters, 
            final Collection<String>excludeFilters)
    {
        for (final String includeFilter : includeFilters)
        {
            includeFilterPatterns.add(Pattern.compile(includeFilter));
        }

        for (final String excludeFilter : excludeFilters)
        {
            excludeFilterPatterns.add(Pattern.compile(excludeFilter));
        }
    }
    
}
