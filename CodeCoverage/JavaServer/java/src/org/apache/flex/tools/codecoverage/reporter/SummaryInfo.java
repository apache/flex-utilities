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

import java.util.Collections;
import java.util.Set;
import java.util.TreeSet;

/**
 * Simple value class to record summary information on the lines executed vs the
 * total number of lines.
 * 
 * This information can be used for reporting at the file and method
 * level.
 * 
 * 1. total executed lines 
 * 2. total number of lines 
 * 3. total executed methods
 * 4. total number of methods
 * 
 */
public class SummaryInfo
{
    // name of object the summary info is for.
    private String name;

    /**
     * The set of executed lines in sorted order.
     */
    private final Set<Integer> executedLineSet = new TreeSet<Integer>();

    /**
     * The set of unexecuted lines in sorted order.
     */
    private final Set<Integer> unexecutedLineSet = new TreeSet<Integer>();

    /**
     * The set of executed lines in sorted order.
     */
    private final Set<String> executedMethodSet = new TreeSet<String>();
    private final Set<String> unexecutedMethodSet = new TreeSet<String>();

    /**
     * Name of the object the summary information applies to.
     * @return name of the object.
     */
    public String getName()
    {
        return name != null ? name : "";
    }

    /**
     * Set the name of the object the summary information applies to.
     * @param name Name of the object.
     */
    public void setName(final String name)
    {
        this.name = name;
    }

    /**
     * @return Number of executed lines.
     */
    public int getExecutedLineCount()
    {
        return executedLineSet.size();
    }

    /**
     * 
     * @return total number of lines.
     */
    public int getTotalLineCount()
    {
        return executedLineSet.size() + unexecutedLineSet.size();
    }

    /**
     * 
     * @return Number of methods executed.
     */
    public int getExecutedMethodCount()
    {
        return executedMethodSet.size();
    }

    /**
     * 
     * @return Total number of methods.
     */
    public int getTotalMethodCount()
    {
        return executedMethodSet.size() + unexecutedMethodSet.size();
    }

    /**
     * The set of unexecuted lines.
     * 
     * @return Set of executed lines, sorted in ascending order.
     */
    public Set<Integer> getUnexecutedLines()
    {
        return Collections.unmodifiableSet(unexecutedLineSet);
    }
    
    /**
     * The set of unexecuted methods.
     * 
     * @return Set of executed methods, sorted in ascending order.
     */
    public Set<String> getUnexecutedMethods()
    {
        return Collections.unmodifiableSet(unexecutedMethodSet);
    }
    
    /**
     * Set the execution status of a given line and method.
     * 
     * @param lineNumber The line number of the line.
     * @param methodName The name of the method containing the line.
     * @param executed true if the line is executed, false otherwise.
     */
    public void setLineExecutionStatus(final int lineNumber, String methodName,
            final Boolean executed)
    {
        if (executedLineSet.contains(lineNumber))
            return;

        if (executed)
        {
            unexecutedLineSet.remove(lineNumber);
            executedLineSet.add(lineNumber);

            // ignore empty method names.
            // these are cinit and script init methods.
            if (!methodName.isEmpty())
            {
                unexecutedMethodSet.remove(methodName);
                executedMethodSet.add(methodName);
            }
        }
        else
        {
            unexecutedLineSet.add(lineNumber);

            // ignore empty method names.
            // these are cinit and script init methods.
            if (!methodName.isEmpty() && !executedMethodSet.contains(methodName))
                unexecutedMethodSet.add(methodName);
        }
    }

    /**
     * Add the passed summary info to the current set of summary info.
     * 
     * @param summaryInfo
     *            summary information to add in, may not be null.
     */
    public void add(final SummaryInfo summaryInfo)
    {
        unexecutedLineSet.addAll(summaryInfo.unexecutedLineSet);
        unexecutedMethodSet.addAll(summaryInfo.unexecutedMethodSet);
        executedLineSet.addAll(summaryInfo.executedLineSet);
        executedMethodSet.addAll(summaryInfo.executedMethodSet);
    }
}
