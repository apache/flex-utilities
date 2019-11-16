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
package org.apache.flex.utilities.converter.flex;

import org.apache.flex.utilities.converter.BaseConverter;
import org.apache.flex.utilities.converter.Converter;
import org.apache.flex.utilities.converter.air.AirConverter;
import org.apache.flex.utilities.converter.exceptions.ConverterException;
import org.apache.flex.utilities.converter.flash.FlashConverter;
import org.apache.flex.utilities.converter.model.MavenArtifact;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.*;
import java.util.*;
import java.util.jar.JarOutputStream;
import java.util.zip.ZipOutputStream;

public class FlexConverter extends BaseConverter implements Converter {

    protected String flexSdkVersion;
    protected String flexBuild;

    /**
     * @param rootSourceDirectory Path to the root of the original Flex SDK.
     * @param rootTargetDirectory Path to the root of the directory where the Maven artifacts should be generated to.
     * @throws org.apache.flex.utilities.converter.exceptions.ConverterException
     */
    public FlexConverter(File rootSourceDirectory, File rootTargetDirectory) throws ConverterException {
        super(rootSourceDirectory, rootTargetDirectory);

        // Get the version of the current Flex SDK.
        this.flexSdkVersion = getFlexVersion(rootSourceDirectory);
        this.flexBuild = getFlexBuild(rootSourceDirectory);
    }

    /**
     * Entry point for generating the Maven artifacts for an Flex SDK.
     *
     * @throws ConverterException
     */
    @Override
    protected void processDirectory() throws ConverterException {
        if((flexSdkVersion == null) || !rootSourceDirectory.exists() || !rootSourceDirectory.isDirectory()) {
            System.out.println("Skipping Flex SDK generation.");
            return;
        }

        generateCompilerArtifacts();
        generateFrameworkArtifacts();
        generateTemplatesArtifact();
    }

    /**
     * This method generates those artifacts that resemble the compiler part of the Flex SDK.
     *
     * @throws ConverterException
     */
    protected void generateCompilerArtifacts() throws ConverterException {
        // Create the root artifact.
        final MavenArtifact compiler = new MavenArtifact();
        compiler.setGroupId("org.apache.flex");
        compiler.setArtifactId("compiler");
        compiler.setVersion(flexSdkVersion);
        compiler.setPackaging("pom");

        // Create a list of all libs that should belong to the Flex SDK compiler.
        final File directory = new File(rootSourceDirectory, "lib");
        if(!directory.exists() || !directory.isDirectory()) {
            throw new ConverterException("Compiler directory does not exist.");
        }
        final List<File> files = new ArrayList<File>();
        files.addAll(Arrays.asList(directory.listFiles(new FlexCompilerFilter())));

        // Add all jars in the "external" directory.
        final File externalDirectory = new File(directory, "external");
        if(externalDirectory.exists() && externalDirectory.isDirectory()) {
            files.addAll(Arrays.asList(externalDirectory.listFiles(new FlexCompilerFilter())));
        }

        // Generate artifacts for every jar in the input directories.
        for(final File sourceFile : files) {
            final MavenArtifact artifact = resolveArtifact(sourceFile, "org.apache.flex.compiler", flexSdkVersion);
            compiler.addDependency(artifact);
        }

        // Write this artifact to file.
        writeArtifact(compiler);
    }

    /**
     * This method generates those artifacts that resemble the framework part of the Flex SDK.
     *
     * @throws ConverterException
     */
    protected void generateFrameworkArtifacts() throws ConverterException {
        final File directory = new File(rootSourceDirectory, "frameworks" + File.separator + "libs");
        generateFrameworkArtifacts(directory, "org.apache.flex");
        generateThemeArtifacts();
        generateFrameworkConfigurationArtifact();
    }

    protected void generateFrameworkArtifacts(File directory, String curGroupId) throws ConverterException {
        // Create the root artifact.
        final MavenArtifact framework = new MavenArtifact();
        framework.setGroupId(curGroupId);
        framework.setArtifactId("libs".equals(directory.getName()) ? "framework" : directory.getName());
        framework.setVersion(flexSdkVersion);
        framework.setPackaging("pom");

        final String artifactGroupId = framework.getGroupId() + "." + framework.getArtifactId();

        // Create a list of all libs that should belong to the Flex SDK framework.
        if(!directory.exists() || !directory.isDirectory()) {
            throw new ConverterException("Framework directory does not exist.");
        }
        final List<File> files = new ArrayList<File>();
        files.addAll(Arrays.asList(directory.listFiles(new FlexFrameworkFilter())));

        // Generate artifacts for every jar in the input directories.
        for(final File sourceFile : files) {
            // I think the experimental_mobile.swc belongs in the "mobile" package.
            if(!"libs".equals(directory.getName()) || !"experimental_mobile.swc".equals(sourceFile.getName())) {
                final MavenArtifact artifact = resolveArtifact(sourceFile, artifactGroupId, flexSdkVersion);
                framework.addDependency(artifact);
            }
        }

        // Forcefully add the mx library to the rest of the framework.
        if("libs".equals(directory.getName())) {
            final File mxSwc = new File(directory, "mx/mx.swc");
            final MavenArtifact artifact = resolveArtifact(mxSwc, artifactGroupId, flexSdkVersion);
            framework.addDependency(artifact);
        }

        // If we are in the "mobile" directory and the paren contains an "experimental_mobile.swc" file,
        // add this to the mobile package.
        if("mobile".equals(directory.getName())) {
            final File mobileExperimental = new File(directory.getParent(), "experimental_mobile.swc");
            if(mobileExperimental.exists()) {
                final MavenArtifact artifact = resolveArtifact(mobileExperimental, artifactGroupId, flexSdkVersion);
                framework.addDependency(artifact);
            }
        }
        // Write this artifact to file.
        writeArtifact(framework);

        // After processing the current directory, process any eventually existing child directories.
        final List<File> children = new ArrayList<File>();
        children.addAll(Arrays.asList(directory.listFiles(new FileFilter() {
            public boolean accept(File pathname) {
                return pathname.isDirectory() && !"player".equals(pathname.getName()) &&
                        !"mx".equals(pathname.getName());
            }
        })));
        for(final File childDirectory : children) {
            generateFrameworkArtifacts(childDirectory, artifactGroupId);
        }
    }

    protected void generateThemeArtifacts() throws ConverterException {
        final File frameworksDirectory = new File(rootSourceDirectory, "frameworks");

        // Deploy all the swcs in the themes directory.
        final File themesSrcDirectory = new File(frameworksDirectory, "themes");
        if(themesSrcDirectory.exists()) {
            generateDefaultThemeArtifacts(themesSrcDirectory);
        }

        // Deploy MXFTEText theme
        final File mxfteThemeCss = new File(frameworksDirectory, "projects" + File.separator + "spark" +
                File.separator + "MXFTEText.css");
        if(mxfteThemeCss.exists()){
            generateMxFteThemeArtifact(mxfteThemeCss);
        }
    }

    protected void generateTemplatesArtifact() throws ConverterException {
        // Create the root artifact.
        final MavenArtifact templates = new MavenArtifact();
        templates.setGroupId("org.apache.flex");
        templates.setArtifactId("templates");
        templates.setVersion(flexSdkVersion);
        templates.setPackaging("jar");

        final File templatesDir = new File(rootSourceDirectory, "templates");
        final File[] directories = templatesDir.listFiles(new FileFilter() {
            public boolean accept(File pathname) {
                return pathname.isDirectory() && "automation-runtimeloading-files".equals(pathname.getName());
            }
        });

        try {
            final File jar = File.createTempFile("flex-templates-" + flexSdkVersion, "jar");
            generateZip(directories, jar);
            templates.addDefaultBinaryArtifact(jar);
        } catch (IOException e) {
            throw new ConverterException("Error creating runtime zip.", e);
        }

    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //   Utility methods
    //
    ///////////////////////////////////////////////////////////////////////////////////////////////////

    @Override
    protected void writeArtifact(MavenArtifact artifact) throws ConverterException {
        if(!"pom".equals(artifact.getPackaging())) {
            // Copy the rsls.
            final File rslSourceFile = getRsl(artifact.getArtifactId());
            if(rslSourceFile != null) {
                final File rslTargetFile = new File(
                        artifact.getBinaryTargetFile(rootTargetDirectory, MavenArtifact.DEFAULT_CLASSIFIER).getParent(),
                        artifact.getArtifactId() + "-" + artifact.getVersion() + ".swf");
                copyFile(rslSourceFile, rslTargetFile);
                artifact.addBinaryArtifact("rsl", rslSourceFile);
            }

            // Copy the swzc.
            final File signedRslSourceFile = getSignedRsl(artifact.getArtifactId());
            if(signedRslSourceFile != null) {
                final File signedRslTargetFile = new File(
                        artifact.getBinaryTargetFile(rootTargetDirectory, MavenArtifact.DEFAULT_CLASSIFIER).getParent(),
                        artifact.getArtifactId() + "-" + artifact.getVersion() + ".swz");
                copyFile(signedRslSourceFile, signedRslTargetFile);
                artifact.addBinaryArtifact("caching", rslSourceFile);
            }

            // Copy the language resources.
            final Map<String, File> resourceBundles = getResourceBundles(artifact.getArtifactId());
            if(!resourceBundles.isEmpty() &&
                    artifact.getBinaryTargetFile(rootTargetDirectory, MavenArtifact.DEFAULT_CLASSIFIER) != null) {
                boolean foundResources = false;
                for(final String resource : resourceBundles.keySet()) {
                    final File resourceSourceFile = resourceBundles.get(resource);
                    final File resourceTargetFile = new File(
                            artifact.getBinaryTargetFile(rootTargetDirectory, MavenArtifact.DEFAULT_CLASSIFIER).getParent(),
                            artifact.getArtifactId() + "-" + artifact.getVersion() + "-" + resource + ".rb.swc");
                    copyFile(resourceSourceFile, resourceTargetFile);
                    foundResources = true;
                }

                // If the library had at least one resource bundle, generate a dummy rb.swc and add that as dependency.
                if(foundResources) {
                    final File resourceDummyTargetFile = new File(
                            artifact.getBinaryTargetFile(rootTargetDirectory, MavenArtifact.DEFAULT_CLASSIFIER).getParent(),
                            artifact.getArtifactId() + "-" + artifact.getVersion() + ".rb.swc");
                    writeDummy(resourceDummyTargetFile);

                    final MavenArtifact resourceBundleDependency = new MavenArtifact();
                    resourceBundleDependency.setGroupId(artifact.getGroupId());
                    resourceBundleDependency.setArtifactId(artifact.getArtifactId());
                    resourceBundleDependency.setVersion(artifact.getVersion());
                    resourceBundleDependency.setPackaging("rb.swc");
                    artifact.addDependency(resourceBundleDependency);
                }
            }

            // Add source zips.
            final File sourceArtifactSourceFile = generateSourceArtifact(artifact.getArtifactId());
            if(sourceArtifactSourceFile != null) {
                final File sourceArtifactTargetFile = new File(
                        artifact.getBinaryTargetFile(rootTargetDirectory, MavenArtifact.DEFAULT_CLASSIFIER).getParent(),
                        artifact.getArtifactId() + "-" + artifact.getVersion() + "-sources.jar");
                copyFile(sourceArtifactSourceFile, sourceArtifactTargetFile);
            }

            // If this is the asdoc artifact, create the templates.zip for that.
            if("asdoc".equals(artifact.getArtifactId())) {
                final File asdocTemplatesZipSourceFile = generateAsdocTemplatesZip();
                if (asdocTemplatesZipSourceFile != null) {
                    final File asdocTemplatesZipTargetFile = new File(
                            artifact.getBinaryTargetFile(
                                    rootTargetDirectory, MavenArtifact.DEFAULT_CLASSIFIER).getParent(),
                            artifact.getArtifactId() + "-" + artifact.getVersion() + "-template.zip");
                    copyFile(asdocTemplatesZipSourceFile, asdocTemplatesZipTargetFile);
                }
            }
        }

        super.writeArtifact(artifact);
    }

    protected File generateSourceArtifact(String artifactId) throws ConverterException {
        final File frameworksDirectory = new File(rootSourceDirectory, "frameworks");
        final File librarySrcRootPath = new File(frameworksDirectory, "projects/" + artifactId);
        final File librarySourcePath = new File(librarySrcRootPath, "src");

        if (librarySourcePath.listFiles() != null) {
            final File sourceFiles[] = librarySourcePath.listFiles();
            if (sourceFiles != null) {
                final File zipInputFiles[] = new File[sourceFiles.length + 1];
                System.arraycopy(sourceFiles, 0, zipInputFiles, 0, sourceFiles.length);

                try {
                    // Create a temp file.
                    final File targetFile = File.createTempFile("temp-" + artifactId, "zip");

                    JarOutputStream jar = new JarOutputStream(new FileOutputStream(targetFile));
                    for (final File file : zipInputFiles) {
                        addFileToZip(jar, file, librarySourcePath);
                    }
                    jar.close();

                    return targetFile;
                } catch(IOException e) {
                    throw new ConverterException("Error creating source archive.", e);
                }
            }
        }
        return null;
    }

    protected File generateAsdocTemplatesZip() throws ConverterException {
        final File templatesDirectory = new File(rootSourceDirectory, "asdoc/templates");

        if (templatesDirectory.listFiles() != null) {
            final File sourceFiles[] = templatesDirectory.listFiles();
            if (sourceFiles != null) {
                final File zipInputFiles[] = new File[sourceFiles.length + 1];
                System.arraycopy(sourceFiles, 0, zipInputFiles, 0, sourceFiles.length);

                try {
                    // Create a temp file.
                    final File targetFile = File.createTempFile("temp-asdoc-templates", "zip");

                    JarOutputStream jar = new JarOutputStream(new FileOutputStream(targetFile));
                    for (final File file : zipInputFiles) {
                        addFileToZip(jar, file, templatesDirectory);
                    }
                    jar.close();

                    return targetFile;
                } catch(IOException e) {
                    throw new ConverterException("Error creating asdoc-templates archive.", e);
                }
            }
        }
        return null;
    }

    protected void generateFrameworkConfigurationArtifact() throws ConverterException {
        // ZIP up every file (not directory) in the framework directory and the entire themes directory.
        final File frameworksDirectory = new File(rootSourceDirectory, "frameworks");
        final File sourceFiles[] = frameworksDirectory.listFiles(new FileFilter() {
            public boolean accept(File pathname) {
                return pathname.isFile();
            }
        });
        final File zipInputFiles[] = new File[sourceFiles.length];
        System.arraycopy(sourceFiles, 0, zipInputFiles, 0, sourceFiles.length);

        try {
            final File targetFile = new File(rootTargetDirectory,
                    "org.apache.flex.framework.framework.".replace(".", File.separator) + flexSdkVersion +
                            File.separator + "framework-" + flexSdkVersion + "-configs.zip");

            // Add all the content to a zip-file.
            final ZipOutputStream zipOutputStream = new ZipOutputStream(new FileOutputStream(targetFile));
            for (final File file : zipInputFiles) {
                addFileToZip(zipOutputStream, file, frameworksDirectory);
            }
            zipOutputStream.close();
        } catch(IOException e) {
            throw new ConverterException("Error generating configuration zip.", e);
        }
    }

    protected void generateDefaultThemeArtifacts(File themesDirectory) throws ConverterException {
        final File[] themes = themesDirectory.listFiles();
        if(themes != null) {
            for(final File themeDirectory : themes) {
                if(themeDirectory.isDirectory()) {
                    final String themeName = themeDirectory.getName().toLowerCase();
                    final File themeFile = new File(themeDirectory, themeName + ".swc");

                    final File targetSwcFile;
                    if(themeFile.exists()) {
                        targetSwcFile = themeFile;
                    } else {
                        targetSwcFile = generateThemeSwc(themeDirectory);
                    }

                    if(targetSwcFile != null) {
                        // Generate the pom file.
                        final MavenArtifact themeArtifact = new MavenArtifact();
                        themeArtifact.setGroupId("org.apache.flex.framework.themes");
                        themeArtifact.setArtifactId(themeName);
                        themeArtifact.setVersion(flexSdkVersion);
                        themeArtifact.setPackaging("swc");
                        themeArtifact.addDefaultBinaryArtifact(targetSwcFile);

                        // In this case we don't want the resources to be copied.
                        super.writeArtifact(themeArtifact);
                    }
                }
            }
        }
    }

    protected void generateMxFteThemeArtifact(File themeCssFile) throws ConverterException {
        final String themeName = "mxfte";

        // Generate and Copy the SWC.
        final File targetSwcFile = generateThemeSwc(themeCssFile);

        if(targetSwcFile != null) {
            // Generate the pom file.
            final MavenArtifact themeArtifact = new MavenArtifact();
            themeArtifact.setGroupId("org.apache.flex.framework.themes");
            themeArtifact.setArtifactId(themeName);
            themeArtifact.setVersion(flexSdkVersion);
            themeArtifact.setPackaging("swc");
            themeArtifact.addDefaultBinaryArtifact(targetSwcFile);

            // In this case we don't want the resources to be copied.
            super.writeArtifact(themeArtifact);
        }
    }

    protected File generateThemeSwc(File themeDirectory) throws ConverterException {
        final File fdkLibDir = new File(rootSourceDirectory, "lib");

        List<String> processCmd = new ArrayList<String>(10);

        if(fdkLibDir.exists() && fdkLibDir.isDirectory()) {
            try {
                final File compcLibrary = new File(fdkLibDir, "compc.jar");
                final File frameworkDir = new File(rootSourceDirectory, "frameworks");
                final String targetPlayer = getTargetPlayer(new File(frameworkDir, "libs/player"));
                if(targetPlayer == null) {
                    System.out.println("Skipping theme compilation due to missing playerglobl.swc");
                    return null;
                }

                processCmd.add("java");
                processCmd.add("-Xmx384m");
                processCmd.add("-Dsun.io.useCanonCaches=false");
                processCmd.add("-jar");
                processCmd.add(compcLibrary.getCanonicalPath());
                processCmd.add("+flexlib=" + frameworkDir.getCanonicalPath());
                processCmd.add("-target-player=" + targetPlayer);

                if (themeDirectory.isDirectory()) {
                    // Add all the content files.
                    final File contents[] = themeDirectory.listFiles(new FileFilter() {
                        public boolean accept(File pathname) {
                            return !(pathname.isDirectory() && "src".equals(pathname.getName())) &&
                                    !"preview.jpg".equals(pathname.getName()) && !pathname.getName().endsWith(".fla");
                        }
                    });
                    if (contents.length == 0) {
                        return null;
                    }

                    for (final File resource : contents) {
                        processCmd.add("-include-file");
                        processCmd.add(resource.getName());
                        processCmd.add(resource.getCanonicalPath());
                    }
                } else {
                    processCmd.add("-include-file");
                    processCmd.add(themeDirectory.getName());
                    processCmd.add(themeDirectory.getCanonicalPath());
                }

                // Create a temp file.
                final File targetFile = File.createTempFile(themeDirectory.getName(), "swc");

                // Define the output file.
                processCmd.add("-o");
                processCmd.add(targetFile.getCanonicalPath());

                final File targetDirectory = targetFile.getParentFile();
                if (!targetDirectory.exists()) {
                    if (!targetDirectory.mkdirs()) {
                        throw new ConverterException("Could not create directory: " + targetDirectory.getCanonicalPath());
                    }
                }

                // Execute the command.
                try {
                    System.out.println("Generating theme '" + themeDirectory.getName() + "'");

                    //final Process child = Runtime.getRuntime().exec(cmd.toString(), envps);
                    ProcessBuilder processBuilder = new ProcessBuilder(processCmd);
                    processBuilder.environment().put("PLAYERGLOBAL_HOME",
                            new File(new File(frameworkDir, "libs"), "player").getCanonicalPath());
                    int exitValue = exec(processBuilder.start());
                    if (exitValue != 0) {
                        System.out.println("Couldn't create theme swc");
                        System.out.println("----------------------------------------------------------------");
                        System.out.println("Env: '" + processBuilder.environment().get("PLAYERGLOBAL_HOME") + "'");
                        System.out.println(processBuilder.command());
                        System.out.println("----------------------------------------------------------------");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

                // Return a reference on the theme swc.
                return targetFile;
            } catch(IOException e) {
                throw new ConverterException("Error generating theme swc.", e);
            }
        }
        return null;
    }

    protected int exec(Process p) throws InterruptedException, IOException {
        String line;
        BufferedReader bri = new BufferedReader(new InputStreamReader(p.getInputStream()));
        BufferedReader bre = new BufferedReader(new InputStreamReader(p.getErrorStream()));
        while ((line = bri.readLine()) != null) {
            System.out.println(line);
        }
        while ((line = bre.readLine()) != null) {
            System.out.println(line);
        }
        int result = p.waitFor();
        bri.close();
        bre.close();
        System.out.println("Done.");
        return result;
    }

    /**
     * Get the version of an Flex SDK from the content of the SDK directory.
     *
     * @return version string for the current Flex SDK
     */
    protected String getFlexBuild(File rootDirectory) throws ConverterException {
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
            return root.getElementsByTagName("build").item(0).getTextContent();
        } catch (ParserConfigurationException pce) {
            throw new ConverterException("Error parsing flex-sdk-description.xml", pce);
        } catch (SAXException se) {
            throw new ConverterException("Error parsing flex-sdk-description.xml", se);
        } catch (IOException ioe) {
            throw new ConverterException("Error parsing flex-sdk-description.xml", ioe);
        }
    }

    protected File getRsl(String artifactId) {
        final FlexRslFilter filter = new FlexRslFilter(artifactId, flexSdkVersion, flexBuild);
        final File rslDirectory = new File(rootSourceDirectory, "frameworks" + File.separator + "rsls");
        final File[] rsls = rslDirectory.listFiles(filter);
        if ((rsls != null) && (rsls.length == 1)) {
            return rsls[0];
        }
        return null;
    }

    protected File getSignedRsl(String artifactId) {
        final FlexSignedRslFilter filter = new FlexSignedRslFilter(artifactId, flexSdkVersion);
        final File rslDirectory = new File(rootSourceDirectory, "frameworks" + File.separator + "rsls");
        final File[] swzs = rslDirectory.listFiles(filter);
        if ((swzs != null) && (swzs.length == 1)) {
            return swzs[0];
        }
        return null;
    }

    protected Map<String, File> getResourceBundles(String artifactId) {
        final Map<String, File> bundles = new HashMap<String, File>();
        final FlexResourceBundleFilter filter = new FlexResourceBundleFilter(artifactId);
        final File[] languages = new File(rootSourceDirectory, "frameworks" + File.separator + "locale").listFiles();
        if(languages != null) {
            for (final File language : languages) {
                final File[] resources = language.listFiles(filter);
                if ((resources != null) && (resources.length == 1)) {
                    bundles.put(language.getName(), resources[0]);
                }
            }
        }
        return bundles;
    }

    protected String getTargetPlayer(File playerDir) {
        if(playerDir.exists() && playerDir.isDirectory()) {
            File[] files = playerDir.listFiles();
            if((files != null) && files.length > 0) {
                return files[0].getName();
            }
        }
        return null;
    }

    public static class FlexCompilerFilter implements FilenameFilter {
        private AirConverter.AirCompilerFilter airFilter = new AirConverter.AirCompilerFilter();

        public boolean accept(File dir, String name) {
            return name.endsWith(".jar") && !airFilter.accept(dir, name) &&
                    // Some old AIR SDKs contained two android libs in the main lib directory,
                    // we have to manually exclude them.
                    !name.equals("smali.jar") && !name.equals("baksmali.jar");
        }
    }

    public static class FlexFrameworkFilter implements FilenameFilter {
        private AirConverter.AirFrameworkFilter airFilter = new AirConverter.AirFrameworkFilter();
        private FlashConverter.FlashFrameworkFilter flashFilter = new FlashConverter.FlashFrameworkFilter();

        public boolean accept(File dir, String name) {
            return name.endsWith(".swc") && !airFilter.accept(dir, name) && !flashFilter.accept(dir, name);
        }
    }

    public static class FlexRslFilter implements FilenameFilter {
        private String fileName;

        public FlexRslFilter(String artifactName, String artifactVersion, String build) {
            this.fileName = artifactName + "_" + artifactVersion + "." + build + ".swf";
        }

        public boolean accept(File dir, String name) {
            return name.equals(fileName);
        }
    }

    public static class FlexSignedRslFilter implements FilenameFilter {
        private String fileName;

        public FlexSignedRslFilter(String artifactName, String artifactVersion) {
            this.fileName = artifactName + "_" + artifactVersion + ".swz";
        }

        public boolean accept(File dir, String name) {
            return name.equals(fileName);
        }
    }

    public static class FlexResourceBundleFilter implements FilenameFilter {
        private String fileName;

        public FlexResourceBundleFilter(String artifactName) {
            this.fileName = artifactName + "_rb.swc";
        }

        public boolean accept(File dir, String name) {
            return name.equals(fileName);
        }
    }

    public static void main(String[] args) throws Exception {
        FlexConverter converter = new FlexConverter(new File(args[0]), new File(args[1]));
        converter.convert();
    }

}
