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

/**
 * Interface for defining a group of flex tools. Classes implementing this
 * interface will allow loading of flex tools using the java ServiceLoader
 * mechanism.
 *
 * We intentionally decided to use String names instead of constants
 * to allow extendability in the future, so we can support more tools
 * without having to release a new version of the tools api.
 */
public interface FlexToolGroup {

    String getName();

    Collection<String> getFlexToolNames();

    boolean hasFlexTool(String name);

    FlexTool getFlexTool(String name);

}
