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
import java.util.ServiceLoader;

/**
 * Utility class for automatically detecting and initializing any
 * flex tool group implementation available on the current classpath
 * using Java ServiceLoaders.
 */
public class FlexToolRegistry {

    private Map<String, FlexToolGroup> toolGroupMap;

    public FlexToolRegistry() {
        toolGroupMap = new HashMap<String, FlexToolGroup>();

        // Locate and instantiate each tool group and save a reference to it.
        ServiceLoader<FlexToolGroup> toolGroups = ServiceLoader.load(FlexToolGroup.class);
        for(FlexToolGroup toolGroup : toolGroups) {
            toolGroupMap.put(toolGroup.getName(), toolGroup);
        }
    }

    public Collection<String> getToolGroupNames() {
        return toolGroupMap.keySet();
    }

    public Collection<FlexToolGroup> getToolGroups() {
        return toolGroupMap.values();
    }

    public FlexToolGroup getToolGroup(String toolGroupName) {
        return toolGroupMap.get(toolGroupName);
    }

}
