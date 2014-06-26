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
package org.apache.flex.utilities.converter;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;

import org.apache.flex.utilities.converter.exceptions.ConverterException;
import org.apache.flex.utilities.converter.model.MavenArtifact;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.codehaus.jettison.json.JSONTokener;

import java.io.*;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/**
 * Created by cdutz on 11.05.2012.
 */
public abstract class BaseConverter {

    protected final Map<String, MavenArtifact> checksums = new HashMap<String, MavenArtifact>();

    protected static final String MAVEN_CENTRAL_SHA_1_QUERY_URL = "http://search.maven.org/solrsearch/select?rows=20&wt=json&q=1:";
    // Artifactory: "http://server:port/artifactory/api/search/checksum?repos=libs-release-local&md5=04040c7c184620af0a0a8a3682a75eb7
    // Nexus: "http://repository.sonatype.org/service/local/data_index?a=04040c7c184620af0a0a8a3682a75eb7"

    protected File rootSourceDirectory;
    protected File rootTargetDirectory;

    private VelocityEngine velocityEngine;

    protected BaseConverter(File rootSourceDirectory, File rootTargetDirectory) throws ConverterException {
        if(rootSourceDirectory == null) {
            throw new ConverterException("Air SDK directory is null.");
        }
        if(rootTargetDirectory == null) {
            throw new ConverterException("Target directory is null.");
        }

        this.rootSourceDirectory = rootSourceDirectory;
        this.rootTargetDirectory = rootTargetDirectory;

        try {
            // Load some initial properties from the classpath.
            final Properties properties = new Properties();
            final InputStream propertyInputStream =
                  getClass().getClassLoader().getResourceAsStream("velocity.properties");
            if(propertyInputStream != null) {
                properties.load(propertyInputStream);
            }

            // Instantiate the engine that will be used for every generation.
            velocityEngine = new VelocityEngine(properties);
        } catch (Exception e) {
            throw new ConverterException("Error initializing the velocity template engine.", e);
        }
    }

    public void convert() throws ConverterException {
        if(rootSourceDirectory.isFile()) {
            processArchive();
        } else {
            processDirectory();
        }
    }

    abstract protected void processDirectory() throws ConverterException;

    protected void processArchive() throws ConverterException {

    }

    protected String calculateChecksum(File jarFile) throws ConverterException {
        // Implement the calculation of checksums for a given jar.
        final MessageDigest digest;
        try {
            digest = MessageDigest.getInstance("SHA-1");

            final InputStream is = new FileInputStream(jarFile);
            final byte[] buffer = new byte[8192];
            int read;
            try {
                while( (read = is.read(buffer)) > 0) {
                    digest.update(buffer, 0, read);
                }
                final byte[] md5sum = digest.digest();
                final BigInteger bigInt = new BigInteger(1, md5sum);
                return bigInt.toString(16);
            }
            catch(IOException e) {
                throw new RuntimeException("Unable to process file for MD5", e);
            }
            finally {
                try {
                    is.close();
                }
                catch(IOException e) {
                    //noinspection ThrowFromFinallyBlock
                    throw new RuntimeException("Unable to close input stream for MD5 calculation", e);
                }
            }
        } catch (NoSuchAlgorithmException e) {
            throw new ConverterException("Error calculating checksum of file '" + jarFile.getPath() + "'", e);
        } catch (FileNotFoundException e) {
            throw new ConverterException("Error calculating checksum of file '" + jarFile.getPath() + "'", e);
        }
    }

    protected MavenArtifact lookupMetadataForChecksum(String checksum) throws ConverterException {
        final String queryUrl = MAVEN_CENTRAL_SHA_1_QUERY_URL + checksum;

        final Client client = Client.create();
        final WebResource webResource = client.resource(queryUrl);
        final ClientResponse response = webResource.accept("application/json").get(ClientResponse.class);

      	if (response.getStatus() != 200) {
   		   throw new RuntimeException("Failed : HTTP error code : " + response.getStatus());
      	}

        final String output = response.getEntity(String.class);

        final BufferedReader reader = new BufferedReader(new StringReader(output));
        final StringBuilder builder = new StringBuilder();
        try {
            for (String line; (line = reader.readLine()) != null; ) {
                builder.append(line).append("\n");
            }
            final JSONTokener tokener = new JSONTokener(builder.toString());
            final JSONObject rootObject = new JSONObject(tokener);

            final JSONObject responseObject = (JSONObject) rootObject.get("response");
            final int numFound = (Integer) responseObject.get("numFound");
            if(numFound == 0) {
                return null;
            }
            else if(numFound == 1) {
                final JSONArray docs = (JSONArray) responseObject.get("docs");
                final JSONObject firstHit = (JSONObject) docs.get(0);

                final MavenArtifact artifactMetadata = new MavenArtifact();
                artifactMetadata.setGroupId((String) firstHit.get("g"));
                artifactMetadata.setArtifactId((String) firstHit.get("a"));
                artifactMetadata.setVersion((String) firstHit.get("v"));
                artifactMetadata.setPackaging((String) firstHit.get("p"));

                return artifactMetadata;
            } else {
                long newestTimestamp = 0;
                JSONObject newestVersion = null;

                JSONArray options = (JSONArray) responseObject.get("docs");
                // if the "groupId" is "batik" then use the newer version.
                for(int i = 0; i < numFound; i++) {
                    final JSONObject option = (JSONObject) options.get(0);
                    if("batik".equals(option.get("g")) && "batik-dom".equals(option.get("a")) && "jar".equals(option.get("p"))) {
                        final long timestamp = (Long) option.get("timestamp");
                        if(timestamp > newestTimestamp) {
                            newestTimestamp = timestamp;
                            newestVersion = option;
                        }
                    }
                }

                if(newestVersion != null) {
                    final MavenArtifact artifactMetadata = new MavenArtifact();
                    artifactMetadata.setGroupId((String) newestVersion.get("g"));
                    artifactMetadata.setArtifactId((String) newestVersion.get("a"));
                    artifactMetadata.setVersion((String) newestVersion.get("v"));
                    artifactMetadata.setPackaging((String) newestVersion.get("p"));

                    return artifactMetadata;
                } else {
                    System.out.println("For jar-file with checksum: " + checksum +
                            " more than one result was returned by query: " + queryUrl);
                }
            }
            return null;
        } catch(IOException e) {
            throw new ConverterException("Error processing Metadata for checksum: '" + checksum + "'", e);
        } catch (JSONException e) {
            throw new ConverterException("Error processing Metadata for checksum: '" + checksum + "'", e);
        }
    }

    protected void copyFile(File source, File target) throws ConverterException {
        try {
            final File outputDirectory = target.getParentFile();
            if(!outputDirectory.exists()) {
                if(!outputDirectory.mkdirs()) {
                    throw new RuntimeException("Could not create directory: " + outputDirectory.getAbsolutePath());
                }
            }

            final InputStream in = new FileInputStream(source);
            final OutputStream out = new FileOutputStream(target);

            final byte[] buf = new byte[1024];
            int len;
            while ((len = in.read(buf)) > 0){
                out.write(buf, 0, len);
            }

            in.close();
            out.close();
        } catch(IOException e) {
            throw new ConverterException("Error copying file from '" + source.getPath() +
                    "' to '" + target.getPath() + "'", e);
        }
    }

    protected void writePomArtifact(MavenArtifact pomData) throws ConverterException {
        final File outputFile = pomData.getPomTargetFile(rootTargetDirectory);
        createPomDocument(pomData, outputFile);
    }

    protected void createPomDocument(final MavenArtifact metadata, File outputFile) throws ConverterException {
        try {
            // Build a context to hold the model
            final VelocityContext velocityContext = new VelocityContext();
            velocityContext.put("artifact", metadata);

            // Try to get a template "templates/{type}.vm".
            final String templateName;
            if(velocityEngine.resourceExists("templates/" + metadata.getPackaging() + ".vm")) {
               templateName = "templates/" + metadata.getPackaging() + ".vm";
            } else if(velocityEngine.resourceExists("templates/default.vm")) {
               templateName = "templates/default.vm";
            } else {
               throw new ConverterException("No template found for generating pom output.");
            }

            // Prepare an output stream to which the output can be generated.
            FileWriter writer = null;
            try {
                if(!outputFile.getParentFile().exists()) {
                    if(!outputFile.getParentFile().mkdirs()) {
                        throw new ConverterException("Could not create template output directory.");
                    }
                }

                writer = new FileWriter(outputFile);

                // Have velocity generate the output for the template.
                velocityEngine.mergeTemplate(templateName, "utf-8", velocityContext, writer);
            } finally {
                if(writer != null) {
                    writer.close();
                }
            }
        } catch (Exception e) {
            throw new ConverterException("Error generating template output.", e);
        }

        /*final DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setNamespaceAware(true);
        final DocumentBuilder builder;
        try {
            builder = factory.newDocumentBuilder();
            DOMImplementation domImpl = builder.getDOMImplementation();
            final Document pom = domImpl.createDocument(MAVEN_SCHEMA_URI, "project", null);

            final Element root = pom.getDocumentElement();
            final Element modelVersion = pom.createElementNS(MAVEN_SCHEMA_URI, "modelVersion");
            modelVersion.setTextContent("4.0.0");
            root.appendChild(modelVersion);
            final Element groupId = pom.createElementNS(MAVEN_SCHEMA_URI, "groupId");
            groupId.setTextContent(metadata.getGroupId());
            root.appendChild(groupId);
            final Element artifactId = pom.createElementNS(MAVEN_SCHEMA_URI, "artifactId");
            artifactId.setTextContent(metadata.getArtifactId());
            root.appendChild(artifactId);
            final Element version = pom.createElementNS(MAVEN_SCHEMA_URI, "version");
            version.setTextContent(metadata.getVersion());
            root.appendChild(version);
            final Element packaging = pom.createElementNS(MAVEN_SCHEMA_URI, "packaging");
            packaging.setTextContent(metadata.getPackaging());
            root.appendChild(packaging);

            // Output dependency data.
            if((metadata.getDependencies() != null) && !metadata.getDependencies().isEmpty()) {
                final Element dependencies = pom.createElementNS(MAVEN_SCHEMA_URI, "dependencies");
                root.appendChild(dependencies);
                final Element dependencyManagement = pom.createElementNS(MAVEN_SCHEMA_URI, "dependencyManagement");
                final Element dependencyManagementDependencies = pom.createElementNS(MAVEN_SCHEMA_URI, "dependencies");
                dependencyManagement.appendChild(dependencyManagementDependencies);
                root.appendChild(dependencyManagement);

                final Map<String, MavenArtifact> dependencyIndex = new HashMap<String, MavenArtifact>();
                for(final MavenArtifact dependencyMetadata : metadata.getDependencies()) {
                    Element dependency = pom.createElementNS(MAVEN_SCHEMA_URI, "dependency");
                    dependencies.appendChild(dependency);

                    // Generate the normal dependency.
                    Element dependencyGroupId = pom.createElementNS(MAVEN_SCHEMA_URI, "groupId");
                    dependencyGroupId.setTextContent(dependencyMetadata.getGroupId());
                    dependency.appendChild(dependencyGroupId);
                    Element dependencyArtifactId = pom.createElementNS(MAVEN_SCHEMA_URI, "artifactId");
                    dependencyArtifactId.setTextContent(dependencyMetadata.getArtifactId());
                    dependency.appendChild(dependencyArtifactId);
                    Element dependencyVersion = pom.createElementNS(MAVEN_SCHEMA_URI, "version");
                    dependencyVersion.setTextContent(dependencyMetadata.getVersion());
                    dependency.appendChild(dependencyVersion);
                    Element dependencyPackaging = pom.createElementNS(MAVEN_SCHEMA_URI, "type");
                    dependencyPackaging.setTextContent(dependencyMetadata.getPackaging());
                    dependency.appendChild(dependencyPackaging);
                    if(dependencyMetadata.getClassifier() != null) {
                        final Element dependencyClassifier = pom.createElementNS(MAVEN_SCHEMA_URI, "classifier");
                        dependencyClassifier.setTextContent(dependencyMetadata.getClassifier());
                        dependency.appendChild(dependencyClassifier);
                    }

                    // Configure the dependency including version in the dependency management section of the pom.
                    dependency = pom.createElementNS(MAVEN_SCHEMA_URI, "dependency");
                    dependencyGroupId = pom.createElementNS(MAVEN_SCHEMA_URI, "groupId");
                    dependencyGroupId.setTextContent(dependencyMetadata.getGroupId());
                    dependency.appendChild(dependencyGroupId);
                    dependencyArtifactId = pom.createElementNS(MAVEN_SCHEMA_URI, "artifactId");
                    dependencyArtifactId.setTextContent(dependencyMetadata.getArtifactId());
                    dependency.appendChild(dependencyArtifactId);
                    Element dependencyVersion = pom.createElementNS(MAVEN_SCHEMA_URI, "version");
                    dependencyVersion.setTextContent(dependencyMetadata.getVersion());
                    dependency.appendChild(dependencyVersion);
                    dependencyPackaging = pom.createElementNS(MAVEN_SCHEMA_URI, "type");
                    dependencyPackaging.setTextContent(dependencyMetadata.getPackaging());
                    dependency.appendChild(dependencyPackaging);
                    dependencyManagementDependencies.appendChild(dependency);

                    dependencyIndex.put(dependencyMetadata.getArtifactId(), dependencyMetadata);
                }

                // Output the rb.swc dependencies.
                if(metadata.getLibrariesWithResourceBundles() != null) {
                    for(final String artifactWithResourceBundle : metadata.getLibrariesWithResourceBundles()) {
                        final MavenArtifact dependencyMetadata = dependencyIndex.get(artifactWithResourceBundle);
                        if(dependencyMetadata != null) {
                            final Element dependency = pom.createElementNS(MAVEN_SCHEMA_URI, "dependency");
                            dependencies.appendChild(dependency);

                            final Element dependencyGroupId = pom.createElementNS(MAVEN_SCHEMA_URI, "groupId");
                            dependencyGroupId.setTextContent(dependencyMetadata.getGroupId());
                            dependency.appendChild(dependencyGroupId);
                            final Element dependencyArtifactId = pom.createElementNS(MAVEN_SCHEMA_URI, "artifactId");
                            dependencyArtifactId.setTextContent(dependencyMetadata.getArtifactId());
                            dependency.appendChild(dependencyArtifactId);
                            final Element dependencyVersion = pom.createElementNS(MAVEN_SCHEMA_URI, "version");
                            dependencyVersion.setTextContent(dependencyMetadata.getVersion());
                            dependency.appendChild(dependencyVersion);
                            final Element dependencyPackaging = pom.createElementNS(MAVEN_SCHEMA_URI, "type");
                            dependencyPackaging.setTextContent("rb.swc");
                            dependency.appendChild(dependencyPackaging);
                        }
                    }
                }
            }
            return pom;
        } catch (ParserConfigurationException e) {
            throw new ConverterException("Error creating pom document.", e);
        }*/
    }

    protected void writeDummy(final File targetFile) throws ConverterException {
        try {
            final ZipOutputStream out = new ZipOutputStream(new FileOutputStream(targetFile));
            out.putNextEntry(new ZipEntry("dummy"));
            out.closeEntry();
            out.close();
        } catch (IOException e) {
            throw new ConverterException("Error generating dummy resouce bundle.");
        }
    }

    protected static File findDirectory(File directory, String directoryToFind) {
        File[] entries = directory.listFiles();
        File founded = null;

        // Go over entries
        if(entries != null) {
            for (File entry : entries) {
                if (entry.isDirectory() && directoryToFind.equalsIgnoreCase(entry.getName())) {
                    founded = entry;
                    break;
                }
                if (entry.isDirectory()) {
                    founded = findDirectory(entry, directoryToFind);
                    if (founded != null)
                        break;
                }
            }
        }
        return founded;
    }

    protected MavenArtifact resolveArtifact(File sourceFile, String defaultGroupId, String defaultVersion)
            throws ConverterException {
        // Calculate a checksum for the current file. We will use this checksum to query maven central
        // in order to find out if this lib has already been published. If it has, there is no need to
        // publish it again under a new name. In case a matching artifact is found the generated FDK
        // will use the already deployed version. Additionally the checksum will be saved and if a
        // fdk generated after this one uses the same version of a lib, the version of the older fdk is
        // used also reducing the amount of jars that have to be re-deployed.
        final String checksum = calculateChecksum(sourceFile);

        // Try to get artifact metadata based upon the checksum by looking up the internal cache.
        MavenArtifact artifact =  checksums.get(checksum);

        // Reusing artifact from other sdk version.
        if(artifact != null) {
            System.out.println("Reusing artifact (" + checksum + ") : " + artifact.getGroupId() + ":" +
                    artifact.getArtifactId() + ":" + artifact.getVersion());
            return artifact;
        }
        // Id no artifact was found in the local cache, continue processing.
        else {
            // Do a lookup in maven central.
            artifact = lookupMetadataForChecksum(checksum);

            // The file was available on maven central, so use that version instead of the one coming with the sdk.
            if(artifact != null) {
                System.out.println("Using artifact from Maven Central (" + checksum + ") : " +
                        artifact.getGroupId() + ":" + artifact.getArtifactId() + ":" + artifact.getVersion());
            }
            // The file was not available on maven central, so we have to add it manually.
            else {
                // The artifact name is the name of the jar.
                final String artifactFileName = sourceFile.getName();
                final String dependencyArtifactId = artifactFileName.substring(0, artifactFileName.lastIndexOf("."));
                final String dependencyArtifactPackaging =
                        artifactFileName.substring(artifactFileName.lastIndexOf(".") + 1);

                // Generate a new metadata object
                artifact = new MavenArtifact();
                artifact.setGroupId(defaultGroupId);
                artifact.setArtifactId(dependencyArtifactId);
                artifact.setVersion(defaultVersion);
                artifact.setPackaging(dependencyArtifactPackaging);
                artifact.addDefaultBinaryArtifact(sourceFile);

                // Create the pom document that will reside next to the artifact lib.
                writeArtifact(artifact);
            }

            // Remember the checksum for later re-usage.
            checksums.put(checksum, artifact);

            return artifact;
        }
    }

    protected void writeArtifact(MavenArtifact artifact) throws ConverterException {
        // Write the pom itself.
        writePomArtifact(artifact);
        final List<String> binaryClassifiers = artifact.getBinaryFilesClassifiers();
        for(final String classifier : binaryClassifiers) {
            final File binarySourceFile = artifact.getBinarySourceFile(classifier);
            final File binaryTargetFile = artifact.getBinaryTargetFile(rootTargetDirectory, classifier);
            copyFile(binarySourceFile, binaryTargetFile);
        }
    }

}
