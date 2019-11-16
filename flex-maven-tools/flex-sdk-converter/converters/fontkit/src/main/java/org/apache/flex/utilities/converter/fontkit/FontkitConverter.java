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
package org.apache.flex.utilities.converter.fontkit;

import org.apache.flex.utilities.converter.BaseConverter;
import org.apache.flex.utilities.converter.Converter;
import org.apache.flex.utilities.converter.exceptions.ConverterException;
import org.apache.flex.utilities.converter.model.MavenArtifact;

import java.io.File;

public class FontkitConverter extends BaseConverter implements Converter {

    public FontkitConverter(File rootSourceDirectory, File rootTargetDirectory) throws ConverterException {
        super(rootSourceDirectory, rootTargetDirectory);
    }

    @Override
    protected void processDirectory() throws ConverterException {
        File fontkitRootDir = new File(rootSourceDirectory, "lib/external/optional");
        if(!fontkitRootDir.exists() || !fontkitRootDir.isDirectory()) {
            System.out.println("Skipping Fontkit generation.");
            return;
        }

        File afeJar = new File(fontkitRootDir, "afe.jar");
        File aglj40Jar = new File(fontkitRootDir, "aglj40.jar");
        File rideauJar = new File(fontkitRootDir, "rideau.jar");
        File flexFontkitJar = new File(fontkitRootDir, "flex-fontkit.jar");

        if(!afeJar.exists() || !aglj40Jar.exists() || !rideauJar.exists() || !flexFontkitJar.exists()) {
            throw new ConverterException("Fontkit directory '" + fontkitRootDir.getPath() + "' must contain the jar " +
                    "files afe.jar, aglj40.jar, rideau.jar and flex-fontkit.jar.");
        }

        final MavenArtifact fontkit = new MavenArtifact();
        fontkit.setGroupId("com.adobe");
        fontkit.setArtifactId("fontkit");
        fontkit.setVersion("1.0");
        fontkit.setPackaging("jar");
        fontkit.addDefaultBinaryArtifact(flexFontkitJar);

        final MavenArtifact afe = new MavenArtifact();
        afe.setGroupId("com.adobe.fontkit");
        afe.setArtifactId("afe");
        afe.setVersion("1.0");
        afe.setPackaging("jar");
        afe.addDefaultBinaryArtifact(afeJar);
        fontkit.addDependency(afe);

        final MavenArtifact aglj40 = new MavenArtifact();
        aglj40.setGroupId("com.adobe.fontkit");
        aglj40.setArtifactId("aglj40");
        aglj40.setVersion("1.0");
        aglj40.setPackaging("jar");
        aglj40.addDefaultBinaryArtifact(aglj40Jar);
        fontkit.addDependency(aglj40);

        final MavenArtifact rideau = new MavenArtifact();
        rideau.setGroupId("com.adobe.fontkit");
        rideau.setArtifactId("rideau");
        rideau.setVersion("1.0");
        rideau.setPackaging("jar");
        rideau.addDefaultBinaryArtifact(rideauJar);
        fontkit.addDependency(rideau);

        writeArtifact(afe);
        writeArtifact(aglj40);
        writeArtifact(rideau);
        writeArtifact(fontkit);
    }

}
