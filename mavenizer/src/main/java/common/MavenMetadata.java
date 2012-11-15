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
package common;

import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: cdutz
 * Date: 01.07.12
 * Time: 12:31
 */
public class MavenMetadata {
    protected String groupId;
    protected String artifactId;
    protected String version;
    protected String packaging;
    protected String classifier;
    protected List<String> librariesWithResourceBundles;
    protected List<MavenMetadata> dependencies;

    public String getGroupId() {
        return groupId;
    }

    public void setGroupId(String groupId) {
        this.groupId = groupId;
    }

    public String getArtifactId() {
        return artifactId;
    }

    public void setArtifactId(String artifactId) {
        this.artifactId = artifactId;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getPackaging() {
        return packaging;
    }

    public void setPackaging(String packaging) {
        this.packaging = packaging;
    }

    public String getClassifier() {
        return classifier;
    }

    public void setClassifier(String classifier) {
        this.classifier = classifier;
    }

    public List<String> getLibrariesWithResourceBundles() {
        return librariesWithResourceBundles;
    }

    public void setLibrariesWithResourceBundles(List<String> librariesWithResourceBundles) {
        this.librariesWithResourceBundles = librariesWithResourceBundles;
    }

    public List<MavenMetadata> getDependencies() {
        return dependencies;
    }

    public void setDependencies(List<MavenMetadata> dependencies) {
        this.dependencies = dependencies;
    }
}
