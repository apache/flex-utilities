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
import java.io.*;
import javax.xml.parsers.*;

import air.AirCompilerGenerator;
import common.ConversionPlan;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.SAXException;
import air.AirFrameworkGenerator;
import air.AirRuntimeGenerator;
import flex.FlexCompilerGenerator;
import flex.FlexFrameworkGenerator;
import flex.FlexRuntimeGenerator;

/**
 * Created with IntelliJ IDEA.
 * User: cdutz
 * Date: 11.05.12
 * Time: 12:03
 */
public class SDKGenerator {

    protected void buildAirConversionPlan(ConversionPlan plan, File sdkSourceDirectory) {
        final File sdkDirectories[] = sdkSourceDirectory.listFiles(new FileFilter() {
            public boolean accept(File pathname) {
                return pathname.isDirectory();
            }
        });
        if (sdkDirectories != null) {
            for (final File sdkDirectory : sdkDirectories) {
                final String sdkVersion = getAirSdkVersion(sdkDirectory);
                if(sdkVersion != null) {
                    plan.addVersion(sdkVersion, sdkDirectory, false);
                }
            }
        }
    }

    /**
     * All this little helper does is list up all directories in the given base directory and
     * trigger the actual import on that. If a flex sdk comes with an air runtime, the structure
     * is identical to that of an ordinary air sdk. Therefore the import works if a flex sdk or
     * an air sdk directory is passed to this method.
     *
     * @param plan conversion plan for converting the air sdks containing the air content
     * @param sdkTargetDirectory directory where to copy the content
     * @throws Exception
     */
    public void generateAllAir(ConversionPlan plan, File sdkTargetDirectory) throws Exception {
        for(final String airVersion : plan.getVersionIterator()) {
            final File airDirectory = plan.getDirectory(airVersion);

            System.out.println("---------------------------------------------");
            System.out.println("-- Generating Air SDK version: " + airVersion);
            System.out.println("---------------------------------------------");

            generateAir(airDirectory, sdkTargetDirectory, airVersion);
        }
    }

    public void generateAir(final File sdkSourceDirectory, final File sdkTargetDirectory, final String sdkVersion) throws Exception {
        // Generate the artifacts, needed by the air compiler.
        new AirCompilerGenerator().process(sdkSourceDirectory, false, sdkTargetDirectory, sdkVersion, false);

        // Generate the artifacts, needed by the flex application.
        new AirFrameworkGenerator().process(sdkSourceDirectory, false, sdkTargetDirectory, sdkVersion, false);

        // Deploy the FlashPlayer and AIR runtime binaries.
        new AirRuntimeGenerator().process(sdkSourceDirectory, false, sdkTargetDirectory, sdkVersion, false);
    }

    protected void buildFlexConversionPlan(ConversionPlan plan, File sdkSourceDirectory) {
        final File sdkDirectories[] = sdkSourceDirectory.listFiles(new FileFilter() {
            public boolean accept(File pathname) {
                return pathname.isDirectory();
            }
        });
        if (sdkDirectories != null) {
            // Build a sorted set of versions as well as maps for the additional information
            // to allow sorted conversion of the Flex SDKs.
            for (final File sdkDirectory : sdkDirectories) {
                String fdkVersion = getFlexSdkVersion(sdkDirectory);
                // Apache FDKs have the version prefix "Apache-"
                // So this is what we use in order to determine what type of FDK it is.
                final boolean isApache = fdkVersion.startsWith("Apache-");
                if (isApache) {
                    fdkVersion = fdkVersion.substring("Apache-".length());
                }
                plan.addVersion(fdkVersion, sdkDirectory, isApache);
            }
        }
    }

    public void generateAllFlex(ConversionPlan plan, File sdkTargetDirectory, boolean useApache) throws Exception {
        for(final String fdkVersion : plan.getVersionIterator()) {
            final File fdkDirectory = plan.getDirectory(fdkVersion);
            final boolean isApache = plan.getApacheFlag(fdkVersion);

            System.out.println("---------------------------------------------");
            System.out.println("-- Generating Flex SDK version: " + fdkVersion);
            System.out.println("---------------------------------------------");

            generateFlex(fdkDirectory, isApache, sdkTargetDirectory, fdkVersion, useApache);
        }
    }

    public void generateFlex(final File sdkSourceDirectory, final boolean isApache, final File sdkTargetDirectory,
                             final String sdkVersion, final boolean useApache) throws Exception {
        // Generate the artifacts, needed by the flex compiler.
        new FlexCompilerGenerator().process(sdkSourceDirectory, isApache, sdkTargetDirectory, sdkVersion, useApache);

        // Generate the artifacts, needed by the flex application.
        new FlexFrameworkGenerator().process(sdkSourceDirectory, isApache, sdkTargetDirectory, sdkVersion, useApache);

        // Deploy the FlashPlayer and AIR runtime binaries.
        new FlexRuntimeGenerator().process(sdkSourceDirectory, isApache, sdkTargetDirectory, sdkVersion, useApache);
    }

    public static void main(String[] args) throws Exception {

        if (args.length != 3) {
            System.out.println("Usage: SDKGenerator {source-directory} {target-directory} {use-apache-gid}");
            System.exit(0);
        }

        final String sdkSourceDirectoryName = args[0];
        final String sdkTargetDirectoryName = args[1];
        final boolean useApache = Boolean.valueOf(args[2]);

        final File sdkSourceDirectory = new File(sdkSourceDirectoryName);
        final File sdkTargetDirectory = new File(sdkTargetDirectoryName);

        // When generating the fdks the generator tries to figure out the flashplayer-version and air-version
        // by comparing the hash of the playerglobal.swc and airglobal.swc with some hashes. This list of
        // hashes has to be created first. Therefore the Generator generates air artifacts by processing air
        // sdk directories and then by extracting the needed artifacts from the flex fdks.
        final SDKGenerator generator = new SDKGenerator();
        final ConversionPlan airPlan = new ConversionPlan();
        generator.buildAirConversionPlan(airPlan, new File(sdkSourceDirectory, "air"));
        generator.buildAirConversionPlan(airPlan, new File(sdkSourceDirectory, "flex"));
        generator.generateAllAir(airPlan, sdkTargetDirectory);

        // After the air artifacts are generated and
        final ConversionPlan flexPlan = new ConversionPlan();
        generator.buildFlexConversionPlan(flexPlan, new File(sdkSourceDirectory, "flex"));
        generator.generateAllFlex(flexPlan, sdkTargetDirectory, useApache);
    }

    /**
     * The only place I found where to extract the version of an Air SDK was the "AIR SDK Readme.txt" file.
     * In order to get the version we need to cut out the version-part from the title-row of that text file.
     * This file is present in the root of a pure air sdk or in the root of a flex sdk, therefore the same
     * algorithm works if sdkSourceDirectory points to a flex sdk or an air sdk.
     *
     * @param sdkSourceDirectory directory in which to look for the sdk descriptor file of an air sdk
     * @return version of the sdk in th given directory
     */
    public static String getAirSdkVersion(final File sdkSourceDirectory) {
        final File sdkDescriptor = new File(sdkSourceDirectory, "AIR SDK Readme.txt");

        if (sdkDescriptor.exists()) {
            DataInputStream in = null;
            try {
                final FileInputStream fstream = new FileInputStream(sdkDescriptor);
                in = new DataInputStream(fstream);
                final BufferedReader br = new BufferedReader(new InputStreamReader(in));
                final String strLine = br.readLine();
                return strLine.substring("Adobe AIR ".length(), strLine.indexOf(" ", "Adobe AIR ".length()));
            } catch (Exception e) {
                e.printStackTrace();
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
        return null;
    }

    /**
     * The Flex SDK version is contained in the flex-sdk-description.xml file.
     *
     * @param sdkSourceDirectory directory where to look for the fdk descriptor file
     * @return version string of the fdk
     */
    public static String getFlexSdkVersion(final File sdkSourceDirectory) {
        final File sdkDescriptor = new File(sdkSourceDirectory, "flex-sdk-description.xml");

        final DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        try {
            // Parse the document
            final DocumentBuilder db = dbf.newDocumentBuilder();
            final Document dom = db.parse(sdkDescriptor);

            // Get name, version and build nodes
            final Element root = dom.getDocumentElement();
            final String name = root.getElementsByTagName("name").item(0).getTextContent();
            final String version = root.getElementsByTagName("version").item(0).getTextContent();
            final String build = root.getElementsByTagName("build").item(0).getTextContent();

            // In general the version consists of the content of the version element with an appended build-number.
            String sdkVersion = (build.equals("0")) ? version + "-SNAPSHOT" : version + "." + build;

            // Deal with the patched re-releases of all older SDKs:
            // The patched versions have A or B appended to their name and not a modified version or build number.
            // In order to differentiate the patched versions from the un-patched ones, we appnd A or B to the
            // version string.
            if (name.endsWith("A")) {
                sdkVersion += "A";
            } else if (name.endsWith("B")) {
                sdkVersion += "B";
            }

            // If the name contains "Apache", we prefix the version with "Apache-". This is cut off
            // again later on.
            if (name.contains("Apache")) {
                sdkVersion = "Apache-" + sdkVersion;
            }

            return sdkVersion;
        } catch (ParserConfigurationException pce) {
            throw new RuntimeException(pce);
        } catch (SAXException se) {
            throw new RuntimeException(se);
        } catch (IOException ioe) {
            throw new RuntimeException(ioe);
        }
    }
}
