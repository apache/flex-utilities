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

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.TreeMap;

/**
 * Class to record the execution data as well the all the debug lines that exist
 * in SWF file.
 * Each line number is associated with method.
 */
public class CoverageData
{
    /**
     * key   = package;file
     * value = Map<line number, LineInfo>
     */
    final Map<String, Map<Integer, LineInfo>> lineMap =
            new HashMap<String, Map<Integer, LineInfo>>();
    Iterator<Map<String, Map<Integer, LineInfo>>> lineMapIterator;
    
    /**
     * Add the existence of a line to the coverage data.
     * 
     * @param file The file the line number is in.
     * @param lineNumber The line number of the line
     * @param methodName The name of the method the line is in.
     */
    public void addLine(final String file, final int lineNumber,
            final String methodName)
    {
        doAddLine(file, lineNumber, methodName);
    }
    
    /**
     * Mark a line number as being executed.
     * @param file The file.
     * @param lineNumber The line number that was executed.
     */
    public void setLineExecuted(final String file, final int lineNumber)
    {
        LineInfo lineInfo = doAddLine(file, lineNumber, null);
        lineInfo.setExecuted(true);
    }
    
    /**
     * Get a list of entries in the coverage data.
     * 
     * @return list of entries in the coverage data.
     */
    public Set<Entry<String, Map<Integer, LineInfo>>> entrySet()
    {
        return lineMap.entrySet();
    }

    /**
     * Add a line to the coverage data.
     * This line is recorded as unexecuted.
     * 
     * @param file The file the line is found in.
     * @param lineNumber The line number.
     * @param methodName The method name.
     * @return new LineInfo object
     */
    private LineInfo doAddLine(final String file, final int lineNumber,
            final String methodName)
    {
        Map<Integer, LineInfo> lineInfoMap = lineMap.get(file);
        
        if (lineInfoMap == null)
        {
            lineInfoMap = new TreeMap<Integer, LineInfo>();
            lineMap.put(file, lineInfoMap);
        }

        LineInfo lineInfo = lineInfoMap.get(lineNumber);
        
        if (lineInfo == null)
        {
            lineInfo = new LineInfo(methodName, lineNumber);
            lineInfoMap.put(lineNumber, lineInfo);
        }
        else if (methodName != null && lineInfo.getMethodName() == null)
        {
            lineInfo.setMethodName(methodName);
        }
        
        return lineInfo;
    }

}
