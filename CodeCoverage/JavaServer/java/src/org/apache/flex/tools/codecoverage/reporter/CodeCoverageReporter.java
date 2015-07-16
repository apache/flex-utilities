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

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

import org.apache.flex.tools.codecoverage.reporter.reports.IReportFactory;
import org.apache.flex.tools.codecoverage.reporter.reports.IReportWriter;
import org.apache.flex.tools.codecoverage.reporter.reports.ReportOptions;
import org.apache.flex.tools.codecoverage.reporter.reports.XMLReportFactory;
import org.apache.flex.tools.codecoverage.reporter.swf.SWFLineReporter;

/**
 * Analyzes code coverage data files and produces a report.
 * 
 * This class can be run from the command line and accept arguments to control
 * the format of the report.
 *
 */
public class CodeCoverageReporter
{
    /**
     * Extension for code coverage reports.
     */
    private static final String DEFAULT_REPORT_NAME = "ccreport.xml";
    private static final String DEFAULT_DATA_DIRECTORY = "ccdata";
    
    private static final String CCREPORTER_VERSION = "0.9.1";
    
    /**
     * CodeCovergeReporter will read code code coverage result files and
     * generate reports.
     * 
     */
    public static void main(String[] args) throws IOException
    {
        // This message should not be localized.
        System.out.println("Apache Flex Code Coverage Reporter");
        System.out.println("Version " + CCREPORTER_VERSION);
        System.out.println("");

        if (args.length == 1 && "-help".equals(args[0]))
        {
            displayUsage();
            System.exit(1);
        }

        CodeCoverageReporter reporter = new CodeCoverageReporter();
        reporter.processArgs(args);
        
        System.out.println("Analyzing " + reporter.files.size() + " files");
        
        try
        {
            final CoverageData coverageData = new CoverageData();

            // analyzes the files and then report the results.
            for (File file : reporter.files)
            {
                reporter.analyze(file, coverageData);
            }

            final CoverageSummary coverageSummary = reporter.createCoverageSummary(coverageData); 
            reporter.createReport(coverageSummary);

            // output high level coverage to the console
            reporter.outputCoverageSummaryToConsole(coverageSummary);

            System.out.println("Report output to " + reporter.reportFile.getAbsolutePath());
        }
        catch (Error e)
        {
            e.printStackTrace();

            System.err.println("");
            System.err.println("An unrecoverable error occurred.");
        }
    }
    
    /**
     * Create a regex string from a given user input string that can have
     * wild cards but is not a regex pattern. 
     * Supports simple wild cards: '*', '?'
     * 
     * @param userFilter user supplied filter that may only contain the '*' and '?'
     *  wild card characters. All other cards will have no special meaning.
     */
    private static String createRegexStringFromUserArg(String userFilter)
    {
        // substitute regex for user wild cards.
        StringBuilder regexString = new StringBuilder("^");
        String[] results = userFilter.split("[\\?\\*]");
        int currentIndex = 0;

        for (String filter : results)
        {
            currentIndex += filter.length();
            
            if (filter.length() > 0)
            {
                regexString.append("\\Q");
                regexString.append(filter);
                regexString.append("\\E");
            }
            
            if (currentIndex < userFilter.length())
            {
                if (userFilter.charAt(currentIndex) == '*')
                {
                    regexString.append(".*");
                }
                else if (userFilter.charAt(currentIndex) == '?')
                {
                    regexString.append(".?");
                }
            }
            
            currentIndex++; // skip past wild card
        }
        
        regexString.append("$");
        return regexString.toString();
    }

    public static Collection<File> listFiles(final File dir)
    {
        final String[] fileNames = dir.list();

        if (fileNames == null)
        {
            return Collections.emptyList();
        }

        final Collection<File> fileList = new ArrayList<File>(fileNames.length);
        for (int i = 0; i < fileNames.length; i++)
        {
            fileList.add(new File(dir.getPath(), fileNames[i]));
        }
        
        return fileList;
    }

    private void outputCoverageSummaryToConsole(final CoverageSummary coverageSummary)
    {
        System.out.println("Results:");
        
        final SummaryInfo summaryInfo = coverageSummary.getOverallSummaryInfo();
        int executed = summaryInfo.getExecutedLineCount();
        int total = summaryInfo.getTotalLineCount();
        int percent = total == 0 ? 0 : executed * 100 / total;
        System.out.println("Line Coverage:   " +  percent + "%");

        executed = summaryInfo.getExecutedMethodCount();
        total = summaryInfo.getTotalMethodCount();
        percent = total == 0 ? 0 : executed * 100 / total;
        System.out.println("Method Coverage: " +  percent + "%");
    }

    private static void displayUsage()
    {
        System.out.println("Usage: ccreporter");
        System.out.println("[-exclude filter]");
        System.out.println("[-help]");
        System.out.println("[-hide-unexecuted]");
        System.out.println("[-hide-files]");
        System.out.println("[-hide-methods]");
        System.out.println("[-hide-packages]");
        System.out.println("[-include filter]");
        System.out.println("[-output filename]");
        System.out.println("[-report-factory");
        System.out.println("[filename | directory name]*");
    }

    /**
     * The report file.
     */
    private File reportFile;
    
    /**
     * Collection of data files to analyze.
     */
    private Collection<File> files;
    
    /**
     * User filters converted to regex.
     */
    private Collection<String> includeFilters;
    private Collection<String> excludeFilters;
    
    /**
     * Raw user filters as input.
     */
    private Collection<String> userIncludeFilters;
    private Collection<String> userExcludeFilters;
    private boolean showPackages = true;
    private boolean showFiles = true;
    private boolean showMethods = true;
    private boolean showUnexecutedDetails = false;
    
    /**
     * User can specify their own report factory.
     */
    private String reportFactory;
    
    /**
     * Create a code coverage reporter.
     * 
     */
    public CodeCoverageReporter()
    {
    }

    /**
     * Parse the command line arguments and set the instance variables of
     * the reporter.
     * 
     * @param args User specified arguments.
     */
    public void processArgs(final String[] args)
    {
        int index = 0;
        File reportFile = null;
        List<String> includeFilters = new ArrayList<String>();
        List<String> excludeFilters = new ArrayList<String>();
        List<String> userIncludeFilters = new ArrayList<String>();
        List<String> userExcludeFilters = new ArrayList<String>();
        boolean showPackages = true;
        boolean showFiles = true;
        boolean showMethods = true;
        boolean showUnexecutedDetails = true;
        String reportFactory = null;
        
        while ((index < args.length) && (args[index].startsWith("-")))
        {
            switch (args[index])
            {
                case "-include":
                {
                    userIncludeFilters.add(args[++index]);
                    includeFilters.add(createRegexStringFromUserArg(args[index]));
                    index++;                    
                    break;
                }
                case "-exclude":
                {
                    userExcludeFilters.add(args[++index]);
                    excludeFilters.add(createRegexStringFromUserArg(args[index]));
                    index++;                    
                    break;
                }
                case "-include-regex":
                {
                    includeFilters.add(args[++index]);
                    index++;                    
                    break;
                }
                case "-exclude-regex":
                {
                    excludeFilters.add(args[++index]);
                    index++;                    
                    break;
                }
                case "-output":
                {
                    reportFile = new File(args[++index]);
                    index++;                    
                    break;
                }
                case "-hide-unexecuted":
                {
                    showUnexecutedDetails = false;
                    index++;                    
                    break;
                }
                case "-hide-methods":
                {
                    showMethods = false;
                    index++;                    
                    break;
                }
                case "-hide-files":
                {
                    showFiles = false;
                    index++;                    
                    break;
                }
                case "-hide-packages":
                {
                    showPackages = false;
                    index++;                    
                    break;
                }
                case "-report-factory":
                {
                    reportFactory = args[++index];
                    index++;                    
                    break;
                }
                default:
                {
                    System.err.println("unknown argument " + args[index]);
                    index++;                    
                    System.exit(1);
                }
            }
        }

        if (reportFile == null)
            reportFile = new File(DEFAULT_REPORT_NAME);

        Collection<String>filenames = new ArrayList<String>();
        Collection<File> files = new ArrayList<File>();

        // Collect filenames/directories from user args.
        // If no files specified look in the default data directory.
        if (index >= args.length)
        {
            filenames.add(new File(System.getProperty("user.home"), DEFAULT_DATA_DIRECTORY).getAbsolutePath());
        }
        else
        {
            for (int i = index; i < args.length; i++)
            {
                filenames.add(args[i]);
            }
        }

        // validate files
        for (String filename : filenames)
        {
            File file = new File(filename);
            
            if (!file.exists())
            {
                System.err.println("File not found: " + file.getAbsolutePath());
                System.exit(1);
            }
            else
            {
                if (file.isDirectory())
                {
                    Collection<File> newFiles = listFiles(file); 
                    files.addAll(newFiles);
                    System.out.println("Found " + newFiles.size() + " files in " + file.getAbsolutePath());
                }
                else
                {
                    files.add(file);
                    System.out.println("Found " + file.getAbsolutePath());
                }
            }            
            
        }

        this.includeFilters = includeFilters;
        this.excludeFilters = excludeFilters;
        this.userIncludeFilters = userIncludeFilters;
        this.userExcludeFilters = userExcludeFilters;
        this.showUnexecutedDetails = showUnexecutedDetails;
        this.showMethods = showMethods;
        this.showFiles = showFiles;
        this.showPackages = showPackages;
        this.files = files;
        this.reportFile = reportFile;
        this.reportFactory = reportFactory;
    }

    /**
     * Read in a code coverage raw file and output raw code coverage data.
     * 
     * @param inFile
     *            Code coverage execution data.
     * @throws IOException
     * @throws FileNotFoundException
     */
    public void analyze(final File inFile, final CoverageData coverageData)
            throws FileNotFoundException, IOException
    {
        try (BufferedReader reader = new BufferedReader(new FileReader(inFile)))
        {
            String inLine;
            final ArrayList<String> stringPool = new ArrayList<String>();
            int inLineNumber = 1;

            while ((inLine = reader.readLine()) != null)
            {
                // test first char:
                // @{path} the SWF's path
                // #{id,string} defines an id string
                char firstChar = inLine.charAt(0);
                
                switch (firstChar)
                {
                    case '@':   // @swfURL
                    {
                        // read in SWF and analyze
                        String swfURL = inLine.substring(1); 
                        SWFLineReporter swfLineReporter = new SWFLineReporter(swfURL);
                        swfLineReporter.readLines(coverageData);
                        break;
                    }
                    case '#':   // instruction: packageFileID,packageFileString
                    {
                        // add id to pool
                        String[] results = inLine.substring(1).split(",");

                        assert results.length == 2 : "line " + inLineNumber
                                + System.lineSeparator()
                                + "improperly formatted line"
                                + System.lineSeparator() + inLine;

                        assert !stringPool.contains(results[1]) : "line "
                                + inLineNumber + System.lineSeparator()
                                + "string is already in the string pool: "
                                + results[1];

                        assert Integer.valueOf(results[0]) == stringPool.size() : "line "
                                + inLineNumber
                                + System.lineSeparator()
                                + "string is already in the string pool: "
                                + results[1];

                        stringPool.add(results[1]);
                        break;
                    }
                    default:
                    {
                        // "id,linenum"
                        // Split line and record linenum as a hit.
                        String[] results = inLine.split(",");
                        if (results.length == 2 && firstChar >= '0' && firstChar <= '9')
                        {
                            String file = stringPool.get(Integer.valueOf(results[0]));
                            int hitLineNumber = Integer.valueOf(results[1]);
                            coverageData.setLineExecuted(file, hitLineNumber);
                            break;                            
                        }
                        else
                        {
                            System.err.println("Warning: file " + inFile.getAbsolutePath() + ", line " + inLineNumber + ": unrecognized data, " + inLine);
                        }
                    }
                }

                inLineNumber++;
            }
        }
        catch (NumberFormatException e)
        {
            System.err.println(inFile.getAbsolutePath() + " may not be a code coverage data file");
            throw new IOException(e);
        }
    }

    /**
     * Create a code coverage report. The report summarizes the code coverage by
     * package, file, and method. The report is output to the file specified
     * by the user.
     * 
     * @param coverageSummary A summary of the coverage data.
     * @throws IOException 
     */
    public void createReport(final CoverageSummary coverageSummary) throws IOException
    {
        createXMLReport(coverageSummary);
    }

    /**
     * Create a summary of the raw code coverage data.
     * 
     * @param coverageData
     * @return
     */
    protected CoverageSummary createCoverageSummary(final CoverageData coverageData)
    {
        final CoverageSummary coverageSummary = new CoverageSummary(coverageData, 
                includeFilters, excludeFilters);
        
        coverageSummary.processCoverageData();
        return coverageSummary;
    }
    
    /**
     * Output an XML report to the reportFile.
     * 
     * @param coverageSummary A summary of the coverage data.
     * @throws IOException 
     */
    protected void createXMLReport(final CoverageSummary coverageSummary) throws IOException 
    {
        Class<?> classFactory = null;
        IReportFactory factory = null;
        
        if (reportFactory != null)
        {
            try
            {
                classFactory = Class.forName(reportFactory);
                factory = (IReportFactory) classFactory.newInstance();
            }
            catch (ClassNotFoundException | InstantiationException | IllegalAccessException e)
            {
                // fallback to default report writer
                e.printStackTrace();
                System.err.println("Report factory not found," + reportFactory);
            }
        }

        if (factory == null)
            factory = new XMLReportFactory();
        
        final ReportOptions reportOptions = new ReportOptions(userIncludeFilters, userExcludeFilters,
                showPackages, showFiles, showMethods, showUnexecutedDetails);
        final IReportWriter reportWriter = factory.createReport(reportOptions);
        try (final FileWriter fileWriter = new FileWriter(reportFile);
                final BufferedWriter bufferedWriter = new BufferedWriter(fileWriter))
        {
            reportWriter.writeTo(bufferedWriter, coverageSummary);
        }
    }

}
