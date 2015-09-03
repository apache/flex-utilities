package org.apache.flex.utilities.converter.wrapper;

import org.apache.flex.utilities.converter.BaseConverter;
import org.apache.flex.utilities.converter.Converter;
import org.apache.flex.utilities.converter.exceptions.ConverterException;
import org.apache.flex.utilities.converter.model.MavenArtifact;

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
            // Rename the index.template.html to index.html
            File indexHtml = new File(wrapperRootDir, "index.template.html");
            if(!indexHtml.renameTo(new File(wrapperRootDir, "index.html"))) {
                System.out.println("Could not rename index.template.html to index.html.");
            }

            final File wrapperWar = File.createTempFile("SWFObjectWrapper-2.2", ".war");
            generateZip(wrapperRootDir.listFiles(), wrapperWar);

            final MavenArtifact swfobjectWrapper = new MavenArtifact();
            swfobjectWrapper.setGroupId("org.apache.flex.wrapper");
            swfobjectWrapper.setArtifactId("swfobject");
            swfobjectWrapper.setVersion(getFlexVersion(rootSourceDirectory));
            swfobjectWrapper.setPackaging("war");
            swfobjectWrapper.addDefaultBinaryArtifact(wrapperWar);

            writeArtifact(swfobjectWrapper);
        } catch (IOException e) {
            throw new ConverterException("Error creating wrapper war.", e);
        }
    }

}
