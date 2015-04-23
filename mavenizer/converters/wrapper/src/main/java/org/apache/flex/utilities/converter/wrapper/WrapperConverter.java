package org.apache.flex.utilities.converter.wrapper;

import org.apache.flex.utilities.converter.BaseConverter;
import org.apache.flex.utilities.converter.Converter;
import org.apache.flex.utilities.converter.exceptions.ConverterException;
import org.apache.flex.utilities.converter.model.MavenArtifact;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.File;
import java.io.IOException;

/**
 * Created by christoferdutz on 06.04.15.
 */
public class WrapperConverter extends BaseConverter implements Converter {

    public WrapperConverter(File rootSourceDirectory, File rootTargetDirectory) throws ConverterException {
        super(rootSourceDirectory, rootTargetDirectory);
    }

    @Override
    protected void processDirectory() throws ConverterException {
        File wrapperRootDir = new File(rootSourceDirectory, "templates/swfobject");
        if(!wrapperRootDir.exists() || !wrapperRootDir.isDirectory()) {
            System.out.println("Skipping Wrapper generation.");
            return;
        }

        try {
            final File wrapperJar = File.createTempFile("SWFObjectWrapper-2.2", ".jar");
            generateZip(wrapperRootDir.listFiles(), wrapperJar);

            final MavenArtifact swfobjectWrapper = new MavenArtifact();
            swfobjectWrapper.setGroupId("org.apache.flex.wrapper");
            swfobjectWrapper.setArtifactId("swfobject");
            swfobjectWrapper.setVersion(getFlexVersion(rootSourceDirectory));
            swfobjectWrapper.setPackaging("jar");
            swfobjectWrapper.addDefaultBinaryArtifact(wrapperJar);

            writeArtifact(swfobjectWrapper);
        } catch (IOException e) {
            throw new ConverterException("Error creating wrapper jar.", e);
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
            throw new RuntimeException(pce);
        } catch (SAXException se) {
            throw new RuntimeException(se);
        } catch (IOException ioe) {
            throw new RuntimeException(ioe);
        }
    }

}
