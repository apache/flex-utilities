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

/**
 * Class to total the individual SummaryInfo objects for package and overall
 * coverage reported. Do not use to track summary info at the file and method
 * level.
 */
public class AggregateSummaryInfo extends SummaryInfo
{

    private int totalLineCount;
    private int executedLineCount;
    private int totalMethodCount;
    private int executedMethodCount;
    
    @Override
    public int getExecutedLineCount()
    {
        return executedLineCount;
    }

    @Override
    public int getTotalLineCount()
    {
        return totalLineCount;
    }

    @Override
    public int getExecutedMethodCount()
    {
        return executedMethodCount;
    }

    @Override
    public int getTotalMethodCount()
    {
        return totalMethodCount;
    }

    @Override
    public Set<Integer> getUnexecutedLines()
    {
        return Collections.emptySet();
    }

    @Override
    public Set<String> getUnexecutedMethods()
    {
        return Collections.emptySet();
    }

    @Override
    public void setLineExecutionStatus(int lineNumber, String methodName,
            Boolean executed)
    {
        throw new UnsupportedOperationException();
    }

    @Override
    public void add(SummaryInfo summaryInfo)
    {
        executedLineCount += summaryInfo.getExecutedLineCount();
        totalLineCount += summaryInfo.getTotalLineCount();
        executedMethodCount += summaryInfo.getExecutedMethodCount();
        totalMethodCount += summaryInfo.getTotalMethodCount();
    }

}
