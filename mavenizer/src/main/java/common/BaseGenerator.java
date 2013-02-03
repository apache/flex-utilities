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

import java.io.*;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.util.*;
import javax.xml.parsers.*;
import javax.xml.transform.*;
import javax.xml.transform.dom.*;
import javax.xml.transform.stream.*;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONObject;
import org.codehaus.jettison.json.JSONTokener;
import org.w3c.dom.DOMImplementation;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;

/**
 * Created with IntelliJ IDEA.
 * User: cdutz
 * Date: 11.05.12
 * Time: 14:53
 */
public abstract class BaseGenerator {

    protected static final Map<String, MavenMetadata> checksums = new HashMap<String, MavenMetadata>();

    protected static final String MAVEN_SCHEMA_URI = "http://maven.apache.org/POM/4.0.0";
    protected static final String MAVEN_CENTRAL_SHA_1_QUERY_URL = "http://search.maven.org/solrsearch/select?rows=20&wt=json&q=1:";
    // Artifactory: "http://server:port/artifactory/api/search/checksum?repos=libs-release-local&md5=04040c7c184620af0a0a8a3682a75eb7
    // Nexus: "http://repository.sonatype.org/service/local/data_index?a=04040c7c184620af0a0a8a3682a75eb7"

    abstract public void process(File sdkSourceDirectory, boolean isApache, File sdkTargetDirectory, String sdkVersion, boolean useApache)
            throws Exception;

    protected String calculateChecksum(File jarFile) throws Exception {
        // Implement the calculation of checksums for a given jar.
        final MessageDigest digest = MessageDigest.getInstance("SHA-1");

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
    }

    protected MavenMetadata lookupMetadataForChecksum(String checksum) throws Exception {
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

            final MavenMetadata artifactMetadata = new MavenMetadata();
            artifactMetadata.groupId = (String) firstHit.get("g");
            artifactMetadata.artifactId = (String) firstHit.get("a");
            artifactMetadata.version = (String) firstHit.get("v");
            artifactMetadata.packaging = (String) firstHit.get("p");

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
                final MavenMetadata artifactMetadata = new MavenMetadata();
                artifactMetadata.groupId = (String) newestVersion.get("g");
                artifactMetadata.artifactId = (String) newestVersion.get("a");
                artifactMetadata.version = (String) newestVersion.get("v");
                artifactMetadata.packaging = (String) newestVersion.get("p");

                return artifactMetadata;
            } else {
                System.out.println("For jar-file with checksum: " + checksum +
                        " more than one result was returned by query: " + queryUrl);
            }
        }
        return null;
    }

    protected void copyFile(File source, File target) throws Exception {
        InputStream in = new FileInputStream(source);
        OutputStream out = new FileOutputStream(target);

        byte[] buf = new byte[1024];
        int len;
        while ((len = in.read(buf)) > 0){
            out.write(buf, 0, len);
        }

        in.close();
        out.close();
    }

    protected void appendArtifact(MavenMetadata artifactMetadata, Element dependencies) {
        final Document doc = dependencies.getOwnerDocument();
        final Element dependency = doc.createElementNS(MAVEN_SCHEMA_URI, "dependency");
        dependencies.appendChild(dependency);

        final Element groupId = doc.createElementNS(MAVEN_SCHEMA_URI, "groupId");
        groupId.setTextContent(artifactMetadata.groupId);
        dependency.appendChild(groupId);
        final Element artifactId = doc.createElementNS(MAVEN_SCHEMA_URI, "artifactId");
        artifactId.setTextContent(artifactMetadata.artifactId);
        dependency.appendChild(artifactId);
        final Element version = doc.createElementNS(MAVEN_SCHEMA_URI, "version");
        version.setTextContent(artifactMetadata.version);
        dependency.appendChild(version);
        if(!artifactMetadata.getPackaging().equals("jar")) {
            final Element packaging = doc.createElementNS(MAVEN_SCHEMA_URI, "type");
            packaging.setTextContent(artifactMetadata.packaging);
            dependency.appendChild(packaging);
        }
    }

    protected void writeDocument(Document doc, File outputFile) throws Exception {
        final Source source = new DOMSource(doc);
        final File outputDirectory = outputFile.getParentFile();
        if(!outputDirectory.exists()) {
            if(!outputDirectory.mkdirs()) {
                throw new RuntimeException("Could not create directory: " + outputDirectory.getAbsolutePath());
            }
        }

        final Result result = new StreamResult(outputFile);
        final Transformer transformer = TransformerFactory.newInstance().newTransformer();
        transformer.setOutputProperty(OutputKeys.INDENT, "yes");
        transformer.setOutputProperty("{http://xml.apache.org/xslt}indent-amount", "4");
        transformer.transform(source, result);
    }

    protected Document createPomDocument(final MavenMetadata metadata) throws Exception {
        final DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setNamespaceAware(true);
        final DocumentBuilder builder = factory.newDocumentBuilder();
        DOMImplementation domImpl = builder.getDOMImplementation();
        final Document pom = domImpl.createDocument(MAVEN_SCHEMA_URI, "project", null);

        final Element root = pom.getDocumentElement();
        final Element modelVersion = pom.createElementNS(MAVEN_SCHEMA_URI, "modelVersion");
        modelVersion.setTextContent("4.0.0");
        root.appendChild(modelVersion);
        final Element groupId = pom.createElementNS(MAVEN_SCHEMA_URI, "groupId");
        groupId.setTextContent(metadata.groupId);
        root.appendChild(groupId);
        final Element artifactId = pom.createElementNS(MAVEN_SCHEMA_URI, "artifactId");
        artifactId.setTextContent(metadata.artifactId);
        root.appendChild(artifactId);
        final Element version = pom.createElementNS(MAVEN_SCHEMA_URI, "version");
        version.setTextContent(metadata.version);
        root.appendChild(version);
        final Element packaging = pom.createElementNS(MAVEN_SCHEMA_URI, "packaging");
        packaging.setTextContent(metadata.packaging);
        root.appendChild(packaging);

        // Output dependency data.
        if((metadata.dependencies != null) && !metadata.dependencies.isEmpty()) {
            final Element dependencies = pom.createElementNS(MAVEN_SCHEMA_URI, "dependencies");
            root.appendChild(dependencies);

            final Map<String, MavenMetadata> dependencyIndex = new HashMap<String, MavenMetadata>();
            for(final MavenMetadata dependencyMetadata : metadata.dependencies) {
                final Element dependency = pom.createElementNS(MAVEN_SCHEMA_URI, "dependency");
                dependencies.appendChild(dependency);

                final Element dependencyGroupId = pom.createElementNS(MAVEN_SCHEMA_URI, "groupId");
                dependencyGroupId.setTextContent(dependencyMetadata.groupId);
                dependency.appendChild(dependencyGroupId);
                final Element dependencyArtifactId = pom.createElementNS(MAVEN_SCHEMA_URI, "artifactId");
                dependencyArtifactId.setTextContent(dependencyMetadata.artifactId);
                dependency.appendChild(dependencyArtifactId);
                final Element dependencyVersion = pom.createElementNS(MAVEN_SCHEMA_URI, "version");
                dependencyVersion.setTextContent(dependencyMetadata.version);
                dependency.appendChild(dependencyVersion);
                final Element dependencyPackaging = pom.createElementNS(MAVEN_SCHEMA_URI, "type");
                dependencyPackaging.setTextContent(dependencyMetadata.packaging);
                dependency.appendChild(dependencyPackaging);
                if(dependencyMetadata.classifier != null) {
                    final Element dependencyClassifier = pom.createElementNS(MAVEN_SCHEMA_URI, "classifier");
                    dependencyClassifier.setTextContent(dependencyMetadata.classifier);
                    dependency.appendChild(dependencyClassifier);
                }

                dependencyIndex.put(dependencyMetadata.artifactId, dependencyMetadata);
            }

            // Output the rb.swc dependencies.
            if(metadata.librariesWithResourceBundles != null) {
                for(final String artifactWithResourceBundle : metadata.librariesWithResourceBundles) {
                    final MavenMetadata dependencyMetadata = dependencyIndex.get(artifactWithResourceBundle);
                    if(dependencyMetadata != null) {
                        final Element dependency = pom.createElementNS(MAVEN_SCHEMA_URI, "dependency");
                        dependencies.appendChild(dependency);

                        final Element dependencyGroupId = pom.createElementNS(MAVEN_SCHEMA_URI, "groupId");
                        dependencyGroupId.setTextContent(dependencyMetadata.groupId);
                        dependency.appendChild(dependencyGroupId);
                        final Element dependencyArtifactId = pom.createElementNS(MAVEN_SCHEMA_URI, "artifactId");
                        dependencyArtifactId.setTextContent(dependencyMetadata.artifactId);
                        dependency.appendChild(dependencyArtifactId);
                        final Element dependencyVersion = pom.createElementNS(MAVEN_SCHEMA_URI, "version");
                        dependencyVersion.setTextContent(dependencyMetadata.version);
                        dependency.appendChild(dependencyVersion);
                        final Element dependencyPackaging = pom.createElementNS(MAVEN_SCHEMA_URI, "type");
                        dependencyPackaging.setTextContent("rb.swc");
                        dependency.appendChild(dependencyPackaging);
                    }
                }
            }
        }

        return pom;
    }

    protected Document createPomDocumentDependencyManagement(final MavenMetadata metadata) throws Exception {
        final DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        factory.setNamespaceAware(true);
        final DocumentBuilder builder = factory.newDocumentBuilder();
        DOMImplementation domImpl = builder.getDOMImplementation();
        final Document pom = domImpl.createDocument(MAVEN_SCHEMA_URI, "project", null);

        final Element root = pom.getDocumentElement();
        final Element modelVersion = pom.createElementNS(MAVEN_SCHEMA_URI, "modelVersion");
        modelVersion.setTextContent("4.0.0");
        root.appendChild(modelVersion);
        final Element groupId = pom.createElementNS(MAVEN_SCHEMA_URI, "groupId");
        groupId.setTextContent(metadata.groupId);
        root.appendChild(groupId);
        final Element artifactId = pom.createElementNS(MAVEN_SCHEMA_URI, "artifactId");
        artifactId.setTextContent(metadata.artifactId);
        root.appendChild(artifactId);
        final Element version = pom.createElementNS(MAVEN_SCHEMA_URI, "version");
        version.setTextContent(metadata.version);
        root.appendChild(version);
        final Element packaging = pom.createElementNS(MAVEN_SCHEMA_URI, "packaging");
        packaging.setTextContent(metadata.packaging);
        root.appendChild(packaging);

        // Output dependency data.
        if((metadata.dependencies != null) && !metadata.dependencies.isEmpty()) {
            final Element dependencyManagement = pom.createElementNS(MAVEN_SCHEMA_URI, "dependencyManagement");
            root.appendChild(dependencyManagement);
            final Element dependencies = pom.createElementNS(MAVEN_SCHEMA_URI, "dependencies");
            dependencyManagement.appendChild(dependencies);

            final Map<String, MavenMetadata> dependencyIndex = new HashMap<String, MavenMetadata>();
            for(final MavenMetadata dependencyMetadata : metadata.dependencies) {
                final Element dependency = pom.createElementNS(MAVEN_SCHEMA_URI, "dependency");
                dependencies.appendChild(dependency);

                final Element dependencyGroupId = pom.createElementNS(MAVEN_SCHEMA_URI, "groupId");
                dependencyGroupId.setTextContent(dependencyMetadata.groupId);
                dependency.appendChild(dependencyGroupId);
                final Element dependencyArtifactId = pom.createElementNS(MAVEN_SCHEMA_URI, "artifactId");
                dependencyArtifactId.setTextContent(dependencyMetadata.artifactId);
                dependency.appendChild(dependencyArtifactId);
                final Element dependencyVersion = pom.createElementNS(MAVEN_SCHEMA_URI, "version");
                dependencyVersion.setTextContent(dependencyMetadata.version);
                dependency.appendChild(dependencyVersion);
                final Element dependencyPackaging = pom.createElementNS(MAVEN_SCHEMA_URI, "type");
                dependencyPackaging.setTextContent(dependencyMetadata.packaging);
                dependency.appendChild(dependencyPackaging);
                if(dependencyMetadata.classifier != null) {
                    final Element dependencyClassifier = pom.createElementNS(MAVEN_SCHEMA_URI, "classifier");
                    dependencyClassifier.setTextContent(dependencyMetadata.classifier);
                    dependency.appendChild(dependencyClassifier);
                }

                dependencyIndex.put(dependencyMetadata.artifactId, dependencyMetadata);
            }

            // Output the rb.swc dependencies.
            for(final String artifactWithResourceBundle : metadata.librariesWithResourceBundles) {
                final MavenMetadata dependencyMetadata = dependencyIndex.get(artifactWithResourceBundle);
                if(dependencyMetadata != null) {
                    final Element dependency = pom.createElementNS(MAVEN_SCHEMA_URI, "dependency");
                    dependencies.appendChild(dependency);

                    final Element dependencyGroupId = pom.createElementNS(MAVEN_SCHEMA_URI, "groupId");
                    dependencyGroupId.setTextContent(dependencyMetadata.groupId);
                    dependency.appendChild(dependencyGroupId);
                    final Element dependencyArtifactId = pom.createElementNS(MAVEN_SCHEMA_URI, "artifactId");
                    dependencyArtifactId.setTextContent(dependencyMetadata.artifactId);
                    dependency.appendChild(dependencyArtifactId);
                    final Element dependencyVersion = pom.createElementNS(MAVEN_SCHEMA_URI, "version");
                    dependencyVersion.setTextContent(dependencyMetadata.version);
                    dependency.appendChild(dependencyVersion);
                    final Element dependencyPackaging = pom.createElementNS(MAVEN_SCHEMA_URI, "type");
                    dependencyPackaging.setTextContent("rb.swc");
                    dependency.appendChild(dependencyPackaging);
                }
            }
        }

        return pom;
    }

    protected static File findDirectory(File directory, String directoryToFind) {
        File[] entries = directory.listFiles();
        File founded = null;

        // Go over entries
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
        return founded;
    }
}
