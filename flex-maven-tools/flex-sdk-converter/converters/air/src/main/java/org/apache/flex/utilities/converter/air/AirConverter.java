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
import java.util.*;
import java.util.zip.ZipOutputStream;

/**
 * Converter to convert the Air part of Flex SDKs or the Air SDKs into
 * Maven artifacts.
 */
public class AirConverter extends BaseConverter implements Converter {

    private String airSdkVersion;

    /**
     * @param rootSourceDirectory Path to the root of the original AIR SDK.
     * @param rootTargetDirectory Path to the root of the directory where the Maven artifacts should be generated to.
     * @throws ConverterException something went wrong
     */
    public AirConverter(File rootSourceDirectory, File rootTargetDirectory) throws ConverterException {
        super(rootSourceDirectory, rootTargetDirectory);

        // Get the version of the current air sdk.
        this.airSdkVersion = getAirVersion(rootSourceDirectory);
    }

    /**
     * Entry point for generating the Maven artifacts for an AIR SDK.
     *
     * @throws ConverterException something went wrong
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
        generateTemplatesArtifact();
        generateMiscArtifact();
    }

    /**
     * This method generates those artifacts that resemble the compiler part of the AIR SDK.
     *
     * @throws ConverterException something went wrong
     */
    private void generateCompilerArtifacts() throws ConverterException {
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
        File[] compilerFiles = directory.listFiles(new AirCompilerFilter());
        if(compilerFiles != null) {
            files.addAll(Arrays.asList(compilerFiles));
        }

        // Generate artifacts for every jar in the input directories.
        for (final File sourceFile : files) {
            final MavenArtifact artifact = resolveArtifact(sourceFile, "com.adobe.air.compiler", airSdkVersion);
            compiler.addDependency(artifact);
        }

        // Generate the android package (android directory)
        File androidDir = new File(directory, "android");
        if (androidDir.exists() && androidDir.isDirectory()) {
            final File androidZip = new File(rootTargetDirectory,
                    "com.adobe.air.compiler.adt.".replace(".", File.separator) + airSdkVersion +
                            File.separator + "adt-" + airSdkVersion + "-android.zip");
            generateCompilerPlatformArtifact(androidDir, androidZip);
        }

        // Generate the ios package (aot directory)
        File iosDir = new File(directory, "aot");
        if (iosDir.exists() && iosDir.isDirectory()) {
            final File iosZip = new File(rootTargetDirectory,
                    "com.adobe.air.compiler.adt.".replace(".", File.separator) + airSdkVersion +
                            File.separator + "adt-" + airSdkVersion + "-ios.zip");
            generateCompilerPlatformArtifact(iosDir, iosZip);
        }

        // Generate the exe, dmg, deb, rpm packages (nai directory)
        File desktopDir = new File(directory, "nai");
        if (desktopDir.exists() && desktopDir.isDirectory()) {
            final File desktopZip = new File(rootTargetDirectory,
                    "com.adobe.air.compiler.adt.".replace(".", File.separator) + airSdkVersion +
                            File.separator + "adt-" + airSdkVersion + "-desktop.zip");
            generateCompilerPlatformArtifact(desktopDir, desktopZip);
        }

        // Generate the windows packages (win directory)
        File windowsDir = new File(directory, "win");
        if (windowsDir.exists() && windowsDir.isDirectory()) {
            final File windowsZip = new File(rootTargetDirectory,
                    "com.adobe.air.compiler.adt.".replace(".", File.separator) + airSdkVersion +
                            File.separator + "adt-" + airSdkVersion + "-windows.zip");
            generateCompilerPlatformArtifact(windowsDir, windowsZip);
        }

        // Write this artifact to file.
        writeArtifact(compiler);
    }

    /**
     * This method generates those artifacts that resemble the runtime part of the AIR SDK.
     *
     * @throws ConverterException something went wrong
     */
    private void generateRuntimeArtifacts() throws ConverterException {
        // Create the root artifact.
        final MavenArtifact runtime = new MavenArtifact();
        runtime.setGroupId("com.adobe.air");
        runtime.setArtifactId("runtime");
        runtime.setVersion(airSdkVersion);
        runtime.setPackaging("pom");

        // Generate artifacts from the adl/adl.exe files
        MavenArtifact adl = new MavenArtifact();
        adl.setGroupId("com.adobe.air.runtime");
        adl.setArtifactId("adl");
        adl.setVersion(airSdkVersion);
        // We'll use pom packaging as we don't have a default artifact to download.
        adl.setPackaging("pom");
        final File directory = new File(rootSourceDirectory, "bin");
        if (!directory.exists() || !directory.isDirectory()) {
            throw new ConverterException("Runtime directory does not exist.");
        }
        File[] adlExecutables = directory.listFiles(new AirRuntimeFilter());
        if(adlExecutables != null) {
            for(File adlExecutable : adlExecutables) {
                if(adlExecutable.getName().endsWith(".exe")) {
                    adl.addBinaryArtifact("win", adlExecutable);
                }
                // TODO: Check to see how it was with linux up till AIR 2.6
                else {
                    adl.addBinaryArtifact("mac", adlExecutable);
                }
            }
        }
        runtime.addDependency(adl);
        writeArtifact(adl);

        // Add up the AIR runtimes.
        final List<MavenArtifact> airRuntimeArtifacts = generateAirRuntimeArtifacts(rootSourceDirectory);
        if (airRuntimeArtifacts != null) {
            for (MavenArtifact airRuntimeArtifact : airRuntimeArtifacts) {
                runtime.addDependency(airRuntimeArtifact);
            }
        }

        // Write this artifact to file.
        writeArtifact(runtime);
    }

    /**
     * This method generates those artifacts that resemble the framework part of the AIR SDK.
     *
     * @throws ConverterException something went wrong
     */
    private void generateFrameworkArtifacts() throws ConverterException {
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
        File[] frameworkFiles = directory.listFiles(new AirFrameworkFilter());
        if(frameworkFiles != null) {
            files.addAll(Arrays.asList(frameworkFiles));
        }

        // Generate artifacts for every jar in the input directories.
        for (final File sourceFile : files) {
            final MavenArtifact artifact = resolveArtifact(sourceFile, "com.adobe.air.framework", airSdkVersion);
            framework.addDependency(artifact);
        }

        // Write this artifact to file.
        writeArtifact(framework);
    }

    private void generateTemplatesArtifact() throws ConverterException {
        // Create the root artifact.
        final MavenArtifact templates = new MavenArtifact();
        templates.setGroupId("com.adobe.air");
        templates.setArtifactId("templates");
        templates.setVersion(airSdkVersion);
        templates.setPackaging("jar");

        final File templatesDir = new File(rootSourceDirectory, "templates");
        final File[] directories = templatesDir.listFiles(new FileFilter() {
            public boolean accept(File pathname) {
                return pathname.isDirectory() && ("air".equals(pathname.getName()) ||
                        "extensions".equals(pathname.getName()) || "sdk".equals(pathname.getName()));
            }
        });

        try {
            final File jar = File.createTempFile("air-templates-" + airSdkVersion, "jar");
            generateZip(directories, jar);
            templates.addDefaultBinaryArtifact(jar);
        } catch (IOException e) {
            throw new ConverterException("Error creating runtime zip.", e);
        }

        // Write this artifact to file.
        writeArtifact(templates);
    }

    /**
     * The misc artifact contains all the other stuff that the installer used to copy
     * but that don't have an immediate effect on the maven build.
     * @throws ConverterException something went wrong
     */
    private void generateMiscArtifact() throws ConverterException {
        // Create the root artifact.
        final MavenArtifact misc = new MavenArtifact();
        misc.setGroupId("com.adobe.air");
        misc.setArtifactId("misc");
        misc.setVersion(airSdkVersion);
        misc.setPackaging("zip");

        Collection<File> content = listAllFiles(rootSourceDirectory, new AirMiscFilter(rootSourceDirectory));
        try {
            final File zip = File.createTempFile("air-misc-" + airSdkVersion, "jar");
            generateZip(rootSourceDirectory, content.toArray(new File[0]), zip);
            misc.addDefaultBinaryArtifact(zip);
        } catch (IOException e) {
            throw new ConverterException("Error creating misc zip.", e);
        }

        writeArtifact(misc);
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //   Utility methods
    //
    ///////////////////////////////////////////////////////////////////////////////////////////////////

    private void generateCompilerPlatformArtifact(File inputDir, File outputFile) throws ConverterException {
        try {
            // Add all the content to a zip-file.
            final ZipOutputStream zipOutputStream = new ZipOutputStream(new FileOutputStream(outputFile));
            // Package all the compiler parts.
            File[] zipfiles = inputDir.listFiles();
            if(zipfiles != null) {
                for (final File file : zipfiles) {
                    addFileToZip(zipOutputStream, file, rootSourceDirectory);
                }
            }
            zipOutputStream.close();
        } catch(IOException e) {
            throw new ConverterException("Error generating android package zip.", e);
        }
    }

    private List<MavenArtifact> generateAirRuntimeArtifacts(File rootDirectory) throws ConverterException {
        List<MavenArtifact> airRuntimeArtifacts = new LinkedList<MavenArtifact>();

        final File runtimeRoot = new File(rootDirectory, "runtimes");
        final File[] runtimes = runtimeRoot.listFiles();
        if(runtimes != null) {
            for(File runtime : runtimes) {
                final MavenArtifact airRuntimeArtifact = new MavenArtifact();
                airRuntimeArtifact.setGroupId("com.adobe.air.runtime");
                airRuntimeArtifact.setArtifactId(runtime.getName());
                airRuntimeArtifact.setVersion(airSdkVersion);
                // We'll use pom packaging as we don't have a default artifact to download.
                airRuntimeArtifact.setPackaging("pom");

                final File[] platforms = runtime.listFiles();
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
                airRuntimeArtifacts.add(airRuntimeArtifact);
            }
        }

        return airRuntimeArtifacts;
    }

    /**
     * Get the version of an AIR SDK from the content of the SDK directory.
     *
     * @return version string for the current AIR SDK
     * @throws ConverterException  something went wrong
     */
    private String getAirVersion(File rootDirectory) throws ConverterException {
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

    public static class AirFrameworkFilter implements FilenameFilter {
        public boolean accept(File dir, String name) {
            return name.equals("aircore.swc") || name.equals("airglobal.swc") ||
                    name.equals("applicationupdater.swc") || name.equals("applicationupdater_ui.swc") ||
                    name.equals("servicemonitor.swc") || name.equals("crosspromotion.swc") ||
                    name.equals("gamepad.swc");
        }
    }

    private static class AirRuntimeFilter implements FilenameFilter {
        public boolean accept(File dir, String name) {
            return name.equalsIgnoreCase("adl.exe") || name.equalsIgnoreCase("adl");
        }
    }

    private static class AirMiscFilter implements FileFilter {

        private File rootSourceDirectory;

        AirMiscFilter(File rootSourceDirectory) {
            this.rootSourceDirectory = rootSourceDirectory;
        }

        public boolean accept(File pathname) {
            // frameworks/libs/air/ (All non swf & swc)
            // frameworks/projects/air/
            // include/
            // install/android/
            // samples/

            String relativePath = pathname.getAbsolutePath().substring(
                    rootSourceDirectory.getAbsolutePath().length());

            boolean result = "/AIR SDK license.pdf".equals(relativePath) ||
                    "/AIR SDK Readme.txt".equals(relativePath) ||
                    "/airsdk.xml".equals(relativePath) ||
                    relativePath.startsWith("/frameworks/projects/air/") ||
                    relativePath.startsWith("/include/") ||
                    relativePath.startsWith("/install/") ||
                    relativePath.startsWith("/samples/");

            if(relativePath.startsWith("/frameworks/libs/air/")) {
                result = !(pathname.getName().endsWith(".swc") || pathname.getName().endsWith(".swf"));
            }

            System.out.println(relativePath + " = " + result);
            return result;
        }
    }

    public static void main(String[] args) throws Exception {
        AirConverter converter = new AirConverter(new File(args[0]), new File(args[1]));
        converter.convert();
    }

}
