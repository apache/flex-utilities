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

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 * Base class that can be used for any type of Tool groups.
 */
public abstract class AbstractFlexToolGroup implements FlexToolGroup {

    private String name;
    private Map<String, FlexTool> tools;

    public AbstractFlexToolGroup(String name) {
        this.name = name;
        tools = new HashMap<String, FlexTool>();
    }

    protected void addFlexTool(FlexTool flexTool) {
        tools.put(flexTool.getName(), flexTool);
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public Collection<String> getFlexToolNames() {
        return tools.keySet();
    }

    @Override
    public boolean hasFlexTool(String toolName) {
        return tools.containsKey(toolName);
    }

    @Override
    public FlexTool getFlexTool(String toolName) {
        return tools.get(toolName);
    }

}
