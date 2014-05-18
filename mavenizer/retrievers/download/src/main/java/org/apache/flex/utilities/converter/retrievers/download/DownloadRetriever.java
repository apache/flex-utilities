package org.apache.flex.utilities.converter.retrievers.download;

import org.apache.flex.utilities.converter.retrievers.BaseRetriever;
import org.apache.flex.utilities.converter.retrievers.exceptions.RetrieverException;
import org.apache.flex.utilities.converter.retrievers.types.PlatformType;
import org.apache.flex.utilities.converter.retrievers.types.SDKType;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import java.io.IOException;

/**
 * Created by cdutz on 18.05.2014.
 */
public class DownloadRetriever extends BaseRetriever {

    public static final String FLEX_INSTALLER_CONFIG_URL =
            "http://flex.apache.org/installer/sdk-installer-config-4.0.xml";

    @Override
    public void retrieve(PlatformType platformType, SDKType type, String version) throws RetrieverException {
        final String url = getBinaryUrl(platformType, type, version);
        System.out.println(url);
    }

    protected String getBinaryUrl(PlatformType platformType, SDKType sdkType, String version) throws RetrieverException {
        try {
            final DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            final DocumentBuilder builder = factory.newDocumentBuilder();
            final Document doc = builder.parse(FLEX_INSTALLER_CONFIG_URL);

            //Evaluate XPath against Document itself
            final String expression = getUrlXpath(platformType, sdkType, version);
            final XPath xPath = XPathFactory.newInstance().newXPath();
            final Element artifactElement = (Element) xPath.evaluate(
                    expression, doc.getDocumentElement(), XPathConstants.NODE);
            final StringBuilder stringBuilder = new StringBuilder();
            if(sdkType == SDKType.FLEX) {
                final String path = artifactElement.getAttribute("path");
                final String file = artifactElement.getAttribute("file");
                if(!path.startsWith("http://")) {
                    stringBuilder.append("http://archive.apache.org/dist/");
                }
                stringBuilder.append(path).append(file);
            } else {
                final NodeList pathElements = artifactElement.getElementsByTagName("path");
                final NodeList fileElements = artifactElement.getElementsByTagName("file");
                if((pathElements.getLength() != 1) && (fileElements.getLength() != 1)) {
                    throw new RetrieverException("Invalid document structure.");
                }
                stringBuilder.append(pathElements.item(0).getTextContent());
                stringBuilder.append(fileElements.item(0).getTextContent());
            }

            return stringBuilder.toString();
        } catch(ParserConfigurationException e) {
            throw new RetrieverException("Error parsing 'sdk-installer-config-4.0.xml'", e);
        } catch (SAXException e) {
            throw new RetrieverException("Error parsing 'sdk-installer-config-4.0.xml'", e);
        } catch (XPathExpressionException e) {
            throw new RetrieverException("Error parsing 'sdk-installer-config-4.0.xml'", e);
        } catch (IOException e) {
            throw new RetrieverException("Error parsing 'sdk-installer-config-4.0.xml'", e);
        }
    }

    protected String getUrlXpath(PlatformType platformType, SDKType sdkType, String version) {
        final StringBuilder stringBuilder = new StringBuilder();
        switch (sdkType) {
            case FLEX:
                stringBuilder.append("//*[@id='").append(version).append("']");
                break;
            case AIR:
                stringBuilder.append("//*[@id='air.sdk.version.");
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
        }
        return stringBuilder.toString();
    }

    public static void main(String[] args) throws Exception {
        final DownloadRetriever retriever = new DownloadRetriever();

        retriever.retrieve(PlatformType.WINDOWS, SDKType.FLEX, "4.9.1");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.FLEX, "4.10.0");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.FLEX, "4.11.0");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.FLEX, "4.12.0");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.FLEX, "4.12.1");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.FLEX, "Nightly");

        retriever.retrieve(PlatformType.WINDOWS, SDKType.AIR, "2.6");
        retriever.retrieve(PlatformType.MAC, SDKType.AIR, "2.6");
        retriever.retrieve(PlatformType.LINUX, SDKType.AIR, "2.6");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.AIR, "2.7");
        retriever.retrieve(PlatformType.MAC, SDKType.AIR, "2.7");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.AIR, "3.0");
        retriever.retrieve(PlatformType.MAC, SDKType.AIR, "3.0");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.AIR, "3.1");
        retriever.retrieve(PlatformType.MAC, SDKType.AIR, "3.1");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.AIR, "3.2");
        retriever.retrieve(PlatformType.MAC, SDKType.AIR, "3.2");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.AIR, "3.3");
        retriever.retrieve(PlatformType.MAC, SDKType.AIR, "3.3");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.AIR, "3.4");
        retriever.retrieve(PlatformType.MAC, SDKType.AIR, "3.4");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.AIR, "3.5");
        retriever.retrieve(PlatformType.MAC, SDKType.AIR, "3.5");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.AIR, "3.6");
        retriever.retrieve(PlatformType.MAC, SDKType.AIR, "3.6");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.AIR, "3.7");
        retriever.retrieve(PlatformType.MAC, SDKType.AIR, "3.7");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.AIR, "3.8");
        retriever.retrieve(PlatformType.MAC, SDKType.AIR, "3.8");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.AIR, "3.9");
        retriever.retrieve(PlatformType.MAC, SDKType.AIR, "3.9");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.AIR, "4.0");
        retriever.retrieve(PlatformType.MAC, SDKType.AIR, "4.0");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.AIR, "13.0");
        retriever.retrieve(PlatformType.MAC, SDKType.AIR, "13.0");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.AIR, "14.0");
        retriever.retrieve(PlatformType.MAC, SDKType.AIR, "14.0");

        retriever.retrieve(PlatformType.WINDOWS, SDKType.FLASH, "10.2");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.FLASH, "10.3");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.FLASH, "11.0");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.FLASH, "11.1");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.FLASH, "11.2");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.FLASH, "11.3");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.FLASH, "11.4");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.FLASH, "11.5");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.FLASH, "11.6");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.FLASH, "11.7");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.FLASH, "11.8");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.FLASH, "11.9");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.FLASH, "12.0");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.FLASH, "13.0");
        retriever.retrieve(PlatformType.WINDOWS, SDKType.FLASH, "14.0");

    }

}
