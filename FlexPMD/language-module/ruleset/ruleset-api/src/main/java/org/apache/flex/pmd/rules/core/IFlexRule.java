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
package org.apache.flex.pmd.rules.core;

import net.sourceforge.pmd.Rule;
import org.apache.flex.pmd.files.IFlexFile;
import org.apache.flex.pmd.nodes.IPackage;
import org.apache.flex.pmd.rules.IFlexViolation;

import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * @author xagnetti
 */
public interface IFlexRule extends Rule {
    /**
     * @return ruleName
     */
    String getRuleName();

    /**
     * @param file
     * @param rootNode
     * @param files
     * @return
     */
    List<IFlexViolation> processFile(final IFlexFile file,
                                     final IPackage rootNode,
                                     final Map<String, IFlexFile> files);

    /**
     * @param excludes
     */
    void setExcludes(final Set<String> excludes);
}