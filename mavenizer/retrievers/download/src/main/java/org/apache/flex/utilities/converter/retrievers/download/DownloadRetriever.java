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
package org.apache.flex.utilities.converter.retrievers.download;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.flex.utilities.converter.retrievers.BaseRetriever;
import org.apache.flex.utilities.converter.retrievers.exceptions.RetrieverException;
import org.apache.flex.utilities.converter.retrievers.types.PlatformType;
import org.apache.flex.utilities.converter.retrievers.types.SdkType;
import org.apache.flex.utilities.converter.retrievers.utils.ProgressBar;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.maven.artifact.versioning.DefaultArtifactVersion;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import java.io.*;
import java.net.*;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.text.MessageFormat;
import java.util.*;

/**
 * Created by cdutz on 18.05.2014.
 */
public class DownloadRetriever extends BaseRetriever {

    public static final String FLEX_INSTALLER_CONFIG_URL =
            "http://flex.apache.org/installer/sdk-installer-config-4.0.xml";

    /**
     * Wrapper to allow simple overriding of this property.
     *
     * @return URL from which the version information should be loaded.
     */
    protected String getFlexInstallerConfigUrl() {
        return FLEX_INSTALLER_CONFIG_URL;
    }

    public File retrieve(SdkType type) throws RetrieverException {
        return retrieve(type, null, null);
    }

    public File retrieve(SdkType type, String version) throws RetrieverException {
        return retrieve(type, version, null);
    }

    public File retrieve(SdkType type, String version, PlatformType platformType) throws RetrieverException {
        try {
            if (type.equals(SdkType.FLASH) || type.equals(SdkType.AIR) || type.equals(SdkType.FONTKIT)) {
                confirmLicenseAcceptance(type);
            }

            if(type.equals(SdkType.FONTKIT)) {
                File tmpTargetFile = File.createTempFile(UUID.randomUUID().toString(), "");
                String tempSuffix = tmpTargetFile.getName().substring(tmpTargetFile.getName().lastIndexOf("-"));
                if(!(tmpTargetFile.delete()))
                {
                    throw new IOException("Could not delete temp file: " + tmpTargetFile.getAbsolutePath());
                }

                File targetRootDir = new File(tmpTargetFile.getParentFile(), type.toString() + tempSuffix);
                File targetDir = new File(targetRootDir, "/lib/external/optional");
                if(!(targetDir.mkdirs()))
                {
                    throw new IOException("Could not create temp directory: " + targetDir.getAbsolutePath());
                }

                final URI afeUri = new URI("http://sourceforge.net/adobe/flexsdk/code/HEAD/tree/trunk/lib/afe.jar?format=raw");
                final File afeFile = new File(targetDir, "afe.jar");
                performSafeDownload(afeUri, afeFile);

                final URI aglj40Uri = new URI("http://sourceforge.net/adobe/flexsdk/code/HEAD/tree/trunk/lib/aglj40.jar?format=raw");
                final File aglj40File = new File(targetDir, "aglj40.jar");
                performSafeDownload(aglj40Uri, aglj40File);

                final URI rideauUri = new URI("http://sourceforge.net/adobe/flexsdk/code/HEAD/tree/trunk/lib/rideau.jar?format=raw");
                final File rideauFile = new File(targetDir, "rideau.jar");
                performSafeDownload(rideauUri, rideauFile);

                final URI flexFontkitUri = new URI("http://sourceforge.net/adobe/flexsdk/code/HEAD/tree/trunk/lib/flex-fontkit.jar?format=raw");
                final File flexFontkitFile = new File(targetDir, "flex-fontkit.jar");
                performSafeDownload(flexFontkitUri, flexFontkitFile);

                return targetRootDir;
            } else {
                final URL sourceUrl = new URL(getBinaryUrl(type, version, platformType));
                final File targetFile = File.createTempFile(type.toString() + "-" + version +
                                ((platformType != null) ? "-" + platformType : "") + "-",
                        sourceUrl.getFile().substring(sourceUrl.getFile().lastIndexOf(".")));
                performFastDownload(sourceUrl, targetFile);

                ////////////////////////////////////////////////////////////////////////////////
                // Do the extracting.
                ////////////////////////////////////////////////////////////////////////////////

                if (type.equals(SdkType.FLASH)) {
                    final File targetDirectory = new File(targetFile.getParent(),
                            targetFile.getName().substring(0, targetFile.getName().lastIndexOf(".") - 1));
                    final File libDestFile = new File(targetDirectory, "frameworks/libs/player/" + version + "/playerglobal.swc");
                    if (!libDestFile.getParentFile().exists()) {
                        libDestFile.getParentFile().mkdirs();
                    }
                    FileUtils.moveFile(targetFile, libDestFile);
                    return targetDirectory;
                } else {
                    System.out.println("Extracting archive to temp directory.");
                    File targetDirectory = new File(targetFile.getParent(),
                            targetFile.getName().substring(0, targetFile.getName().lastIndexOf(".") - 1));
                    if(type.equals(SdkType.SWFOBJECT)) {
                        unpack(targetFile, new File(targetDirectory, "templates"));
                    } else {
                        unpack(targetFile, targetDirectory);
                    }
                    System.out.println();
                    System.out.println("Finished extracting.");
                    System.out.println("===========================================================");

                    // In case of the swfobject, delete some stuff we don't want in there.
                    if(type.equals(SdkType.SWFOBJECT)) {
                        File delFile = new File(targetDirectory, "templates/swfobject/index_dynamic.html");
                        FileUtils.deleteQuietly(delFile);
                        delFile = new File(targetDirectory, "templates/swfobject/index.html");
                        FileUtils.deleteQuietly(delFile);
                        delFile = new File(targetDirectory, "templates/swfobject/test.swf");
                        FileUtils.deleteQuietly(delFile);
                        delFile = new File(targetDirectory, "templates/swfobject/src");
                        FileUtils.deleteDirectory(delFile);
                    }

                    return targetDirectory;
                }
            }
        } catch (MalformedURLException e) {
            throw new RetrieverException("Error downloading archive.", e);
        } catch (FileNotFoundException e) {
            throw new RetrieverException("Error downloading archive.", e);
        } catch (IOException e) {
            throw new RetrieverException("Error downloading archive.", e);
        } catch (URISyntaxException e) {
            throw new RetrieverException("Error downloading archive.", e);
        }
    }

    protected void performFastDownload(URL sourceUrl, File targetFile) throws IOException {
        final URLConnection connection = sourceUrl.openConnection();
        final ReadableByteChannel rbc = Channels.newChannel(connection.getInputStream());
        final FileOutputStream fos = new FileOutputStream(targetFile);

        ////////////////////////////////////////////////////////////////////////////////
        // Do the downloading.
        ////////////////////////////////////////////////////////////////////////////////

        final long expectedSize = connection.getContentLength();
        long transferedSize = 0L;

        System.out.println("===========================================================");
        System.out.println("Downloading " + sourceUrl.toString());
        if(expectedSize > 1014 * 1024) {
            System.out.println("Expected size: " + (expectedSize / 1024 / 1024) + "MB");
        } else {
            System.out.println("Expected size: " + (expectedSize / 1024 ) + "KB");
        }
        final ProgressBar progressBar = new ProgressBar(expectedSize);
        while (transferedSize < expectedSize) {
            transferedSize += fos.getChannel().transferFrom(rbc, transferedSize, 1 << 20);
            progressBar.updateProgress(transferedSize);
        }
        fos.close();
        System.out.println();
        System.out.println("Finished downloading.");
        System.out.println("===========================================================");
    }

    protected void performSafeDownload(URI sourceUri, File targetFile) throws IOException {
        HttpGet httpget = new HttpGet(sourceUri);
        HttpClient httpclient = new DefaultHttpClient();
        HttpResponse response = httpclient.execute(httpget);

        String reasonPhrase = response.getStatusLine().getReasonPhrase();
        int statusCode = response.getStatusLine().getStatusCode();
        System.out.println(String.format("statusCode: %d", statusCode));
        System.out.println(String.format("reasonPhrase: %s", reasonPhrase));

        HttpEntity entity = response.getEntity();
        InputStream content = entity.getContent();

        final ReadableByteChannel rbc = Channels.newChannel(content);
        final FileOutputStream fos = new FileOutputStream(targetFile);

        ////////////////////////////////////////////////////////////////////////////////
        // Do the downloading.
        ////////////////////////////////////////////////////////////////////////////////

        final long expectedSize = entity.getContentLength();
        System.out.println("===========================================================");
        System.out.println("Downloading " + sourceUri.toString());
        if(expectedSize < 0) {
            try {
                System.out.println("Unknown size.");
                IOUtils.copy(content, fos);
            } finally {
                // close http network connection
                content.close();
            }
        } else {
            long transferedSize = 0L;
            if (expectedSize > 1014 * 1024) {
                System.out.println("Expected size: " + (expectedSize / 1024 / 1024) + "MB");
            } else {
                System.out.println("Expected size: " + (expectedSize / 1024) + "KB");
            }
            final ProgressBar progressBar = new ProgressBar(expectedSize);
            while (transferedSize < expectedSize) {
                transferedSize += fos.getChannel().transferFrom(rbc, transferedSize, 1 << 20);
                progressBar.updateProgress(transferedSize);
            }
            fos.close();
            System.out.println();
        }
        System.out.println("Finished downloading.");
        System.out.println("===========================================================");
    }

    protected String getBinaryUrl(SdkType sdkType, String version, PlatformType platformType)
            throws RetrieverException {
        try {
            final DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            final DocumentBuilder builder = factory.newDocumentBuilder();
            final Document doc = builder.parse(getFlexInstallerConfigUrl());

            //Evaluate XPath against Document itself
            final String expression = getUrlXpath(sdkType, version, platformType);
            final XPath xPath = XPathFactory.newInstance().newXPath();
            final Element artifactElement = (Element) xPath.evaluate(
                    expression, doc.getDocumentElement(), XPathConstants.NODE);
            if(artifactElement == null) {
                throw new RetrieverException("Could not find " + sdkType.toString() + " SDK with version " + version);
            }

            final StringBuilder stringBuilder = new StringBuilder();
            if ((sdkType == SdkType.FLEX) || (sdkType == SdkType.SWFOBJECT)) {
                final String path = artifactElement.getAttribute("path");
                final String file = artifactElement.getAttribute("file");
                if (!path.startsWith("http://")) {
                    stringBuilder.append("http://archive.apache.org/dist/");
                }
                stringBuilder.append(path);
                if(!path.endsWith("/")) {
                    stringBuilder.append("/");
                }
                stringBuilder.append(file);
                if(sdkType == SdkType.FLEX) {
                    stringBuilder.append(".zip");
                }
            } else {
                final NodeList pathElements = artifactElement.getElementsByTagName("path");
                final NodeList fileElements = artifactElement.getElementsByTagName("file");
                if ((pathElements.getLength() != 1) && (fileElements.getLength() != 1)) {
                    throw new RetrieverException("Invalid document structure.");
                }
                final String path = pathElements.item(0).getTextContent();
                stringBuilder.append(path);
                if(!path.endsWith("/")) {
                    stringBuilder.append("/");
                }
                stringBuilder.append(fileElements.item(0).getTextContent());
            }

            return stringBuilder.toString();
        } catch (ParserConfigurationException e) {
            throw new RetrieverException("Error parsing 'sdk-installer-config-4.0.xml'", e);
        } catch (SAXException e) {
            throw new RetrieverException("Error parsing 'sdk-installer-config-4.0.xml'", e);
        } catch (XPathExpressionException e) {
            throw new RetrieverException("Error parsing 'sdk-installer-config-4.0.xml'", e);
        } catch (IOException e) {
            throw new RetrieverException("Error parsing 'sdk-installer-config-4.0.xml'", e);
        }
    }

    protected String getUrlXpath(SdkType sdkType, String version, PlatformType platformType)
            throws RetrieverException {
        final StringBuilder stringBuilder = new StringBuilder();
        switch (sdkType) {
            case FLEX:
                stringBuilder.append("//*[@id='").append(version).append("']");
                break;
            case AIR:
                stringBuilder.append("//*[@id='air.sdk.version.");
                if (platformType == null) {
                    throw new RetrieverException("You need to specify the platformType parameter for AIR SDKs.");
                }
                switch (platformType) {
                    case WINDOWS:
                        stringBuilder.append("windows");
                        break;
                    case MAC:
                        stringBuilder.append("mac");
                        break;
                    case LINUX:
                        stringBuilder.append("linux");
                        break;

                }
                stringBuilder.append(".").append(version).append("']");
                break;
            case FLASH:
                stringBuilder.append("//*[@id='flash.sdk.version.").append(version).append("']");
                break;
            case FONTKIT:
                stringBuilder.append("//fontswf");
                break;
            case SWFOBJECT:
                stringBuilder.append("//swfobject");
                break;
        }
        return stringBuilder.toString();
    }

    protected void confirmLicenseAcceptance(SdkType type) throws RetrieverException {
        final Properties questionProps = new Properties();
        try {
            questionProps.load(DownloadRetriever.class.getClassLoader().getResourceAsStream("message.properties"));
        } catch (IOException e) {
            throw new RetrieverException("Error reading message.properties file", e);
        }

        String property = "com.adobe.systemIdsForWhichTheTermsOfTheAdobeLicenseAgreementAreAccepted";

        // Implement the accepting the license by providing a system-id as system-property.
        String acceptedSystemIds = System.getProperty(property);
        if(acceptedSystemIds != null) {
            String systemId = SystemIdHelper.getSystemId();
            if(systemId != null) {
                for (String acceptedSystemId : acceptedSystemIds.split(",")) {
                    if (systemId.equals(acceptedSystemId)) {
                        System.out.println(questionProps.getProperty("ACCEPTED_USING_SYSTEM_ID"));
                        return;
                    }
                }
            }
        }

        final String question;
        if(type.equals(SdkType.FLASH)) {
            question = questionProps.getProperty("ASK_ADOBE_FLASH_PLAYER_GLOBAL_SWC");
        } else if(type.equals(SdkType.AIR)) {
            question = questionProps.getProperty("ASK_ADOBE_AIR_SDK");
        } else if(type.equals(SdkType.FONTKIT)) {
            question = questionProps.getProperty("ASK_ADOBE_FONTKIT");
        } else {
            throw new RetrieverException("Unknown SdkType");
        }
        final BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        try {
            while (true) {
                System.out.println(
                        MessageFormat.format(questionProps.getProperty("SYSTEM_ID"), SystemIdHelper.getSystemId()));
                System.out.println(question);
                System.out.println(MessageFormat.format(questionProps.getProperty("ACCEPT_USING_SYSTEM_ID"),
                        property, SystemIdHelper.getSystemId()));
                System.out.print(questionProps.getProperty("DO_YOU_ACCEPT_QUESTION") + " ");
                final String answer = reader.readLine();
                if ("YES".equalsIgnoreCase(answer) || "Y".equalsIgnoreCase(answer)) {
                    return;
                }
                if ("NO".equalsIgnoreCase(answer) || "N".equalsIgnoreCase(answer)) {
                    System.out.println("You have to accept the license agreement in order to proceed.");
                    throw new RetrieverException("You have to accept the license agreement in order to proceed.");
                }
            }
        } catch(IOException e) {
            throw new RetrieverException("Couldn't read from Stdin.");
        }
    }

    public Map<DefaultArtifactVersion, Collection<PlatformType>> getAvailableVersions(SdkType type) {
        Map<DefaultArtifactVersion, Collection<PlatformType>> result =
                new HashMap<DefaultArtifactVersion, Collection<PlatformType>>();
        try {
            final DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            final DocumentBuilder builder = factory.newDocumentBuilder();
            final Document doc = builder.parse(getFlexInstallerConfigUrl());
            final XPath xPath = XPathFactory.newInstance().newXPath();

            String expression;
            NodeList nodes = null;
            switch (type) {
                case FLEX:
                    expression = "/config/products/ApacheFlexSDK/versions/*";
                    nodes = (NodeList) xPath.evaluate(expression, doc.getDocumentElement(), XPathConstants.NODESET);
                    break;
                case FLASH:
                    expression = "/config/flashsdk/versions/*";
                    nodes = (NodeList) xPath.evaluate(expression, doc.getDocumentElement(), XPathConstants.NODESET);
                    break;
                case AIR:
                    expression = "/config/airsdk/*/versions/*";
                    nodes = (NodeList) xPath.evaluate(expression, doc.getDocumentElement(), XPathConstants.NODESET);
                    break;
            }

            if (nodes != null) {
                for(int i = 0; i < nodes.getLength(); i++) {
                    Element element = (Element) nodes.item(i);
                    DefaultArtifactVersion version = new DefaultArtifactVersion(element.getAttribute("version"));
                    if(type == SdkType.AIR) {
                        PlatformType platformType = PlatformType.valueOf(
                                element.getParentNode().getParentNode().getNodeName().toUpperCase());
                        if(!result.containsKey(version)) {
                            result.put(version, new ArrayList<PlatformType>());
                        }
                        result.get(version).add(platformType);
                    } else {
                        result.put(version, null);
                    }
                }
            }
        } catch (ParserConfigurationException e) {
            e.printStackTrace();
        } catch (SAXException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (XPathExpressionException e) {
            e.printStackTrace();
        }
        return result;
    }
}
