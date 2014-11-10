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

package org.apache.flex.tools;

/**
 * This interface defines the entry point for any tool needing to
 * invoke a flex tool.
 */
public interface FlexTool {

    // Some well known constants.
    public static final String FLEX_TOOL_COMPC = "COMPC";
    public static final String FLEX_TOOL_MXMLC = "MXMLC";
    public static final String FLEX_TOOL_ASDOC = "ASDOC";
    public static final String FLEX_TOOL_DIGEST = "DIGEST";
    public static final String FLEX_TOOL_OPTIMIZER = "OPTIMIZER";

    /**
     * Return the name of the tool. This name should match the names of
     * tools in alternate tool groups: MXML, COMPC, ASDOC
     *
     * An enum was deliberately not selected in order to allow easy addition
     * of new future tools without having to touch the tool-api.
     * @return Symbolic name of this tool.
     */
    String getName();

    /**
     * Execute the flex tool and pass in an array of commandline arguments.
     *
     * @param args arguments passed to the tool.
     * @return the return code returned by the tool.
     */
    int execute(String[] args);

}
