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

package org.apache.flex.tools.codecoverage.reporter.swf;

import java.io.BufferedInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URL;
import java.util.Collection;

import org.apache.commons.io.IOUtils;
import org.apache.flex.abc.ABCParser;
import org.apache.flex.compiler.clients.problems.CompilerProblemCategorizer;
import org.apache.flex.compiler.clients.problems.ProblemFormatter;
import org.apache.flex.compiler.clients.problems.ProblemPrinter;
import org.apache.flex.compiler.clients.problems.ProblemQuery;
import org.apache.flex.compiler.clients.problems.WorkspaceProblemFormatter;
import org.apache.flex.compiler.internal.workspaces.Workspace;
import org.apache.flex.compiler.problems.ICompilerProblem;
import org.apache.flex.swf.TagType;
import org.apache.flex.swf.io.SWFReader;
import org.apache.flex.swf.tags.DoABCTag;
import org.apache.flex.swf.tags.ITag;
import org.apache.flex.tools.codecoverage.reporter.CoverageData;

import com.google.common.collect.ImmutableList;

/**
 * Read in a SWF file and report the debugs line with the methods names. 
 *
 * The data is returned in a Map where the key is the "path;package;file" string.
 * The value is another Map where the key is the line number of the line. The
 * value is a LineInfo object.
 */
public class SWFLineReporter
{

    private final String path;
    
    /**
     * Constructor.
     * 
     * @param path The path of the SWF to read.
     */
    public SWFLineReporter(final String path)
    {
        this.path = path;
    }
    
    /**
     * Read the debug lines from the SWF and populate the coverage data.
     * 
     * @param coverageData The coverage data to add the debug lines to.
     * @throws IOException
     */
    public void readLines(final CoverageData coverageData) 
            throws IOException
    {
        final SWFReader swfReader = new SWFReader(false);
        final URL url = new URL(path);
        
        try
        {
            swfReader.readFrom(
                    new BufferedInputStream(url.openStream()),
                    path);

            ProblemQuery problemQuery = new ProblemQuery();
            problemQuery.addAll(swfReader.getProblems());
            if (!problemQuery.hasErrors())
            {
                final ImmutableList<ITag> tags = ImmutableList.copyOf(swfReader.iterator());
                for (ITag tag : tags)
                {
                    // visit the DoABC tag
                    if (tag.getTagType() == TagType.DoABC)
                    {
                        processDoABC((DoABCTag)tag, coverageData);
                    }
                }
            }

            printProblems(swfReader.getProblems());
        }
        catch (FileNotFoundException e)
        {
        	System.err.println("Error: Unable read debug lines from " + e.getLocalizedMessage());
        	throw e;
        }
        finally
        {
            IOUtils.closeQuietly(swfReader);
        }
    }
    
    /**
     * Parse a DoABC record and add the debug lines to the coverage data.
     * 
     * @param tag The ABC tag.
     * @param coverageData The coverage data to populate.
     */
    private void processDoABC(final DoABCTag tag, final CoverageData coverageData)
    {
        // create a visitor to record source line numbers.
        final ABCParser parser = new ABCParser(tag.getABCData());
        final DebugLineVisitor debugLineVisitor = new DebugLineVisitor(coverageData);
        parser.parseABC(debugLineVisitor);
    }

    /**
     * Print out problems to standard output.
     * 
     * @param problems
     */
    private void printProblems(final Collection<ICompilerProblem> problems)
    {
        final CompilerProblemCategorizer categorizer = new CompilerProblemCategorizer();
        final ProblemFormatter formatter = new WorkspaceProblemFormatter(new Workspace(),
                categorizer);
        final ProblemPrinter printer = new ProblemPrinter(formatter, System.err);

        printer.printProblems(problems);
    }

    
}
