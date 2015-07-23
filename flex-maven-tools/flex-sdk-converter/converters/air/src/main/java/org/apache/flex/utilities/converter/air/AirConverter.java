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
package org.apache.flex.utilities.converter.air;

import org.apache.flex.utilities.converter.BaseConverter;
import org.apache.flex.utilities.converter.Converter;
import org.apache.flex.utilities.converter.exceptions.ConverterException;
import org.apache.flex.utilities.converter.model.MavenArtifact;

import java.io.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.zip.ZipOutputStream;

/**
 * Created by cdutz on 22.04.2014.
 */
public class AirConverter extends BaseConverter implements Converter {

    protected String airSdkVersion;

    /**
     * @param rootSourceDirectory Path to the root of the original AIR SDK.
     * @param rootTargetDirectory Path to the root of the directory where the Maven artifacts should be generated to.
     * @throws ConverterException
     */
    public AirConverter(File rootSourceDirectory, File rootTargetDirectory) throws ConverterException {
        super(rootSourceDirectory, rootTargetDirectory);

        // Get the version of the current air sdk.
        this.airSdkVersion = getAirVersion(rootSourceDirectory);
    }

    /**
     * Entry point for generating the Maven artifacts for an AIR SDK.
     *
     * @throws ConverterException
     */
    @Override
    protected void processDirectory() throws ConverterException {
        if ((airSdkVersion == null) || !rootSourceDirectory.exists() || !rootSourceDirectory.isDirectory()) {
            System.out.println("Skipping AIR SDK generation.");
            return;
        }

        generateCompilerArtifacts();
        generateRuntimeArtifacts();
        generateFrameworkArtifacts();
    }

    /**
     * This method generates those artifacts that resemble the compiler part of the AIR SDK.
     *
     * @throws ConverterException
     */
    protected void generateCompilerArtifacts() throws ConverterException {
        // Create the root artifact.
        final MavenArtifact compiler = new MavenArtifact();
        compiler.setGroupId("com.adobe.air");
        compiler.setArtifactId("compiler");
        compiler.setVersion(airSdkVersion);
        compiler.setPackaging("pom");

        // Create a list of all libs that should belong to the AIR SDK compiler.
        final File directory = new File(rootSourceDirectory, "lib");
        if (!directory.exists() || !directory.isDirectory()) {
            throw new ConverterException("Compiler directory does not exist.");
        }
        final List<File> files = new ArrayList<File>();
        files.addAll(Arrays.asList(directory.listFiles(new AirCompilerFilter())));

        // Add the smali.jar and baksmali.jar from the android/lib directory
        // as this is needed for Android packaging.
        File androidDir = new File(directory, "android");
        if (androidDir.exists() && androidDir.isDirectory()) {
            File androidLibDir = new File(androidDir, "lib");
            if (androidLibDir.exists() && androidLibDir.isDirectory()) {
                files.addAll(Arrays.asList(androidLibDir.listFiles(new AirCompilerFilter())));
            }
        }

        // Generate artifacts for every jar in the input directories.
        for (final File sourceFile : files) {
            final MavenArtifact artifact = resolveArtifact(sourceFile, "com.adobe.air.compiler", airSdkVersion);
            compiler.addDependency(artifact);
        }

        // Generate the android package (android directory)
        if (androidDir.exists() && androidDir.isDirectory()) {
            final File androidZip = new File(rootTargetDirectory,
                    "com.adobe.air.compiler.adt.".replace(".", File.separator) + airSdkVersion +
                            File.separator + "adt-" + airSdkVersion + "-android.zip");
            try {
                // Add all the content to a zip-file.
                final ZipOutputStream zipOutputStream = new ZipOutputStream(new FileOutputStream(androidZip));
                // Package all the compiler parts.
                File[] zipfiles = androidDir.listFiles();
                if(zipfiles != null) {
                    for (final File file : zipfiles) {
                        addFileToZip(zipOutputStream, file, rootSourceDirectory);
                    }
                }
                // Package all the runtime parts.
                File runtimesDir = new File(rootSourceDirectory, "runtimes/air/android");
                if(runtimesDir.exists() && runtimesDir.isDirectory()) {
                    zipfiles = runtimesDir.listFiles();
                    if (zipfiles != null) {
                        for (final File file : zipfiles) {
                            addFileToZip(zipOutputStream, file, rootSourceDirectory);
                        }
                    }
                }
                File binDir = new File(rootSourceDirectory, "bin");
                if(binDir.exists() && binDir.isDirectory()) {
                    zipfiles = binDir.listFiles(new FilenameFilter() {
                        public boolean accept(File dir, String name) {
                            return name.equals("adt") || name.equals("adt.bat") ||
                                    name.equals("adl") || name.equals("adl.exe");
                        }
                    });
                    if (zipfiles != null) {
                        for (final File file : zipfiles) {
                            addFileToZip(zipOutputStream, file, rootSourceDirectory);
                        }
                    }
                }
                zipOutputStream.close();
            } catch(IOException e) {
                throw new ConverterException("Error generating android package zip.", e);
            }
        }

        // Generate the ios package (aot directory)
        File iosDir = new File(directory, "aot");
        if (iosDir.exists() && iosDir.isDirectory()) {
            final File iosZip = new File(rootTargetDirectory,
                    "com.adobe.air.compiler.adt.".replace(".", File.separator) + airSdkVersion +
                            File.separator + "adt-" + airSdkVersion + "-ios.zip");
            try {
                // Add all the content to a zip-file.
                final ZipOutputStream zipOutputStream = new ZipOutputStream(new FileOutputStream(iosZip));
                // Package all the compiler parts.
                File[] zipfiles = iosDir.listFiles();
                if(zipfiles != null) {
                    for (final File file : zipfiles) {
                        addFileToZip(zipOutputStream, file, rootSourceDirectory);
                    }
                }
                File binDir = new File(rootSourceDirectory, "bin");
                if(binDir.exists() && binDir.isDirectory()) {
                    zipfiles = binDir.listFiles(new FilenameFilter() {
                        public boolean accept(File dir, String name) {
                            return name.equals("adt") || name.equals("adt.bat") ||
                                    name.equals("adl") || name.equals("adl.exe");
                        }
                    });
                    if (zipfiles != null) {
                        for (final File file : zipfiles) {
                            addFileToZip(zipOutputStream, file, rootSourceDirectory);
                        }
                    }
                }
                zipOutputStream.close();
            } catch(IOException e) {
                throw new ConverterException("Error generating android package zip.", e);
            }
        }

        // Generate the exe, dmg, deb, rpm packages (nai directory)
        File desktopDir = new File(directory, "nai");
        if (desktopDir.exists() && desktopDir.isDirectory()) {
            final File desktopZip = new File(rootTargetDirectory,
                    "com.adobe.air.compiler.adt.".replace(".", File.separator) + airSdkVersion +
                            File.separator + "adt-" + airSdkVersion + "-desktop.zip");
            try {
                // Add all the content to a zip-file.
                final ZipOutputStream zipOutputStream = new ZipOutputStream(new FileOutputStream(desktopZip));
                // Package all the compiler parts.
                File[] zipfiles = desktopDir.listFiles();
                if(zipfiles != null) {
                    for (final File file : zipfiles) {
                        addFileToZip(zipOutputStream, file, rootSourceDirectory);
                    }
                }
                // Package all the runtime parts.
                File runtimesDir = new File(rootSourceDirectory, "runtimes/air/win");
                if(runtimesDir.exists() && runtimesDir.isDirectory()) {
                    zipfiles = runtimesDir.listFiles();
                    if (zipfiles != null) {
                        for (final File file : zipfiles) {
                            addFileToZip(zipOutputStream, file, rootSourceDirectory);
                        }
                    }
                }
                runtimesDir = new File(rootSourceDirectory, "runtimes/air/mac/Adobe AIR.framework/Versions/1.0");
                if(runtimesDir.exists() && runtimesDir.isDirectory()) {
                    zipfiles = runtimesDir.listFiles();
                    if (zipfiles != null) {
                        for (final File file : zipfiles) {
                            addFileToZip(zipOutputStream, file, rootSourceDirectory);
                        }
                    }
                }
                runtimesDir = new File(rootSourceDirectory, "runtimes/air-captive/win");
                if(runtimesDir.exists() && runtimesDir.isDirectory()) {
                    zipfiles = runtimesDir.listFiles();
                    if (zipfiles != null) {
                        for (final File file : zipfiles) {
                            addFileToZip(zipOutputStream, file, rootSourceDirectory);
                        }
                    }
                }
                runtimesDir = new File(rootSourceDirectory, "runtimes/air-captive/mac/Adobe AIR.framework/Versions/1.0");
                if(runtimesDir.exists() && runtimesDir.isDirectory()) {
                    zipfiles = runtimesDir.listFiles();
                    if (zipfiles != null) {
                        for (final File file : zipfiles) {
                            addFileToZip(zipOutputStream, file, rootSourceDirectory);
                        }
                    }
                }
                File binDir = new File(rootSourceDirectory, "bin");
                if(binDir.exists() && binDir.isDirectory()) {
                    zipfiles = binDir.listFiles(new FilenameFilter() {
                        public boolean accept(File dir, String name) {
                            return name.equals("adt") || name.equals("adt.bat") ||
                                    name.equals("adl") || name.equals("adl.exe");
                        }
                    });
                    if (zipfiles != null) {
                        for (final File file : zipfiles) {
                            addFileToZip(zipOutputStream, file, rootSourceDirectory);
                        }
                    }
                }
                zipOutputStream.close();
            } catch(IOException e) {
                throw new ConverterException("Error generating android package zip.", e);
            }
        }

        // Write this artifact to file.
        writeArtifact(compiler);
    }

    /**
     * This method generates those artifacts that resemble the runtime part of the AIR SDK.
     *
     * @throws ConverterException
     */
    protected void generateRuntimeArtifacts() throws ConverterException {
        // Create the root artifact.
        final MavenArtifact runtime = new MavenArtifact();
        runtime.setGroupId("com.adobe.air");
        runtime.setArtifactId("runtime");
        runtime.setVersion(airSdkVersion);
        runtime.setPackaging("pom");

        // Create a list of all libs that should belong to the AIR SDK runtime.
        final File directory = new File(rootSourceDirectory, "bin");
        if (!directory.exists() || !directory.isDirectory()) {
            throw new ConverterException("Runtime directory does not exist.");
        }
        final List<File> files = new ArrayList<File>();
        files.addAll(Arrays.asList(directory.listFiles(new AirRuntimeFilter())));

        // Generate artifacts for every jar in the input directories (Actually this is only one file).
        for (final File sourceFile : files) {
            final MavenArtifact artifact = resolveArtifact(sourceFile, "com.adobe.air.runtime", airSdkVersion);
            runtime.addDependency(artifact);
        }

        // Zip up the AIR runtime directory.
        final MavenArtifact airRuntimeArtifact = generateAirRuntimeArtifact(rootSourceDirectory);
        if (airRuntimeArtifact != null) {
            runtime.addDependency(airRuntimeArtifact);
        }

        // Write this artifact to file.
        writeArtifact(runtime);
    }

    /**
     * This method generates those artifacts that resemble the framework part of the AIR SDK.
     *
     * @throws ConverterException
     */
    protected void generateFrameworkArtifacts() throws ConverterException {
        // Create the root artifact.
        final MavenArtifact framework = new MavenArtifact();
        framework.setGroupId("com.adobe.air");
        framework.setArtifactId("framework");
        framework.setVersion(airSdkVersion);
        framework.setPackaging("pom");

        // Create a list of all libs that should belong to the AIR SDK framework.
        final File directory =
                new File(rootSourceDirectory, "frameworks" + File.separator + "libs" + File.separator + "air");
        if (!directory.exists() || !directory.isDirectory()) {
            throw new ConverterException("Framework directory does not exist.");
        }
        final List<File> files = new ArrayList<File>();
        files.addAll(Arrays.asList(directory.listFiles(new AirFrameworkFilter())));

        // Generate artifacts for every jar in the input directories.
        for (final File sourceFile : files) {
            final MavenArtifact artifact = resolveArtifact(sourceFile, "com.adobe.air.framework", airSdkVersion);
            framework.addDependency(artifact);
        }

        // Write this artifact to file.
        writeArtifact(framework);
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //   Utility methods
    //
    ///////////////////////////////////////////////////////////////////////////////////////////////////

    protected MavenArtifact generateAirRuntimeArtifact(File rootDirectory) throws ConverterException {
        final MavenArtifact airRuntimeArtifact = new MavenArtifact();
        airRuntimeArtifact.setGroupId("com.adobe.air.runtime");
        airRuntimeArtifact.setArtifactId("air-runtime");
        airRuntimeArtifact.setVersion(airSdkVersion);
        airRuntimeArtifact.setPackaging("zip");

        final File runtimeRoot = new File(rootDirectory, "runtimes.air".replace(".", File.separator));
        final File[] platforms = runtimeRoot.listFiles();
        if (platforms != null) {
            for (final File platform : platforms) {
                if (!platform.isDirectory()) {
                    continue;
                }
                final String platformName = platform.getName();
                try {
                    final File zip = File.createTempFile("AirRuntime-" + platformName + "-" + airSdkVersion, "zip");
                    generateZip(platform.listFiles(), zip);
                    airRuntimeArtifact.addBinaryArtifact(platformName, zip);
                } catch (IOException e) {
                    throw new ConverterException("Error creating runtime zip.", e);
                }
            }
        } else {
            return null;
        }

        writeArtifact(airRuntimeArtifact);
        return airRuntimeArtifact;
    }

    /**
     * Get the version of an AIR SDK from the content of the SDK directory.
     *
     * @return version string for the current AIR SDK
     */
    protected String getAirVersion(File rootDirectory) throws ConverterException {
        // All AIR SDKs contain a text file "AIR SDK Readme.txt" which contains a
        // Version string in the first line. Newer SDKs contain an additional "airsdk.xml"
        // which would be easier to parse, but as all SDKs contain the text-file, we'll
        // stick to that for now.

        final File sdkDescriptor = new File(rootDirectory, "AIR SDK Readme.txt");

        // If the descriptor is not present, return null as this FDK directory doesn't
        // seem to contain a AIR SDK.
        if (!sdkDescriptor.exists() || !sdkDescriptor.isFile()) {
            return null;
        }

        DataInputStream in = null;
        try {
            final FileInputStream descriptorInputStream = new FileInputStream(sdkDescriptor);
            in = new DataInputStream(descriptorInputStream);
            final BufferedReader br = new BufferedReader(new InputStreamReader(in));
            final String strLine = br.readLine();
            return strLine.substring("Adobe AIR ".length(), strLine.indexOf(" ", "Adobe AIR ".length()));
        } catch (Exception e) {
            throw new ConverterException("Error getting AIR version.", e);
        } finally {
            if (in != null) {
                try {
                    in.close();
                } catch (IOException ioe) {
                    // Ignore.
                }
            }
        }
    }

    public static class AirCompilerFilter implements FilenameFilter {
        public boolean accept(File dir, String name) {
            return name.equals("adt.jar") || name.equals("smali.jar") || name.equals("baksmali.jar");
        }
    }

    public static class AirRuntimeFilter implements FilenameFilter {
        public boolean accept(File dir, String name) {
            return name.equalsIgnoreCase("adl.exe");
        }
    }

    public static class AirFrameworkFilter implements FilenameFilter {
        public boolean accept(File dir, String name) {
            return name.equals("aircore.swc") || name.equals("airglobal.swc") ||
                    name.equals("applicationupdater.swc") || name.equals("applicationupdater_ui.swc") ||
                    name.equals("servicemonitor.swc");
        }
    }

    public static void main(String[] args) throws Exception {
        AirConverter converter = new AirConverter(new File(args[0]), new File(args[1]));
        converter.convert();
    }

}
