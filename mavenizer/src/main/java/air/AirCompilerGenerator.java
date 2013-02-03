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
import org.w3c.dom.Element;

import java.io.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: cdutz
 * Date: 02.02.13
 * Time: 13:41
 */
public class AirCompilerGenerator extends BaseGenerator {

    public void process(final File sdkSourceDirectory, final boolean isApache, final File sdkTargetDirectory,
                        final String sdkVersion, boolean useApache)
            throws Exception {

        final File sdkCompilerLibsDirectory = new File(sdkSourceDirectory, "lib");
        final List<File> jars = new ArrayList<File>();
        jars.addAll(Arrays.asList(sdkCompilerLibsDirectory.listFiles(new FilenameFilter() {
            public boolean accept(File dir, String name) {
                return name.equalsIgnoreCase("adt.jar") ||
                        name.equalsIgnoreCase("baksmali.jar") ||
                        name.equalsIgnoreCase("smali.jar");
            }
        })));

        // A pom artifact will be generated that has all libs as a dependency.
        final MavenMetadata metadata = new MavenMetadata();
        metadata.setGroupId("com.adobe.air");
        metadata.setArtifactId("compiler");
        metadata.setVersion(sdkVersion);
        metadata.setPackaging("pom");

        // Create an empty pom document.
        final Document pom = createPomDocument(metadata);

        // Get the root element, as we will be adding the dependencies to that.
        final Element root = pom.getDocumentElement();
        // Add a "dependencies" element.
        final Element dependencies = pom.createElementNS(BaseGenerator.MAVEN_SCHEMA_URI, "dependencies");
        root.appendChild(dependencies);

        // Generate artifacts for every jar in the input directories.
        for(final File sourceJarFile : jars) {
            // Calculate a checksum for the current file. We will use this checksum to query maven central
            // in order to find out if this lib has already been published. If it has, there is no need to
            // publish it again under a new name. In case a matching artifact is found the generated FDK
            // will use the already deployed version. Additionally the checksum will be saved and if a
            // fdk generated after this one uses the same version of a lib, the version of the older fdk is
            // used also reducing the amount of jars that have to be re-deployed.
            final String checksum = calculateChecksum(sourceJarFile);

            // Try to get artifact metadata based upon the checksum by looking up the internal cache.
            MavenMetadata artifactMetadata = BaseGenerator.checksums.get(checksum);
            // Reusing artifact from other sdk version.
            if(artifactMetadata != null) {
                System.out.println("Reusing artifact (" + checksum + ") : " + artifactMetadata.getGroupId() + ":" +
                        artifactMetadata.getArtifactId() + ":" + artifactMetadata.getVersion());
                appendArtifact(artifactMetadata, dependencies);
            }
            // Id no artifact was found in the local cache, continue processing.
            else {
                // Do a lookup in maven central.
                artifactMetadata = lookupMetadataForChecksum(checksum);

                // The file was available on maven central, so use that version instead of the one coming with the sdk.
                if(artifactMetadata != null) {
                    appendArtifact(artifactMetadata, dependencies);
                }
                // The file was not available on maven central, so we have to add it manually.
                else {
                    // The artifact name is the name of the jar.
                    final String dependencyArtifactId =
                            sourceJarFile.getName().substring(0, sourceJarFile.getName().lastIndexOf("."));

                    // Generate a new metadata object
                    artifactMetadata = new MavenMetadata();
                    artifactMetadata.setGroupId("com.adobe.air.compiler");
                    artifactMetadata.setArtifactId(dependencyArtifactId);
                    artifactMetadata.setVersion(sdkVersion);
                    artifactMetadata.setPackaging("jar");

                    // Create the name of the directory that will contain the artifact.
                    final File targetJarDirectory = new File(sdkTargetDirectory,
                            "com/adobe/air/compiler/" + artifactMetadata.getArtifactId() + "/" +
                                    artifactMetadata.getVersion());
                    // Create the directory.
                    if(targetJarDirectory.mkdirs()) {
                        // Create the filename of the artifact.
                        final File targetJarFile = new File(targetJarDirectory, artifactMetadata.getArtifactId() + "-" +
                                artifactMetadata.getVersion() + "." + artifactMetadata.getPackaging());

                        // Copy the file to it's destination.
                        copyFile(sourceJarFile, targetJarFile);

                        // Add the dependency to the compiler-poms dependency section.
                        appendArtifact(artifactMetadata, dependencies);
                    } else {
                        throw new RuntimeException("Could not create directory: " + targetJarDirectory.getAbsolutePath());
                    }

                    // Create the pom document that will reside next to the artifact lib.
                    final Document artifactPom = createPomDocument(artifactMetadata);
                    final File artifactPomFile =
                            new File(targetJarDirectory, dependencyArtifactId + "-" + sdkVersion + ".pom");
                    writeDocument(artifactPom, artifactPomFile);
                }

                // Remember the checksum for later re-usage.
                BaseGenerator.checksums.put(checksum, artifactMetadata);
            }
        }

        // Add a reference to the versions pom of the framework. This is needed so the compiler can check which
        // versions of the framework libs belong to the current compiler version. This is especially needed to
        // perform the check if the correct version of framework.swc is included in the dependencies. This step
        // was needed due to the re-deployment of patched FDKs in 2011/2012 in which the framework.swc no longer
        // has the same version as the compiler.
        final MavenMetadata frameworkVersions = new MavenMetadata();
        frameworkVersions.setGroupId("com.adobe.air");
        frameworkVersions.setArtifactId("framework");
        frameworkVersions.setVersion(sdkVersion);
        frameworkVersions.setPackaging("pom");
        appendArtifact(frameworkVersions, dependencies);

        // Write the compiler-pom document to file.
        final File pomFile = new File(sdkTargetDirectory,
                "com/adobe/air/compiler/" + sdkVersion + "/compiler-" + sdkVersion + ".pom");
        writeDocument(pom, pomFile);
    }

}
