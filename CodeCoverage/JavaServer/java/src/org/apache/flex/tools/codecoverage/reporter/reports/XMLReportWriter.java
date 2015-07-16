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

import java.io.BufferedWriter;
import java.util.Collection;
import java.util.Map;
import java.util.Set;

import javax.xml.stream.XMLOutputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamWriter;

import org.apache.flex.tools.codecoverage.reporter.CoverageSummary;
import org.apache.flex.tools.codecoverage.reporter.PackageSummaryInfo;
import org.apache.flex.tools.codecoverage.reporter.SummaryInfo;
import org.apache.flex.tools.codecoverage.reporter.SummaryType;

/**
 * XML formatted code coverage report.
 *
 */
public class XMLReportWriter implements IReportWriter
{
    private static final String REPORT_VERSION = "1.0";
    
    private Collection<String> includeFilters;
    private Collection<String> excludeFilters;
    private boolean showPackages;
    private boolean showFiles;
    private boolean showMethods;
    private boolean showUnexecutedDetails;
    
    /**
     * Constructor.
     * 
     * @param reportOptions Options to control the contents of the report. 
     */
    public XMLReportWriter(final ReportOptions reportOptions)
    {
        this.includeFilters = reportOptions.getIncludeFilters();
        this.excludeFilters = reportOptions.getExcludeFilters();
        this.showPackages = reportOptions.isShowPackages();
        this.showFiles = reportOptions.isShowFiles();
        this.showMethods = reportOptions.isShowMethods();
        this.showUnexecutedDetails = reportOptions.isShowUnexecutedDetails();
    }

    @Override
    public void writeTo(final BufferedWriter writer, final CoverageSummary coverageSummary)
    {
        final XMLOutputFactory xmlOutputFactory = XMLOutputFactory.newInstance();
        assert xmlOutputFactory != null : "Expect XMLOutputFactory implementation.";

        try
        {
            final XMLStreamWriter xmlWriter = xmlOutputFactory.
                    createXMLStreamWriter(writer);
            xmlWriter.writeStartDocument("utf-8", "1.0");
            
            // write top-level report
            outputTopLevelStart(xmlWriter, coverageSummary.getOverallSummaryInfo());
            
            if (showPackages)
            {
                // start package element
                xmlWriter.writeStartElement("packages");
                
                for (Map.Entry<String, PackageSummaryInfo> packageEntry :
                     coverageSummary.getPackageSummaryEntrySet())
                {
                    PackageSummaryInfo packageSummary = packageEntry.getValue();
                    outputPackageCoverageStart(xmlWriter, packageSummary.getSummaryInfo());

                    if (showFiles)
                    {
                        outputFiles(xmlWriter, packageSummary, coverageSummary);
                    }

                    xmlWriter.writeEndElement(); // package
                }
                
                xmlWriter.writeEndElement(); // packages
            }

            xmlWriter.writeEndElement(); // code-coverage (top-level)
            xmlWriter.writeEndDocument();
            xmlWriter.close();
        }
        catch (XMLStreamException e)
        {
            e.printStackTrace();
        }

    }
    
    /**
     * Output the files xml and its children.
     * 
     * @param xmlWriter
     * @param packageSummary
     * @param coverageSummary
     * @throws XMLStreamException
     */
    private void outputFiles(final XMLStreamWriter xmlWriter,
            final PackageSummaryInfo packageSummary, 
            final CoverageSummary coverageSummary) throws XMLStreamException
    {
        // start file element
        xmlWriter.writeStartElement("files");

        for (final String packageFileKey : packageSummary.getFilesInPackage()) 
        {
            final SummaryInfo fileSummary = coverageSummary.getFileSummaryInfo(packageFileKey);
            outputFileCoverageStart(xmlWriter, fileSummary);
            
            final Set<String> methodNames = coverageSummary.getMethodsInFile(packageFileKey);
            if (showMethods && !methodNames.isEmpty())
            {
                // start method element
                xmlWriter.writeStartElement("methods");

                for (final String methodName : methodNames)
                {
                    SummaryInfo methodSummary = coverageSummary.
                            getMethodSummaryInfo(methodName);
                    outputMethodNameCoverage(xmlWriter, methodSummary);
                }
                
                xmlWriter.writeEndElement(); // methods
            }
            
            xmlWriter.writeEndElement(); // file
        }

        xmlWriter.writeEndElement(); // files
    }

    /**
     * Output the coverage information for a method.
     * 
     * @param xmlWriter
     * @param summaryInfo
     * @throws XMLStreamException
     */
    private void outputMethodNameCoverage(final XMLStreamWriter xmlWriter,
            final SummaryInfo summaryInfo) throws XMLStreamException
    {
        xmlWriter.writeStartElement("method");
        xmlWriter.writeAttribute("name", summaryInfo.getName());

        outputLineCoverage(xmlWriter, summaryInfo, false);
        xmlWriter.writeEndElement();
    }

    /**
     * Output the start element for file coverage information.
     * 
     * @param xmlWriter
     * @param summaryInfo
     * @throws XMLStreamException
     */
    private void outputFileCoverageStart(final XMLStreamWriter xmlWriter,
            final SummaryInfo summaryInfo) throws XMLStreamException
    {
        xmlWriter.writeStartElement("file");
        xmlWriter.writeAttribute("name", summaryInfo.getName());

        outputLineCoverage(xmlWriter, summaryInfo, showUnexecutedDetails);
        outputMethodCoverage(xmlWriter, summaryInfo, showUnexecutedDetails);  
    }

    /**
     * Output code coverage for a package.
     * @param xmlWriter
     * @param summaryInfo
     * @throws XMLStreamException
     */
    private void outputPackageCoverageStart(final XMLStreamWriter xmlWriter,
            final SummaryInfo summaryInfo) throws XMLStreamException
    {
        xmlWriter.writeStartElement("package");
        xmlWriter.writeAttribute("name", summaryInfo.getName());

        outputLineCoverage(xmlWriter, summaryInfo, false);
        outputMethodCoverage(xmlWriter, summaryInfo, false);
    }

    /**
     * Output top level summary information
     * 
     * @param summaryInfo overall coverage info.
     * @throws XMLStreamException 
     */
    private void outputTopLevelStart(final XMLStreamWriter xmlWriter,
            final SummaryInfo summaryInfo) throws XMLStreamException
    {
        xmlWriter.writeStartElement("code-coverage");
        xmlWriter.writeAttribute("version", REPORT_VERSION);
        
        outputLineCoverage(xmlWriter, summaryInfo, false);
        outputMethodCoverage(xmlWriter, summaryInfo, false);
        outputFilter(xmlWriter, "include-filter");
        outputFilter(xmlWriter, "exclude-filter");
    }

    /**
     * Output filters as part of the report.
     * 
     * @param xmlWriter
     * @param filterName The name of the filter to output.
     * @throws XMLStreamException 
     */
    private void outputFilter(final XMLStreamWriter xmlWriter,
            final String filterName) throws XMLStreamException
    {
        Collection<String> filters = null;
        String startElementName = null;
        
        if ("include-filter".equals(filterName))
        {
            startElementName = "include-filters";
            filters = includeFilters;
        }
        else if ("exclude-filter".equals(filterName))
        {
            startElementName = "exclude-filters";
            filters = excludeFilters;            
        }
        else 
        {
            throw new IllegalArgumentException("unexpected filter name:" + filterName);
        }

        if (filters.isEmpty())
            return;
        
        xmlWriter.writeStartElement(startElementName);
        
        for (final String filter : filters)
        {
            xmlWriter.writeStartElement(filterName);
            xmlWriter.writeCharacters(filter);
            xmlWriter.writeEndElement();
        }
        
        xmlWriter.writeEndElement();
    }

    /**
     * Common method to output line coverage information.
     * 
     * @param xmlWriter
     * @param overall
     * @throws XMLStreamException 
     */
    private void outputLineCoverage(final XMLStreamWriter xmlWriter,
            final SummaryInfo overall, boolean showDetails) throws XMLStreamException
    {
        outputSummaryInfo(xmlWriter, "line-coverage", overall, SummaryType.LINE, showDetails);
    }

    /**
     * Common method to output method coverage information.
     * 
     * @param xmlWriter
     * @param overall
     * @throws XMLStreamException 
     */
    private void outputMethodCoverage(final XMLStreamWriter xmlWriter,
            final SummaryInfo overall, final boolean showDetails) 
            throws XMLStreamException
    {
        outputSummaryInfo(xmlWriter, "method-coverage", overall, 
                SummaryType.METHOD, showDetails);
    }

    /**
     * Common method to output summary information.
     * 
     * @param xmlWriter The writer.
     * @param elementName The name of the element.
     * @param summaryInfo The summary info to output.
     * @param summaryType Choose either LINE or METHOD.
     * @param showDetails Show the lines/methods that were not executed.
     * @throws XMLStreamException 
     */
    private void outputSummaryInfo(final XMLStreamWriter xmlWriter,
            final String elementName,
            final SummaryInfo summaryInfo, 
            final SummaryType summaryType,
            final boolean showDetails) throws XMLStreamException
    {
        xmlWriter.writeStartElement(elementName);

        final int executed;
        final int total;
        final int percent;
        Set<?> items = null;
        
        if (summaryType == SummaryType.LINE)
        {
            executed = summaryInfo.getExecutedLineCount();
            total = summaryInfo.getTotalLineCount();
            percent = total == 0 ? 0 : executed * 100 / total;
            if (showDetails)
                items = summaryInfo.getUnexecutedLines();
        }
        else
        {
            executed = summaryInfo.getExecutedMethodCount();
            total = summaryInfo.getTotalMethodCount();
            percent = total == 0 ? 0 : executed * 100 / total; 
            if (showDetails)
                items = summaryInfo.getUnexecutedMethods();
        }
        
        xmlWriter.writeAttribute("executed", Integer.toString(executed));
        xmlWriter.writeAttribute("total", Integer.toString(total));
        xmlWriter.writeAttribute("percent", Integer.toString(percent));
        
        if (showDetails)
            outputUnexecutedSet(xmlWriter, items);
        
        xmlWriter.writeEndElement();
    }

    /**
     * Output unexecuted lines or methods.
     * 
     * @param xmlWriter
     * @param items
     * @throws XMLStreamException
     */
    private void outputUnexecutedSet(final XMLStreamWriter xmlWriter,
            final Set<?> items) throws XMLStreamException
    {
        if (items == null || items.isEmpty())
            return;
        
        xmlWriter.writeStartElement("unexecuted-set");
        
        for (Object item : items)
        {
            xmlWriter.writeStartElement("unexecuted");
            xmlWriter.writeCharacters(item.toString());
            xmlWriter.writeEndElement();
        }
        
        xmlWriter.writeEndElement();
    }

}
