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
package com.adobe.ac.pmd.metrics.maven.generators;

import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;

import org.apache.maven.plugin.logging.Log;
import org.codehaus.doxia.sink.Sink;
import org.dom4j.Document;
import org.dom4j.Node;

import com.adobe.ac.pmd.metrics.maven.utils.ModuleReport;

/**
 * Generates the JavaNCSS aggregate report.
 *
 * @author <a href="mperham AT gmail.com">Mike Perham</a>
 * @version $Id: NcssAggregateReportGenerator.java 3286 2007-02-08 20:18:51Z
 *          jeanlaurent $
 */
public class NcssAggregateReportGenerator extends NcssReportGeneratorBase
{

    /**
     * @param getSink() the getSink() which will be used for reporting.
     * @param bundle the correct RessourceBundle to be used for reporting.
     * @param log
     */
    public NcssAggregateReportGenerator( final Sink sink,
                                         final ResourceBundle bundle,
                                         final Log log )
    {
        super( sink, bundle, log );
    }

    /**
     * Generates the JavaNCSS report.
     *
     * @param locale the Locale used for this report.
     * @param moduleReports the javancss raw reports to aggregate, List of
     *           ModuleReport.
     * @param lineThreshold the maximum number of lines to keep in major reports.
     */
    public void doReport( final Locale locale,
                          final List< ModuleReport > moduleReports,
                          final int lineThreshold )
    {
        // HEADER
        getSink().head();
        getSink().title();
        getSink().text( getResourceBundle().getString( "report.javancss.title" ) );
        getSink().title_();
        getSink().head_();
        // BODY
        getSink().body();
        doIntro();
        // packages
        startSection( "report.javancss.module.link",
                "report.javancss.module.title" );
        doModuleAnalysis( moduleReports );
        endSection();
        getSink().body_();
        getSink().close();
    }

    private void doIntro()
    {
        getSink().section1();
        getSink().sectionTitle1();
        getSink().text( getResourceBundle().getString( "report.javancss.main.title" ) );
        getSink().sectionTitle1_();
        getSink().paragraph();
        getSink().text( getResourceBundle().getString( "report.javancss.main.text" )
                + " " );
        getSink().lineBreak();
        getSink().link( "http://www.kclee.de/clemens/java/javancss/" );
        getSink().text( "JavaNCSS web site." );
        getSink().link_();
        getSink().paragraph_();
        getSink().section1_();
    }

    private void doModuleAnalysis( final List< ModuleReport > reports )
    {
        doModuleAnalysisHeader();

        int packages = 0;
        int classes = 0;
        int methods = 0;
        int ncss = 0;
        int javadocs = 0;
        int jdlines = 0;
        int single = 0;
        int multi = 0;
        for ( final ModuleReport moduleReport : reports )
        {
            final ModuleReport report = moduleReport;
            final Document document = report.getJavancssDocument();
            getSink().tableRow();
            getLog().debug( "Aggregating "
                    + report.getModule().getArtifactId() );
            tableCellHelper( report.getModule().getArtifactId() );
            final int packageSize = document.selectNodes( "//javancss/packages/package" ).size();
            packages += packageSize;
            tableCellHelper( String.valueOf( packageSize ) );

            final Node node = document.selectSingleNode( "//javancss/packages/total" );

            tableCellHelper( node.valueOf( "classes" ) );
            classes += Integer.parseInt( node.valueOf( "classes" ) );
            tableCellHelper( node.valueOf( "functions" ) );
            methods += Integer.parseInt( node.valueOf( "functions" ) );
            tableCellHelper( node.valueOf( "ncss" ) );
            ncss += Integer.parseInt( node.valueOf( "ncss" ) );
            tableCellHelper( node.valueOf( "javadocs" ) );
            javadocs += Integer.parseInt( node.valueOf( "javadocs" ) );
            tableCellHelper( node.valueOf( "javadoc_lines" ) );
            jdlines += Integer.parseInt( node.valueOf( "javadoc_lines" ) );
            tableCellHelper( node.valueOf( "single_comment_lines" ) );
            single += Integer.parseInt( node.valueOf( "single_comment_lines" ) );
            tableCellHelper( node.valueOf( "multi_comment_lines" ) );
            multi += Integer.parseInt( node.valueOf( "multi_comment_lines" ) );

            getSink().tableRow_();
        }

        doModuleAnalysisTotals( packages,
                classes,
                methods,
                ncss,
                javadocs,
                jdlines,
                single,
                multi );
    }

    private void doModuleAnalysisHeader()
    {
        getSink().table();
        getSink().tableRow();
        headerCellHelper( getResourceBundle().getString( "report.javancss.header.module" ) );
        headerCellHelper( getResourceBundle().getString( "report.javancss.header.packages" ) );
        headerCellHelper( getResourceBundle().getString( "report.javancss.header.classetotal" ) );
        headerCellHelper( getResourceBundle().getString( "report.javancss.header.functiontotal" ) );
        headerCellHelper( getResourceBundle().getString( "report.javancss.header.ncsstotal" ) );
        headerCellHelper( getResourceBundle().getString( "report.javancss.header.javadoc" ) );
        headerCellHelper( getResourceBundle().getString( "report.javancss.header.javadoc_line" ) );
        headerCellHelper( getResourceBundle().getString( "report.javancss.header.single_comment" ) );
        headerCellHelper( getResourceBundle().getString( "report.javancss.header.multi_comment" ) );
        getSink().tableRow_();
    }

    private void doModuleAnalysisTotals( final int packages,
                                         final int classes,
                                         final int methods,
                                         final int ncss,
                                         final int javadocs,
                                         final int jdlines,
                                         final int single,
                                         final int multi )
    {
        getSink().tableRow();
        tableCellHelper( getResourceBundle().getString( "report.javancss.header.totals" ) );
        tableCellHelper( String.valueOf( packages ) );
        tableCellHelper( String.valueOf( classes ) );
        tableCellHelper( String.valueOf( methods ) );
        tableCellHelper( String.valueOf( ncss ) );
        tableCellHelper( String.valueOf( javadocs ) );
        tableCellHelper( String.valueOf( jdlines ) );
        tableCellHelper( String.valueOf( single ) );
        tableCellHelper( String.valueOf( multi ) );
        getSink().tableRow_();

        getSink().table_();
    }

}