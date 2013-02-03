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
package air;

import common.BaseGenerator;
import common.MavenMetadata;
import org.w3c.dom.Document;

import java.io.*;
import java.util.*;

/**
 * Created with IntelliJ IDEA.
 * User: cdutz
 * Date: 11.05.12
 * Time: 14:55
 */
public class AirFrameworkGenerator extends BaseGenerator {

    protected Map<String, String> libraryVersions = new HashMap<String, String>();
    protected Map<String, String> libraryLocations = new HashMap<String, String>();

    public void process(File sdkSourceDirectory, final boolean isApache, File sdkTargetDirectory, String sdkVersion,
                        boolean useApache)
            throws Exception
    {
        final File frameworksDirectory = new File(sdkSourceDirectory, "frameworks");
        final File targetBaseDirectory = new File(sdkTargetDirectory, "com/adobe/air/framework");

        // Generate the artifacts based upon the structure of the libraries in the lib-directory.
        final File swcsDirectory = new File(frameworksDirectory, "libs/air");
        generateArtifactsForDirectory(
                swcsDirectory, targetBaseDirectory, sdkVersion, "com.adobe.air.framework");
    }

    protected void generateArtifactsForDirectory(
            final File sourceDirectory, final File targetDirectory, final String sdkVersion, final String groupId)
            throws Exception
    {
        final MavenMetadata groupMetadata = new MavenMetadata();
        groupMetadata.setGroupId(groupId.substring(0, groupId.lastIndexOf(".")));
        groupMetadata.setArtifactId(groupId.substring(groupId.lastIndexOf(".") + 1, groupId.length()));
        groupMetadata.setVersion(sdkVersion);
        groupMetadata.setPackaging("pom");
        groupMetadata.setLibrariesWithResourceBundles(new ArrayList<String>());
        groupMetadata.setDependencies(new ArrayList<MavenMetadata>());

        // Don't deploy the player, as this has to be dealt with differently.
        final File[] directoryContent = sourceDirectory.listFiles(new FileFilter() {
            public boolean accept(File pathname) {
                return pathname.getName().endsWith(".swc");
            }
        });

        if(directoryContent != null) {
            for(File file : directoryContent) {
                final MavenMetadata metadata = new MavenMetadata();
                metadata.setGroupId(groupId);
                String libraryName = file.getName().substring(0, file.getName().lastIndexOf("."));

                String libraryVersion = libraryVersions.get(libraryName);
                if(libraryVersion == null) {
                    libraryVersion = sdkVersion;
                }
                final File targetSwcDirectory = new File(targetDirectory, libraryName + "/" + libraryVersion);
                if(!targetSwcDirectory.exists()) {
                    if(!targetSwcDirectory.mkdirs()) {
                        throw new RuntimeException(
                                "Could not create directory: " + targetSwcDirectory.getAbsolutePath());
                    }
                }
                final File targetSwcFile =
                        new File(targetSwcDirectory, libraryName + "-" + libraryVersion + ".swc");
                copyFile(file, targetSwcFile);

                metadata.setArtifactId(libraryName);
                metadata.setVersion(libraryVersion);
                metadata.setPackaging("swc");

                generateSwcPom(targetSwcFile, metadata);

                groupMetadata.getDependencies().add(metadata);

                // Save the checksum and metadata of the playerglobal, so we can
                // find out which air sdk is used when deploying the flex sdks later
                // on.
                if("airglobal".equals(libraryName)) {
                    final String checksum = calculateChecksum(file);
                    checksums.put(checksum, metadata);
                }

                libraryLocations.put(libraryName, targetSwcDirectory.getAbsolutePath());
                libraryVersions.put(libraryName, libraryVersion);
            }
        }

        final MavenMetadata commonFrameworkMetaData = new MavenMetadata();
        commonFrameworkMetaData.setGroupId(groupId);
        commonFrameworkMetaData.setArtifactId("common-framework");
        commonFrameworkMetaData.setVersion(groupMetadata.getVersion());
        commonFrameworkMetaData.setPackaging("pom");
        commonFrameworkMetaData.setDependencies(new ArrayList<MavenMetadata>());
        commonFrameworkMetaData.setLibrariesWithResourceBundles(new ArrayList<String>());

        for(final MavenMetadata dependency : groupMetadata.getDependencies()) {
            commonFrameworkMetaData.getDependencies().add(dependency);
            if(groupMetadata.getLibrariesWithResourceBundles().contains(dependency.getArtifactId())) {
                commonFrameworkMetaData.getLibrariesWithResourceBundles().add(dependency.getArtifactId());
            }
        }
        final File commonFrameworkPom = new File(targetDirectory,
                "common-framework/" + groupMetadata.getVersion() + "/common-framework-" +
                        groupMetadata.getVersion() + ".pom");
        generateSwcPom(commonFrameworkPom, commonFrameworkMetaData);

        // Generate the master pom for the current library (Pom that defines
        // all versions of the current sdk libraries.
        final File groupPomFile = new File(targetDirectory,
                groupMetadata.getVersion() + "/" + groupMetadata.getArtifactId() + "-" +
                        groupMetadata.getVersion() + ".pom");
        generateDependencyManagementPom(groupPomFile, groupMetadata);
    }

    protected void generateSwcPom(final File targetSwc, final MavenMetadata metadata) throws Exception {
        final String swcPath = targetSwc.getAbsolutePath();
        final String pomPath = swcPath.substring(0, swcPath.lastIndexOf(".")) + ".pom";

        final Document pom = createPomDocument(metadata);

        writeDocument(pom, new File(pomPath));
    }

    protected void generateDependencyManagementPom(final File targetSwc, final MavenMetadata metadata) throws Exception {
        final String swcPath = targetSwc.getAbsolutePath();
        final String pomPath = swcPath.substring(0, swcPath.lastIndexOf(".")) + ".pom";

        final Document pom = createPomDocumentDependencyManagement(metadata);

        writeDocument(pom, new File(pomPath));
    }
}
