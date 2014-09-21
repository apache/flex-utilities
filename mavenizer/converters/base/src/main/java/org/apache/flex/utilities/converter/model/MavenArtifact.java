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
package org.apache.flex.utilities.converter.model;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by cdutz on 01.07.2012.
 */
public class MavenArtifact {

    public static final String DEFAULT_CLASSIFIER = "default";

    protected String groupId;
    protected String artifactId;
    protected String version;
    protected String packaging = "pom";
    protected String classifier;
    protected List<String> librariesWithResourceBundles;

    protected List<MavenArtifact> dependencies;

    protected Map<String, File> binaryArtifacts;

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

    public List<MavenArtifact> getDependencies() {
        return dependencies;
    }

    public void setDependencies(List<MavenArtifact> dependencies) {
        this.dependencies = dependencies;
    }

    public void addDependency(MavenArtifact dependency) {
        if(dependencies == null) {
            dependencies = new ArrayList<MavenArtifact>();
        }
        dependencies.add(dependency);
    }

    public void addDefaultBinaryArtifact(File binaryArtifact) {
        addBinaryArtifact(DEFAULT_CLASSIFIER, binaryArtifact);
    }

    public void addBinaryArtifact(String classifier, File binaryArtifact) {
        if(binaryArtifacts == null) {
            binaryArtifacts = new HashMap<String, File>();
        }
        binaryArtifacts.put(classifier, binaryArtifact);
    }

   public boolean hasBinaryArtifact(String classifier) {
      return binaryArtifacts != null && binaryArtifacts.containsKey(classifier);
   }

   public File getPomTargetFile(File targetRootDirectory) {
        final String fileName = groupId.replace(".", File.separator) + File.separator + artifactId + File.separator +
                version + File.separator + artifactId + "-" + version + ((classifier != null) ? "-" + classifier : "") +
                ".pom";
        return new File(targetRootDirectory, fileName);
    }

    public List<String> getBinaryFilesClassifiers() {
        final List<String> classifiers = new ArrayList<String>();
        if(binaryArtifacts != null) {
            classifiers.addAll(binaryArtifacts.keySet());
        }
        return classifiers;
    }

    public File getBinarySourceFile(String classifier) {
        if((binaryArtifacts != null) && (binaryArtifacts.containsKey(classifier))) {
            return binaryArtifacts.get(classifier);
        }
        return null;
    }

    public File getBinaryTargetFile(File targetRootDirectory, String classifier) {
        if((binaryArtifacts != null) && (binaryArtifacts.containsKey(classifier))) {
            final String fileName = groupId.replace(".", File.separator) + File.separator + artifactId + File.separator +
                    version + File.separator + artifactId + "-" + version +
                    (DEFAULT_CLASSIFIER.equals(classifier) ? "" : "-" + classifier) + "." + packaging;
            return new File(targetRootDirectory, fileName);
        }
        return null;
    }

    public boolean hasDependencies() {
        return (dependencies != null) && (!dependencies.isEmpty());
    }

    public boolean isAtLeastOneDependencyRsl() {
        if(dependencies != null) {
           for(final MavenArtifact dependency : dependencies) {
              if(dependency.hasBinaryArtifact("rsl")) {
                 return true;
              }
           }
        }
        return false;
    }

}
