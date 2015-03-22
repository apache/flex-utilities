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

/**
 * Simple value class that contains information about a line number in a source
 * file.
 * 
 * Tracks:
 * 1. the line number of this line
 * 2. if the line was executed or not
 * 3. the name of the method the line is in.
 */
public class LineInfo 
{
    private int lineNumber;
    private boolean executed;
    private String methodName;

    /**
     * Create an instance of LineInfo.
     * 
     * @param methodName The name of the method.
     * @param lineNumber The source line number. 
     */
    public LineInfo(final String methodName, final int lineNumber)
    {
        this.methodName = methodName;
        this.lineNumber = lineNumber;
    }

    /**
     * The source line number of this line.
     * @return the line number
     */
    public int getLineNumber()
    {
        return lineNumber;
    }
    
    /**
     * Set the source line number of this line.
     * 
     * @param lineNumber
     */
    public void setLineNumber(final int lineNumber)
    {
        this.lineNumber = lineNumber;
    }
    
    /**
     * Has the line been executed?
     * 
     * @return true if the line has been executed, false otherwise.
     */
    public boolean isExecuted()
    {
        return executed;
    }
    
    /**
     * Set the line number as being executed.
     * 
     * @param executed true if the line has been hit, false otherwise.
     */
    public void setExecuted(final boolean executed)
    {
        this.executed = executed;
    }
    
    /**
     * The method name containing this line.
     * 
     * @return The method name or an empty string if no method name is set.
     */
    public String getMethodName()
    {
        return methodName != null ? methodName : "";
    }
    
    /**
     * Set the method name this line is contained in.
     * 
     * @param methodName
     */
    public void setMethodName(final String methodName)
    {
        this.methodName = methodName;
    }
}
