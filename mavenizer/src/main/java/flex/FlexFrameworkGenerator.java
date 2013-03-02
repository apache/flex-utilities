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
package flex;

import common.BaseGenerator;
import common.MavenMetadata;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.jar.JarOutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/**
 * Created with IntelliJ IDEA.
 * User: cdutz
 * Date: 11.05.12
 * Time: 14:55
 *
 * @author Christofer Dutz
 * @author Jose Barragan
 */
public class FlexFrameworkGenerator extends BaseGenerator {

    protected Map<String, String> libraryVersions = new HashMap<String, String>();
    protected Map<String, String> libraryLocations = new HashMap<String, String>();
    protected List<String> librariesWithLocales = new ArrayList<String>();

    protected static final List<String> skipArtifacts;

    static {
        skipArtifacts = new ArrayList<String>();
        //skipArtifacts.add("playerglobal.swc");
        skipArtifacts.add("aircore.swc");
        skipArtifacts.add("airglobal.swc");
        skipArtifacts.add("applicationupdater.swc");
        skipArtifacts.add("applicationupdater_ui.swc");
        skipArtifacts.add("servicemonitor.swc");
        // The Flex 4.0.0.14159A contains a strange "flex3" directory in the air framework.
        // Simply skip this.
        skipArtifacts.add("flex3");
    }

    public void process(File sdkSourceDirectory, final boolean isApache, File sdkTargetDirectory, String sdkVersion,
                        boolean useApache)
            throws Exception {
        final File frameworksDirectory = new File(sdkSourceDirectory, "frameworks");
        final File rslsDirectory = new File(frameworksDirectory, "rsls");
        final File targetBaseDirectory = new File(sdkTargetDirectory,
                (isApache && useApache) ? "org/apache/flex/framework" : "com/adobe/flex/framework");

        // Look at the RSLs first, as these have version numbers.
        // This makes it possible to deploy the swcs with the correct versions.
        // textLayout and osmf have different versions than the rest of the sdk.
        // Unfortunately we cannot deploy them yet, because the location of the
        // swz and swf will be determined by the location of the swc.
        final String[] rslNames = rslsDirectory.list(new FilenameFilter() {
            public boolean accept(File dir, String name) {
                return name.endsWith(".swf");
            }
        });
        if (rslNames != null) {
            for (final String rslName : rslNames) {
                final String libraryName = rslName.substring(0, rslName.lastIndexOf("_"));
                final String libraryVersion = rslName.substring(rslName.lastIndexOf("_") + 1, rslName.lastIndexOf("."));
                libraryVersions.put(libraryName, libraryVersion);
            }
        }

        // Find out which locales are generally available and which libraries have locale information.
        final File localeDirectory = new File(frameworksDirectory, "locale");
        final List<String> locales = new ArrayList<String>();
        final File[] localesDirectories = localeDirectory.listFiles();
        if (localesDirectories != null) {
            for (final File locale : localesDirectories) {
                if (locale.isDirectory()) {
                    final String localeCode = locale.getName();
                    locales.add(localeCode);

                    for (final File library : locale.listFiles(new FileFilter() {
                        public boolean accept(File pathname) {
                            return pathname.getName().endsWith("_rb.swc");
                        }
                    })) {
                        final String libraryName = library.getName().substring(0, library.getName().lastIndexOf("_"));
                        if (!librariesWithLocales.contains(libraryName)) {
                            librariesWithLocales.add(libraryName);
                        }
                    }
                }
            }
        }

        // Generate the artifacts based upon the structure of the libraries in the lib-directory.
        final File swcsDirectory = new File(frameworksDirectory, "libs");
        generateArtifactsForDirectory(swcsDirectory, targetBaseDirectory, sdkVersion,
                (isApache && useApache) ? "org.apache.flex.framework" : "com.adobe.flex.framework",
                false, isApache && useApache);

        // Deploy the playerglobal in it's own groupId as this is not directly linked to flex.
        final File playerRootDirectory = new File(sdkTargetDirectory, "com/adobe/flash");
        generatePlayerglobalArtifacts(new File(swcsDirectory, "player"), new File(playerRootDirectory, "framework"));
        final String minimumFlashPlayerVersion = getMinimumPlayerVersion(frameworksDirectory);
        generateFlexFrameworkPom(targetBaseDirectory, sdkVersion, isApache && useApache, minimumFlashPlayerVersion);

        // After processing the swcs the locations for the libraries will be
        // available and the swfs and swzs can be deployed.
        if (rslNames != null) {
            for (final String rslName : rslNames) {
                final String libraryName = rslName.substring(0, rslName.lastIndexOf("_"));
                final String libraryVersion = libraryVersions.get(libraryName);
                final String libraryLocation = libraryLocations.get(libraryName);
                // Only if a lib has been deployed the corresponding swfs and swzs are deployed too.
                if (libraryLocation != null) {
                    final String swzName = rslName.substring(0, rslName.lastIndexOf(".")) + ".swz";
                    final File swzSourceFile = new File(rslsDirectory, swzName);
                    // Apache SDKs don't come with swz files.
                    if (swzSourceFile.exists()) {
                        final File swzTargetFile = new File(libraryLocation + "/" + libraryName + "-" +
                                libraryVersion + ".swz");
                        copyFile(swzSourceFile, swzTargetFile);
                    }

                    final File rslSourceFile = new File(rslsDirectory, rslName);
                    final File rslTargetFile = new File(libraryLocation + "/" + libraryName + "-" +
                            libraryVersion + ".swf");
                    copyFile(rslSourceFile, rslTargetFile);
                }
            }
        }

        // For every library available, try to copy existing resource bundles.
        for (final String libraryName : libraryLocations.keySet()) {
            final String libraryVersion = libraryVersions.get(libraryName);
            final File targetDirectory = new File(libraryLocations.get(libraryName));
            boolean atLeastOneResourceBundleCopied = false;
            for (final String localeCode : locales) {
                final File resourceBundle = new File(localeDirectory, localeCode + "/" + libraryName + "_rb.swc");
                if (resourceBundle.exists() && resourceBundle.isFile()) {
                    if (libraryLocations.get(libraryName) != null) {
                        final File targetFile = new File(targetDirectory, libraryName + "-" + libraryVersion + "-" +
                                localeCode + ".rb.swc");

                        copyFile(resourceBundle, targetFile);

                        atLeastOneResourceBundleCopied = true;
                    }
                }
            }

            if (atLeastOneResourceBundleCopied) {
                // Add the swc.rb dependency to the pom.

                // Generate the strange 1kb rb.swc
                final File dummyRbFile = new File(targetDirectory, libraryName + "-" + libraryVersion + ".rb.swc");
                writeDummyResourceBundleSwc(dummyRbFile);
            }
        }

        // Zip up the general framework config files to a single zip and deploy
        // it alongside with the framework jar.
        createConfigsZip(frameworksDirectory);

        // For every library available, to zip existing sources.
        for (final String libraryName : libraryLocations.keySet()) {
            final File librarySrcRootPath = new File(frameworksDirectory, "projects/" + libraryName);
            File librarySourcePath = new File(librarySrcRootPath, "src");

            if (!librarySourcePath.exists()) {
                librarySourcePath = librarySrcRootPath;
            }

            if (librarySourcePath != null && librarySourcePath.listFiles() != null) {
                final File sourceFiles[] = librarySourcePath.listFiles();
                if (sourceFiles != null) {
                    final File zipInputFiles[] = new File[sourceFiles.length + 1];
                    System.arraycopy(sourceFiles, 0, zipInputFiles, 0, sourceFiles.length);

                    final File targetFinalDirectory = findDirectory(targetBaseDirectory, libraryName);

                    if (targetFinalDirectory != null) {
                        // Add all the content to a zip-file.
                        final File targetFile = new File(targetFinalDirectory,
                                                         libraryVersions.get(libraryName) + "/" + libraryName + "-" +
                                                                 libraryVersions.get(libraryName)
                                                                 + "-sources.jar");
                        JarOutputStream jar = new JarOutputStream(new FileOutputStream(targetFile));
                        for (final File file : zipInputFiles) {
                            addFileToZip(jar, file, librarySourcePath);
                        }
                        jar.close();
                    }
                }
            }
        }

        // Deploy all the swcs in the themes directory.
        final File themesSrcDirectory = new File(frameworksDirectory, "themes");
        if(themesSrcDirectory.exists()) {
            generateThemeArtifacts(themesSrcDirectory, targetBaseDirectory, sdkVersion, isApache && useApache);
        }
    }

    protected void generateArtifactsForDirectory(final File sourceDirectory, final File targetDirectory,
                                                 final String sdkVersion, final String groupId,
                                                 boolean skipGroupPomGeneration, final boolean isApache)
            throws Exception {
        final MavenMetadata groupMetadata = new MavenMetadata();
        groupMetadata.setGroupId(groupId.substring(0, groupId.lastIndexOf(".")));
        groupMetadata.setArtifactId(groupId.substring(groupId.lastIndexOf(".") + 1, groupId.length()));
        groupMetadata.setVersion(sdkVersion);
        groupMetadata.setPackaging("pom");
        groupMetadata.setLibrariesWithResourceBundles(new ArrayList<String>());
        groupMetadata.setDependencies(new ArrayList<MavenMetadata>());

        // Don't deploy the player, as this has to be dealt with differently.
        final File[] directoryContent = sourceDirectory.listFiles(new FileFilter() {
            public boolean accept(File pathname) {
                if (pathname.isDirectory()) {
                    // Skip the player directory as this contains the playerglobal
                    // versions which we want to deploy at a different location.
                    return !"player".equals(pathname.getName());
                } else {
                    // In the flex 2 sdk the playerglobal is located
                    // directly in the framework directory.
                    return !("playerglobal.swc".equals(pathname.getName()) && "libs".equals(
                            pathname.getParentFile().getName())) && pathname.getName()
                            .endsWith(".swc");
                }
            }
        });

        if (directoryContent != null) {
            for (File file : directoryContent) {
                // The Adobe sdks contain some stuff that should not be deployed
                // with the rest as they belong to the flashplayer or the air-sdk.
                if (!skipArtifacts.contains(file.getName())) {
                    final MavenMetadata metadata = new MavenMetadata();
                    metadata.setGroupId(groupId);
                    // If the current entry is a directory, generate artifacts for that
                    // except for the mx directory. For this we output the one mx.swc in
                    // the same level as the rest of the flex sdk.
                    if (file.isDirectory() && !"mx".equals(file.getName())) {
                        generateArtifactsForDirectory(file, new File(
                                targetDirectory, file.getName()), sdkVersion, groupId + "." + file.getName(),
                                skipGroupPomGeneration, isApache);
                    }
                    // If it's a file, generate the artifact for it.
                    else {
                        String libraryName;
                        // If this is the mx directory, redirect to the mx.swc inside that directory.
                        if ("mx".equals(file.getName()) && file.isDirectory()) {
                            libraryName = "mx";
                            file = new File(file, "mx.swc");
                        } else {
                            libraryName = file.getName().substring(0, file.getName().lastIndexOf("."));
                        }
                        // If an artifact contained a concrete version for the given library
                        // (specified by the swz files), use that version. Else just use the
                        // sdk version.
                        String libraryVersion = libraryVersions.get(libraryName);
                        if ((libraryVersion == null) || ("playerglobal".equals(libraryName))) {
                            libraryVersion = sdkVersion;
                        }

                        // Create the target directory that will contain the swc, swf, swc, resource files and pom.
                        final File targetSwcDirectory = new File(targetDirectory, libraryName + "/" + libraryVersion);
                        if (!targetSwcDirectory.exists()) {
                            if (!targetSwcDirectory.mkdirs()) {
                                throw new RuntimeException("Could not create directory: " +
                                        targetSwcDirectory.getAbsolutePath());
                            }
                        }

                        // Create the target file and copy the library there.
                        final File targetSwcFile =
                                new File(targetSwcDirectory, libraryName + "-" + libraryVersion + ".swc");
                        copyFile(file, targetSwcFile);

                        // Populate the metadata for the current artifact.
                        metadata.setArtifactId(libraryName);
                        metadata.setVersion(libraryVersion);
                        metadata.setPackaging("swc");

                        // Generate the pom for the current artifact.
                        generateSwcPom(targetSwcFile, metadata);

                        // Add the current artifact to the artifact-group it belongs to.
                        // Usually there is one artifact-group for each directory level.
                        // A group usually consists of one "commons" pom-artifact binding
                        // all the artifact versions that were in the same sdk and one
                        // dependency-management pom that can be used to automatically
                        // handle the dependency versions.
                        groupMetadata.getDependencies().add(metadata);

                        // For the framework library an additional dependency has to be added.
                        if ("framework".equals(libraryName)) {
                            final MavenMetadata frameworkConfigMetadata = new MavenMetadata();
                            frameworkConfigMetadata.setGroupId(metadata.getGroupId());
                            frameworkConfigMetadata.setArtifactId(metadata.getArtifactId());
                            frameworkConfigMetadata.setVersion(metadata.getVersion());
                            frameworkConfigMetadata.setPackaging("zip");
                            frameworkConfigMetadata.setClassifier("configs");

                            groupMetadata.getDependencies().add(frameworkConfigMetadata);
                        }

                        libraryLocations.put(libraryName, targetSwcDirectory.getAbsolutePath());
                        libraryVersions.put(libraryName, libraryVersion);
                    }
                }
            }
        }

        if (!skipGroupPomGeneration) {
            // Add the names of libraries that have resource bundles to the list,
            // so the "rb.swc" dependencies can be generated.
            for (final MavenMetadata dependency : groupMetadata.getDependencies()) {
                if (!"pom".equals(dependency.getPackaging())) {
                    if (librariesWithLocales.contains(dependency.getArtifactId())) {
                        groupMetadata.getLibrariesWithResourceBundles().add(dependency.getArtifactId());
                    }
                }
            }

            // Generate a "flex-framework" and "flex-common" artifact defining all
            // the dependencies the same way velos sdks did.
            if ("libs".equals(sourceDirectory.getName())) {
                final MavenMetadata commonFrameworkMetaData = new MavenMetadata();
                commonFrameworkMetaData.setGroupId(groupId);
                commonFrameworkMetaData.setArtifactId("common-framework");
                commonFrameworkMetaData.setVersion(groupMetadata.getVersion());
                commonFrameworkMetaData.setPackaging("pom");
                commonFrameworkMetaData.setDependencies(new ArrayList<MavenMetadata>());
                commonFrameworkMetaData.setLibrariesWithResourceBundles(new ArrayList<String>());

                for (final MavenMetadata dependency : groupMetadata.getDependencies()) {
                    commonFrameworkMetaData.getDependencies().add(dependency);
                    if (groupMetadata.getLibrariesWithResourceBundles().contains(dependency.getArtifactId())) {
                        commonFrameworkMetaData.getLibrariesWithResourceBundles().add(dependency.getArtifactId());
                    }
                }
                final File commonFrameworkPom = new File(targetDirectory, "common-framework/" +
                        groupMetadata.getVersion() + "/common-framework-" +
                        groupMetadata.getVersion() + ".pom");
                generateSwcPom(commonFrameworkPom, commonFrameworkMetaData);

                // Generate a dummy entry for the "flex-framework" pom,
                // which will be generated later in the process.
                final MavenMetadata flexFrameworkMetadata = new MavenMetadata();
                flexFrameworkMetadata.setGroupId(groupId);
                flexFrameworkMetadata.setArtifactId("flex-framework");
                flexFrameworkMetadata.setVersion(groupMetadata.getVersion());
                flexFrameworkMetadata.setPackaging("pom");
                groupMetadata.getDependencies().add(flexFrameworkMetadata);
            } else if ("air".equals(sourceDirectory.getName())) {
                final MavenMetadata airCommonFrameworkMetaData = new MavenMetadata();
                airCommonFrameworkMetaData.setGroupId(groupId);
                airCommonFrameworkMetaData.setArtifactId("common-framework");
                airCommonFrameworkMetaData.setVersion(groupMetadata.getVersion());
                airCommonFrameworkMetaData.setPackaging("pom");
                airCommonFrameworkMetaData.setDependencies(new ArrayList<MavenMetadata>());
                airCommonFrameworkMetaData.setLibrariesWithResourceBundles(new ArrayList<String>());

                for (final MavenMetadata dependency : groupMetadata.getDependencies()) {
                    airCommonFrameworkMetaData.getDependencies().add(dependency);
                    if (groupMetadata.getLibrariesWithResourceBundles().contains(dependency.getArtifactId())) {
                        airCommonFrameworkMetaData.getLibrariesWithResourceBundles().add(dependency.getArtifactId());
                    }
                }
                final File commonFrameworkPom = new File(targetDirectory, "common-framework/" +
                        groupMetadata.getVersion() + "/common-framework-" +
                        groupMetadata.getVersion() + ".pom");
                generateSwcPom(commonFrameworkPom, airCommonFrameworkMetaData);

                // Generate a dummy entry for the "flex-framework" pom,
                // which will be generated later in the process.
                final MavenMetadata flexFrameworkMetadata = new MavenMetadata();
                flexFrameworkMetadata.setGroupId(groupId);
                flexFrameworkMetadata.setArtifactId("air-framework");
                flexFrameworkMetadata.setVersion(groupMetadata.getVersion());
                flexFrameworkMetadata.setPackaging("pom");
                groupMetadata.getDependencies().add(flexFrameworkMetadata);

                // In the air-directory the checksum of the airglobal.swc will determin the
                // air-sdk version.
                final File airglobalSwc = new File(sourceDirectory, "airglobal.swc");
                if (airglobalSwc.exists()) {
                    final String checksum = calculateChecksum(airglobalSwc);
                    final MavenMetadata airGlobalMetaData = checksums.get(checksum);
                    if (airGlobalMetaData != null) {
                        generateAirFrameworkPom(targetDirectory, sdkVersion, isApache, airGlobalMetaData.getVersion());
                    } else {
                        System.out.println("Couldn't find matching airglobal for FDK " + sdkVersion);
                    }
                }
            }

            // Generate the master pom for the current library (Pom that defines
            // all versions of the current sdk libraries.
            final File groupPomFile = new File(targetDirectory, groupMetadata.getVersion() +
                    "/" + groupMetadata.getArtifactId() + "-" +
                    groupMetadata.getVersion() + ".pom");
            generateDependencyManagementPom(groupPomFile, groupMetadata);
        }
    }

    protected void generatePlayerglobalArtifacts(final File playerDirectory, final File playersTargetDirectory)
            throws Exception {
        double highestPlayerVersion = 9.0;

        final File[] playerVersionDirectories = playerDirectory.listFiles(new FileFilter() {
            public boolean accept(File pathname) {
                return pathname.isDirectory();
            }
        });
        if (playerVersionDirectories != null) {
            // If no child directories were found, this is probably an old sdk
            // which contains the playerglobal for a flash player 9.
            if (playerVersionDirectories.length > 0) {
                for (final File playerVersionDirectory : playerVersionDirectories) {
                    if (playerVersionDirectory.isDirectory()) {
                        // The flash-player 10 was deployed as 10.0.0, we need to
                        // cut off the last ".0" to match the rest.
                        String playerVersionString = playerVersionDirectory.getName();
                        if (playerVersionString.lastIndexOf(".") != playerVersionString.indexOf(".")) {
                            playerVersionString = playerVersionString.substring(
                                    0, playerVersionString.lastIndexOf("."));
                        }
                        final double playerVersion = Double.valueOf(playerVersionString);
                        final NumberFormat doubleFormat = NumberFormat.getInstance(Locale.US);
                        doubleFormat.setMinimumFractionDigits(1);
                        doubleFormat.setMaximumFractionDigits(1);

                        if (highestPlayerVersion < playerVersion) {
                            highestPlayerVersion = playerVersion;
                        }

                        if (!playersTargetDirectory.exists()) {
                            if (!playersTargetDirectory.mkdirs()) {
                                throw new RuntimeException("Could not create directory: " +
                                        playersTargetDirectory.getAbsolutePath());
                            }
                        }

                        generateArtifactsForDirectory(
                                playerVersionDirectory, playersTargetDirectory, doubleFormat.format(playerVersion),
                                "com.adobe.flash.framework", true, false);
                    }
                }
            } else {
                generateArtifactsForDirectory(
                        playerDirectory, playersTargetDirectory, "9.0", "com.adobe.flash.framework", true, false);
            }
        }
    }

    protected void generateSwcPom(final File targetSwc, final MavenMetadata metadata) throws Exception {
        final String swcPath = targetSwc.getAbsolutePath();
        final String pomPath;
        if(metadata.getClassifier() == null) {
            pomPath = swcPath.substring(0, swcPath.lastIndexOf(".")) + ".pom";
        } else {
            pomPath = swcPath.substring(0, swcPath.lastIndexOf("-")) + ".pom";
        }

        final Document pom = createPomDocument(metadata);

        writeDocument(pom, new File(pomPath));
    }

    protected void generateDependencyManagementPom(final File targetSwc, final MavenMetadata metadata)
            throws Exception {
        final String swcPath = targetSwc.getAbsolutePath();
        final String pomPath = swcPath.substring(0, swcPath.lastIndexOf(".")) + ".pom";

        final Document pom = createPomDocumentDependencyManagement(metadata);

        writeDocument(pom, new File(pomPath));
    }

    protected void generateFlexFrameworkPom(
            File targetDirectory, String sdkVersion, boolean isApache, String playerVersion) throws Exception {
        final MavenMetadata flexFramework = new MavenMetadata();
        flexFramework.setGroupId((isApache) ? "org.apache.flex.framework" : "com.adobe.flex.framework");
        flexFramework.setArtifactId("flex-framework");
        flexFramework.setVersion(sdkVersion);
        flexFramework.setPackaging("pom");
        flexFramework.setDependencies(new ArrayList<MavenMetadata>());
        flexFramework.setLibrariesWithResourceBundles(new ArrayList<String>());

        final MavenMetadata commonFramework = new MavenMetadata();
        commonFramework.setGroupId((isApache) ? "org.apache.flex.framework" : "com.adobe.flex.framework");
        commonFramework.setArtifactId("common-framework");
        commonFramework.setVersion(sdkVersion);
        commonFramework.setPackaging("pom");
        flexFramework.getDependencies().add(commonFramework);

        final MavenMetadata playerglobal = new MavenMetadata();
        playerglobal.setGroupId("com.adobe.flash.framework");
        playerglobal.setArtifactId("playerglobal");
        playerglobal.setVersion(playerVersion);
        playerglobal.setPackaging("swc");
        flexFramework.getDependencies().add(playerglobal);
        if (!"9.0".equals(playerVersion)) {
            flexFramework.getLibrariesWithResourceBundles().add("playerglobal");
        }

        final File pomFile = new File(targetDirectory, "flex-framework/" + sdkVersion +
                "/flex-framework-" + sdkVersion + ".pom");
        generateSwcPom(pomFile, flexFramework);
    }

    protected void generateAirFrameworkPom(File targetDirectory, String sdkVersion, boolean isApache, String airVersion)
            throws Exception {
        final String flexFrameworkGroupId = (isApache) ? "org.apache.flex.framework" : "com.adobe.flex.framework";

        final MavenMetadata airFramework = new MavenMetadata();
        airFramework.setGroupId(flexFrameworkGroupId + ".air");
        airFramework.setArtifactId("air-framework");
        airFramework.setVersion(sdkVersion);
        airFramework.setPackaging("pom");
        airFramework.setDependencies(new ArrayList<MavenMetadata>());
        airFramework.setLibrariesWithResourceBundles(new ArrayList<String>());

        // Reference the core flex-sdks artifacts.
        final MavenMetadata flexCommonFramework = new MavenMetadata();
        flexCommonFramework.setGroupId(flexFrameworkGroupId);
        flexCommonFramework.setArtifactId("common-framework");
        flexCommonFramework.setVersion(sdkVersion);
        flexCommonFramework.setPackaging("pom");
        airFramework.getDependencies().add(flexCommonFramework);

        // Reference to the artifacts of the air components of the flex-sdk.
        final MavenMetadata flexAirCommonFramework = new MavenMetadata();
        flexAirCommonFramework.setGroupId(flexFrameworkGroupId + ".air");
        flexAirCommonFramework.setArtifactId("common-framework");
        flexAirCommonFramework.setVersion(sdkVersion);
        flexAirCommonFramework.setPackaging("pom");
        airFramework.getDependencies().add(flexAirCommonFramework);

        // Reference to the artifacts of the air-sdk.
        final MavenMetadata airCommonFramework = new MavenMetadata();
        airCommonFramework.setGroupId("com.adobe.air.framework");
        airCommonFramework.setArtifactId("common-framework");
        airCommonFramework.setVersion(airVersion);
        airCommonFramework.setPackaging("pom");
        airFramework.getDependencies().add(airCommonFramework);

        final File pomFile = new File(targetDirectory, "air-framework/" + sdkVersion +
                "/air-framework-" + sdkVersion + ".pom");
        generateSwcPom(pomFile, airFramework);
    }

    protected void writeDummyResourceBundleSwc(final File targetFile) throws Exception {
		final ZipOutputStream out = new ZipOutputStream(new FileOutputStream(targetFile));
		out.putNextEntry(new ZipEntry("dummy"));
		out.closeEntry();
		out.close();
    }

    private void generateThemeArtifacts(File themesDirectory, File targetDirectory, String sdkVersion, boolean isApache)
            throws Exception {
        final File[] themes = themesDirectory.listFiles();
        if(themes != null) {
            for(final File themeDirectory : themes) {
                if(themeDirectory.isDirectory()) {
                    final String themeName = themeDirectory.getName().toLowerCase();
                    final String themeVersion;
                    // If the theme name matches that of a normal artifact (such as spark),
                    // make sure the same version is used.
                    if(libraryVersions.containsKey(themeName)) {
                        themeVersion = libraryVersions.get(themeName);
                    } else {
                        themeVersion = sdkVersion;
                    }
                    final File themeFile = new File(themeDirectory, themeName + ".swc");

                    final File targetThemesDirectory = new File(targetDirectory, "themes");
                    final File targetThemeDirectory = new File(targetThemesDirectory, themeName);
                    final File targetThemeVersionDirectory = new File(targetThemeDirectory, themeVersion);

                    // Copy the SWC.
                    File targetSwcFile = new File(targetThemeVersionDirectory, themeName + "-" +
                            themeVersion + ".swc");

                    if(themeFile.exists()) {
                        if(!targetThemeVersionDirectory.mkdirs()) {
                            throw new RuntimeException("Could not create directory: " +
                                    targetThemeDirectory.getAbsolutePath());
                        }
                        copyFile(themeFile, targetSwcFile);
                    } else {
                        targetSwcFile = generateThemeSwc(themeDirectory, targetSwcFile);
                    }

                    if(targetSwcFile != null) {
                        // Generate the pom file.
                        final MavenMetadata themeMetadata = new MavenMetadata();
                        themeMetadata.setGroupId(
                                (isApache) ? "org.apache.flex.framework.themes" : "com.adobe.flex.framework.themes");
                        themeMetadata.setArtifactId(themeName);
                        themeMetadata.setVersion(themeVersion);
                        themeMetadata.setPackaging("swc");
                        generateSwcPom(targetSwcFile, themeMetadata);
                    }
                }
            }
        }
    }

    private File generateThemeSwc(File themeDirectory, File targetFile) throws Exception {

	    final File fdkHomeDir = themeDirectory.getParentFile().getParentFile().getParentFile();
        final File fdkLibDir = new File(fdkHomeDir, "lib");

	    List<String> processCmd = new ArrayList<String>(10);

        if(fdkLibDir.exists() && fdkLibDir.isDirectory()) {
            final File compcLibrary = new File(fdkLibDir, "compc.jar");
            final File frameworkDir = new File(fdkHomeDir, "frameworks");

	        processCmd.add("java");
	        processCmd.add("-Xmx384m");
	        processCmd.add("-Dsun.io.useCanonCaches=false");
	        processCmd.add("-jar");
	        processCmd.add(compcLibrary.getCanonicalPath());
	        processCmd.add("+flexlib=" + frameworkDir.getCanonicalPath());

            // Add all the content files.
            final File contents[] = themeDirectory.listFiles(new FileFilter() {
                @Override
                public boolean accept(File pathname) {
                    return !(pathname.isDirectory() && "src".equals(pathname.getName())) &&
                            !"preview.jpg".equals(pathname.getName()) && !pathname.getName().endsWith(".fla");
                }
            });
            if(contents.length == 0) {
                return null;
            }

            for(final File resource : contents) {
	            processCmd.add("-include-file");
			    processCmd.add(resource.getName());
	            processCmd.add(resource.getCanonicalPath());
            }

            // Define the output file.
	        processCmd.add("-o");
	        processCmd.add(targetFile.getCanonicalPath());

            final File targetDirectory = targetFile.getParentFile();
            if(targetDirectory.exists()) {
                if(!targetDirectory.mkdirs()) {
                    throw new RuntimeException("Could not create directory: " + targetDirectory.getCanonicalPath());
                }
            }

            // Execute the command.
            try {
                System.out.println("Geneating theme '" + themeDirectory.getName() + "'");

                //final Process child = Runtime.getRuntime().exec(cmd.toString(), envps);
	            ProcessBuilder processBuilder = new ProcessBuilder(processCmd);
	            processBuilder.environment().put("PLAYERGLOBAL_HOME", new File(new File(themeDirectory.getParentFile().getParentFile(), "libs"), "player").getCanonicalPath());
	            int exitValue = exec(processBuilder.start());
                if(exitValue != 0) {
                    System.out.println("Couldn't create theme swc");
                    System.out.println("----------------------------------------------------------------");
                    System.out.println("Env: '" + processBuilder.environment().get("PLAYERGLOBAL_HOME") + "'");
	                System.out.println(processBuilder.command());
                    System.out.println("----------------------------------------------------------------");
                }
            } catch(Exception e) {
                e.printStackTrace();
            }

            // Return a reference on the theme swc.
            return targetFile;
        }
        return null;
    }

	private int exec(Process p) throws InterruptedException, IOException {
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

    private void createConfigsZip(File sdkSourceDirectory) throws Exception {
        // ZIP up every file (not directory) in the framework directory and the entire themes directory.
        final File sourceFiles[] = sdkSourceDirectory.listFiles(new FileFilter() {
            public boolean accept(File pathname) {
                return pathname.isFile();
            }
        });
        final File zipInputFiles[] = new File[sourceFiles.length];
        System.arraycopy(sourceFiles, 0, zipInputFiles, 0, sourceFiles.length);

        // Add all the content to a zip-file.
        final File targetFile = new File(libraryLocations.get("framework"), "framework-" +
                libraryVersions.get("framework") + "-configs.zip");
        final ZipOutputStream zipOutputStream = new ZipOutputStream(new FileOutputStream(targetFile));
        for (final File file : zipInputFiles) {
            addFileToZip(zipOutputStream, file, sdkSourceDirectory);
        }
        zipOutputStream.close();
    }

    protected String getMinimumPlayerVersion(File frameworksDirectory) {
        final File flexConfigFile = new File(frameworksDirectory, "flex-config.xml");

        final DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        try {
            final DocumentBuilder db = dbf.newDocumentBuilder();
            final Document dom = db.parse(flexConfigFile);

            final Element root = dom.getDocumentElement();
            final NodeList targetPlayerElements = root.getElementsByTagName("target-player");
            if(targetPlayerElements.getLength() == 0) {
                return "9.0";
            } else {
                final String version = targetPlayerElements.item(0).getTextContent();
                final String[] versionFragments = version.split("\\.");
                return versionFragments[0] + "." + versionFragments[1];
            }
        } catch (ParserConfigurationException pce) {
            throw new RuntimeException(pce);
        } catch (SAXException se) {
            throw new RuntimeException(se);
        } catch (IOException ioe) {
            throw new RuntimeException(ioe);
        }
    }

    private void addFileToZip(ZipOutputStream zipOutputStream, File inputFile, File rootDirectory) throws Exception {
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
        }
    }
}
