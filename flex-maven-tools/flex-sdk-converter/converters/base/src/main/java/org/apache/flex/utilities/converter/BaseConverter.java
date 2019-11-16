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

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateExceptionHandler;
import org.apache.flex.utilities.converter.api.ProxySettings;
import org.apache.flex.utilities.converter.exceptions.ConverterException;
import org.apache.flex.utilities.converter.model.MavenArtifact;
import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.codehaus.jettison.json.JSONTokener;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.*;
import java.math.BigInteger;
import java.net.*;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public abstract class BaseConverter {

    private static final Logger LOG = LoggerFactory.getLogger(BaseConverter.class);

    protected final Map<String, MavenArtifact> checksums = new HashMap<String, MavenArtifact>();

    protected static final String MAVEN_CENTRAL_SHA_1_QUERY_URL = "http://search.maven.org/solrsearch/select?rows=20&wt=json&q=1:";
    // Artifactory: "http://server:port/artifactory/api/search/checksum?repos=libs-release-local&md5=04040c7c184620af0a0a8a3682a75eb7
    // Nexus: "http://repository.sonatype.org/service/local/data_index?a=04040c7c184620af0a0a8a3682a75eb7"

    protected File rootSourceDirectory;
    protected File rootTargetDirectory;

    protected Configuration freemarkerConfig;

    protected BaseConverter(File rootSourceDirectory, File rootTargetDirectory) throws ConverterException {
        if(rootSourceDirectory == null) {
            throw new ConverterException("Air SDK directory is null.");
        }
        if(rootTargetDirectory == null) {
            throw new ConverterException("Target directory is null.");
        }

        this.rootSourceDirectory = rootSourceDirectory;
        this.rootTargetDirectory = rootTargetDirectory;

        this.freemarkerConfig = new Configuration(Configuration.VERSION_2_3_22);
        this.freemarkerConfig.setDefaultEncoding("UTF-8");
        this.freemarkerConfig.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
        this.freemarkerConfig.setClassForTemplateLoading(this.getClass(), "/");
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
        InputStream is = null;
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-1");

            is = new FileInputStream(jarFile);
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
                throw new ConverterException("Unable to process file for MD5", e);
            }
        } catch (NoSuchAlgorithmException e) {
            throw new ConverterException("Error calculating checksum of file '" + jarFile.getPath() + "'", e);
        } catch (FileNotFoundException e) {
            throw new ConverterException("Error calculating checksum of file '" + jarFile.getPath() + "'", e);
        } finally {
            if(is != null) {
                try {
                    is.close();
                } catch(IOException e) {
                    // Ignore ...
                }
            }
        }
    }

    protected MavenArtifact lookupMetadataForChecksum(String checksum) throws ConverterException {
        String output = null;
        try {
            final URL queryUrl = new URL(MAVEN_CENTRAL_SHA_1_QUERY_URL + checksum);

            URLConnection connection;
            ProxySettings proxySettings = ProxySettings.getProxySettings();
            if (proxySettings != null) {
                SocketAddress socketAddress = new InetSocketAddress(proxySettings.getHost(), proxySettings.getPort());
                Proxy proxy = new Proxy(Proxy.Type.valueOf(proxySettings.getProtocol().toUpperCase()), socketAddress);
                connection = queryUrl.openConnection(proxy);
            } else {
                connection = queryUrl.openConnection();
            }
            ReadableByteChannel rbc = null;
            try {
                rbc = Channels.newChannel(connection.getInputStream());
                final ByteBuffer byteBuffer = ByteBuffer.allocate(1024);
                if (rbc.read(byteBuffer) > 0) {
                    output = new String(byteBuffer.array(), "UTF-8");
                }
            } finally {
                if(rbc != null) {
                    rbc.close();
                }
            }
        } catch (MalformedURLException e) {
            throw new ConverterException("Error querying maven central.", e);
        } catch (IOException e) {
            throw new ConverterException("Error querying maven central.", e);
        }

        if(output != null) {
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
                if (numFound == 0) {
                    return null;
                } else if (numFound == 1) {
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
                    for (int i = 0; i < numFound; i++) {
                        final JSONObject option = (JSONObject) options.get(0);
                        if ("batik".equals(option.get("g")) && "batik-dom".equals(option.get("a")) && "jar".equals(option.get("p"))) {
                            final long timestamp = (Long) option.get("timestamp");
                            if (timestamp > newestTimestamp) {
                                newestTimestamp = timestamp;
                                newestVersion = option;
                            }
                        }
                    }

                    if (newestVersion != null) {
                        final MavenArtifact artifactMetadata = new MavenArtifact();
                        artifactMetadata.setGroupId((String) newestVersion.get("g"));
                        artifactMetadata.setArtifactId((String) newestVersion.get("a"));
                        artifactMetadata.setVersion((String) newestVersion.get("v"));
                        artifactMetadata.setPackaging((String) newestVersion.get("p"));

                        return artifactMetadata;
                    } else {
                        LOG.warn("For jar-file with checksum: " + checksum +
                                " more than one result was returned by query: " +
                                MAVEN_CENTRAL_SHA_1_QUERY_URL + checksum);
                    }
                }
            } catch (IOException e) {
                throw new ConverterException("Error processing Metadata for checksum: '" + checksum + "'", e);
            } catch (JSONException e) {
                throw new ConverterException("Error processing Metadata for checksum: '" + checksum + "'", e);
            }
        }
        return null;
    }

    protected void copyFile(File source, File target) throws ConverterException {
        try {
            final File outputDirectory = target.getParentFile();
            if(!outputDirectory.exists()) {
                if(!outputDirectory.mkdirs()) {
                    throw new ConverterException("Could not create directory: " + outputDirectory.getAbsolutePath());
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
            Map<String, Object> freemarkerContext = new HashMap<String, Object>();
            freemarkerContext.put("artifact", metadata);

            // Try to get a template "templates/{type}.vm".
            Template template;
            URL check = this.getClass().getClassLoader().getResource("templates/" + metadata.getPackaging() + ".ftl");
            if(check != null) {
                template = freemarkerConfig.getTemplate("templates/" + metadata.getPackaging() + ".ftl");
            } else {
                template = freemarkerConfig.getTemplate("templates/default.ftl");
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

                // Have Freemarker generate the output for the template.
                template.process(freemarkerContext, writer);
            } finally {
                if(writer != null) {
                    writer.close();
                }
            }
        } catch (Exception e) {
            throw new ConverterException("Error generating template output.", e);
        }
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
            LOG.info("Reusing artifact (" + checksum + ") : " + artifact.getGroupId() + ":" +
                    artifact.getArtifactId() + ":" + artifact.getVersion());
            return artifact;
        }
        // Id no artifact was found in the local cache, continue processing.
        else {
            // Do a lookup in maven central.
            artifact = lookupMetadataForChecksum(checksum);

            // The file was available on maven central, so use that version instead of the one coming with the sdk.
            if(artifact != null) {
                LOG.info("Using artifact from Maven Central (" + checksum + ") : " +
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

    protected void generateZip(File[] sourceFiles, File targetFile) throws ConverterException {
        if((sourceFiles == null) || (sourceFiles.length == 0)) {
            return;
        }
        final File rootDir = sourceFiles[0].getParentFile();
        generateZip(rootDir, sourceFiles, targetFile);
    }

    protected void generateZip(File rootDir, File[] sourceFiles, File targetFile) throws ConverterException {
        if((sourceFiles == null) || (sourceFiles.length == 0)) {
            return;
        }
        final File zipInputFiles[] = new File[sourceFiles.length];
        System.arraycopy(sourceFiles, 0, zipInputFiles, 0, sourceFiles.length);

        try {
            // Add all the content to a zip-file.
            final ZipOutputStream zipOutputStream = new ZipOutputStream(new FileOutputStream(targetFile));
            for (final File file : zipInputFiles) {
                addFileToZip(zipOutputStream, file, rootDir);
            }
            zipOutputStream.close();
        } catch(IOException e) {
            throw new ConverterException("Error generating " + targetFile.getName() + " zip.", e);
        }
    }

    protected void addFileToZip(ZipOutputStream zipOutputStream, File inputFile, File rootDirectory)
          throws ConverterException {

        if (inputFile == null) {
            return;
        }

        // If this is a directory, add all it's children.
        if (inputFile.isDirectory()) {
            final File directoryContent[] = inputFile.listFiles();
            if (directoryContent != null) {
                for (final File file : directoryContent) {
                    addFileToZip(zipOutputStream, file, rootDirectory);
                }
            }
        }
        // If this is a file, add it to the zips output.
        else {
            byte[] buf = new byte[1024];
            try {
                final FileInputStream in = new FileInputStream(inputFile);
                final String zipPath = inputFile.getAbsolutePath().substring(
                      rootDirectory.getAbsolutePath().length() + 1).replace("\\", "/");
                zipOutputStream.putNextEntry(new ZipEntry(zipPath));
                int len;
                while ((len = in.read(buf)) > 0) {
                    zipOutputStream.write(buf, 0, len);
                }
                zipOutputStream.closeEntry();
                in.close();
            } catch(IOException e) {
                throw new ConverterException("Error adding files to zip.", e);
            }
        }
    }

    /**
     * Get the version of an Flex SDK from the content of the SDK directory.
     *
     * @return version string for the current Flex SDK
     */
    protected String getFlexVersion(File rootDirectory) throws ConverterException {
        final File sdkDescriptor = new File(rootDirectory, "flex-sdk-description.xml");

        // If the descriptor is not present, return null as this FDK directory doesn't
        // seem to contain a Flex SDK.
        if(!sdkDescriptor.exists()) {
            return null;
        }

        final DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        try {
            // Parse the document
            final DocumentBuilder db = dbf.newDocumentBuilder();
            final Document dom = db.parse(sdkDescriptor);

            // Get name, version and build nodes
            final Element root = dom.getDocumentElement();
            final String version = root.getElementsByTagName("version").item(0).getTextContent();
            final String build = root.getElementsByTagName("build").item(0).getTextContent();

            // In general the version consists of the content of the version element with an appended build-number.
            return (build.equals("0")) ? version + "-SNAPSHOT" : version;
        } catch (ParserConfigurationException pce) {
            throw new ConverterException("Error parsing flex-sdk-description.xml", pce);
        } catch (SAXException se) {
            throw new ConverterException("Error parsing flex-sdk-description.xml", se);
        } catch (IOException ioe) {
            throw new ConverterException("Error parsing flex-sdk-description.xml", ioe);
        }
    }

    protected Collection<File> listAllFiles(File source, FileFilter filter) {
        if(filter.accept(source)) {
            return Collections.singleton(source);
        }
        else if(source.isDirectory()) {
            File[] dirContent = source.listFiles();
            if(dirContent != null) {
                Collection<File> filteredContent = new LinkedList<File>();
                for(File child : dirContent) {
                    filteredContent.addAll(listAllFiles(child, filter));
                }
                return filteredContent;
            }
        }
        return Collections.emptyList();
    }

}
