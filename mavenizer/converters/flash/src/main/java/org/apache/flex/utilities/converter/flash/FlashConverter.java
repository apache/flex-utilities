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
package org.apache.flex.utilities.converter.flash;

import org.apache.commons.compress.archivers.ArchiveEntry;
import org.apache.commons.compress.archivers.tar.TarArchiveInputStream;
import org.apache.commons.compress.compressors.gzip.GzipCompressorInputStream;
import org.apache.flex.utilities.converter.BaseConverter;
import org.apache.flex.utilities.converter.Converter;
import org.apache.flex.utilities.converter.exceptions.ConverterException;
import org.apache.flex.utilities.converter.model.MavenArtifact;

import java.io.*;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;

/**
 * Created by cdutz on 22.04.2014.
 */
public class FlashConverter extends BaseConverter implements Converter {

    /**
     * @param rootSourceDirectory Path to the root of the original Flash SDK.
     * @param rootTargetDirectory Path to the root of the directory where the Maven artifacts should be generated to.
     * @throws org.apache.flex.utilities.converter.exceptions.ConverterException
     */
    public FlashConverter(File rootSourceDirectory, File rootTargetDirectory) throws ConverterException {
        super(rootSourceDirectory, rootTargetDirectory);
    }

    /**
     * Entry point for generating the Maven artifacts for an Flash SDK.
     *
     * @throws ConverterException
     */
    @Override
    protected void processDirectory() throws ConverterException {
        if(!rootSourceDirectory.exists() || !rootSourceDirectory.isDirectory()) {
            throw new ConverterException("Flash SDK directory '" + rootSourceDirectory.getPath() + "' is invalid.");
        }

        generateRuntimeArtifacts();
        generateFrameworkArtifacts();
    }

    /**
     * This method generates those artifacts that resemble the runtime part of the Flash SDK.
     *
     * @throws ConverterException
     */
    protected void generateRuntimeArtifacts() throws ConverterException {
        // Create a list of all libs that should belong to the Flash SDK runtime.
        final File directory = new File(rootSourceDirectory, "runtimes" + File.separator + "player");
        if(!directory.exists() || !directory.isDirectory()) {
            System.out.println("Skipping runtime generation.");
            return;
        }
        final List<File> playerVersions = new ArrayList<File>();
        playerVersions.addAll(Arrays.asList(directory.listFiles(new FlashRuntimeFilter())));

        // In really old SDKs the flash-player was installed in the players directory directly.
        if(new File(directory, "win").exists()) {
            playerVersions.add(directory);
        }

        // Generate artifacts for every jar in the input directories.
        for(final File versionDir : playerVersions) {
            // The flash-player 9 is installed directly in the player directory.
            String playerVersionString;
            if(versionDir == directory) {
                playerVersionString = "9.0";
            } else {
                playerVersionString = versionDir.getName();
            }

            final double playerVersion = Double.valueOf(playerVersionString);
            final NumberFormat doubleFormat = NumberFormat.getInstance(Locale.US);
            doubleFormat.setMinimumFractionDigits(1);
            doubleFormat.setMaximumFractionDigits(1);
            final String version = doubleFormat.format(playerVersion);

            final MavenArtifact playerArtifact = new MavenArtifact();
            playerArtifact.setGroupId("com.adobe.flash");
            playerArtifact.setArtifactId("runtime");
            playerArtifact.setVersion(version);
            playerArtifact.setPackaging("exe");

            // Deploy Windows binaries.
            final File windowsDirectory = new File(versionDir, "win");
            if(windowsDirectory.exists()) {
                // Find out if a flash-player binary exists.
                File flashPlayerBinary = null;
                if(new File(windowsDirectory, "FlashPlayerDebugger.exe").exists()) {
                    flashPlayerBinary = new File(windowsDirectory, "FlashPlayerDebugger.exe");
                } else if(new File(windowsDirectory, "FlashPlayer.exe").exists()) {
                    flashPlayerBinary = new File(windowsDirectory, "FlashPlayer.exe");
                }

                // If a binary exists, copy it to the target and create a pom for it.
                if (flashPlayerBinary != null) {
                    playerArtifact.addBinaryArtifact("win", flashPlayerBinary);
                }
            }

            // Deploy Mac binaries.
            final File macDirectory = new File(versionDir, "mac");
            if(macDirectory.exists()) {
                // Find out if a flash-player binary exists.
                File flashPlayerBinary = null;
                if(new File(macDirectory, "Flash Player.app.zip").exists()) {
                    flashPlayerBinary = new File(macDirectory, "Flash Player.app.zip");
                } else if(new File(macDirectory, "Flash Player Debugger.app.zip").exists()) {
                    flashPlayerBinary = new File(macDirectory, "Flash Player Debugger.app.zip");
                }

                // If a binary exists, copy it to the target and create a pom for it.
                if (flashPlayerBinary != null) {
                    playerArtifact.addBinaryArtifact("mac", flashPlayerBinary);
                }
            }

            // Deploy Linux binaries.
            final File lnxDirectory = new File(versionDir, "lnx");
            if(lnxDirectory.exists()) {
                // Find out if a flash-player binary exists.
                File flashPlayerBinary;
                if(new File(lnxDirectory, "flashplayer.tar.gz").exists()) {
                    flashPlayerBinary = new File(lnxDirectory, "flashplayer.tar.gz");
                } else if(new File(lnxDirectory, "flashplayerdebugger.tar.gz").exists()) {
                    flashPlayerBinary = new File(lnxDirectory, "flashplayerdebugger.tar.gz");
                } else {
                    throw new ConverterException("Couldn't find player archive.");
                }

                // Decompress the archive.
                // First unzip it.
                final FileInputStream fin;
                try {
                    fin = new FileInputStream(flashPlayerBinary);
                    final BufferedInputStream in = new BufferedInputStream(fin);
                    final File tempTarFile = File.createTempFile("flex-sdk-linux-flashplayer-binary-" + version, ".tar");
                    final FileOutputStream out = new FileOutputStream(tempTarFile);
                    final GzipCompressorInputStream gzIn = new GzipCompressorInputStream(in);
                    final byte[] buffer = new byte[1024];
                    int n;
                    while (-1 != (n = gzIn.read(buffer))) {
                        out.write(buffer, 0, n);
                    }
                    out.close();
                    gzIn.close();

                    // Then untar it.
                    File uncompressedBinary = null;
                    final FileInputStream tarFileInputStream = new FileInputStream(tempTarFile);
                    final TarArchiveInputStream tarArchiveInputStream = new TarArchiveInputStream(tarFileInputStream);
                    ArchiveEntry entry;
                    while((entry = tarArchiveInputStream.getNextEntry()) != null) {
                        if("flashplayer".equals(entry.getName())) {
                            uncompressedBinary = File.createTempFile("flex-sdk-linux-flashplayer-binary-" + version, ".uexe");
                            final FileOutputStream uncompressedBinaryOutputStream = new FileOutputStream(uncompressedBinary);
                            while(-1 != (n = tarArchiveInputStream.read(buffer))) {
                                uncompressedBinaryOutputStream.write(buffer, 0, n);
                            }
                            uncompressedBinaryOutputStream.close();
                        } else if("flashplayerdebugger".equals(entry.getName())) {
                            uncompressedBinary = File.createTempFile("flex-sdk-linux-flashplayer-binary-" + version, ".uexe");
                            final FileOutputStream uncompressedBinaryOutputStream = new FileOutputStream(uncompressedBinary);
                            while(-1 != (n = tarArchiveInputStream.read(buffer))) {
                                uncompressedBinaryOutputStream.write(buffer, 0, n);
                            }
                            uncompressedBinaryOutputStream.close();
                        }
                    }
                    tarFileInputStream.close();

                    // If a binary exists, copy it to the target and create a pom for it.
                    if (uncompressedBinary != null) {
                        playerArtifact.addBinaryArtifact("linux", flashPlayerBinary);
                    }
                } catch (FileNotFoundException e) {
                    throw new ConverterException("Error processing the linux player tar file", e);
                } catch (IOException e) {
                    throw new ConverterException("Error processing the linux player tar file", e);
                }
            }

            // Write this artifact to file.
            writeArtifact(playerArtifact);
        }
    }

    /**
     * This method generates those artifacts that resemble the framework part of the Flash SDK.
     *
     * @throws ConverterException
     */
    protected void generateFrameworkArtifacts() throws ConverterException {
        // Create a list of all libs that should belong to the Flash SDK runtime.
        final File directory = new File(rootSourceDirectory, "frameworks.libs.player".replace(".", File.separator));
        if (!directory.exists() || !directory.isDirectory()) {
            throw new ConverterException("Runtime directory does not exist.");
        }
        final List<File> playerVersions = new ArrayList<File>();
        final File[] versions = directory.listFiles();
        if((versions != null) && (versions.length > 0)) {
            playerVersions.addAll(Arrays.asList(versions));

            // Generate artifacts for every jar in the input directories.
            for (final File versionDir : playerVersions) {
                final File playerglobalSwc = new File(versionDir, "playerglobal.swc");

                // Convert any version into a two-segment version number.
                final double playerVersion = Double.valueOf(versionDir.getName());
                final NumberFormat doubleFormat = NumberFormat.getInstance(Locale.US);
                doubleFormat.setMinimumFractionDigits(1);
                doubleFormat.setMaximumFractionDigits(1);
                final String version = doubleFormat.format(playerVersion);

                // Create an artifact for the player-global.
                final MavenArtifact playerglobal = new MavenArtifact();
                playerglobal.setGroupId("com.adobe.flash.framework");
                playerglobal.setArtifactId("playerglobal");
                playerglobal.setVersion(version);
                playerglobal.setPackaging("swc");
                playerglobal.addDefaultBinaryArtifact(playerglobalSwc);
                writeArtifact(playerglobal);
            }
        }
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////
    //
    //   Utility methods
    //
    ///////////////////////////////////////////////////////////////////////////////////////////////////

    public static class FlashRuntimeFilter implements FileFilter {
        public boolean accept(File pathname) {
            return pathname.isDirectory() && !"win".equalsIgnoreCase(pathname.getName()) &&
                    !"lnx".equalsIgnoreCase(pathname.getName()) && !"mac".equalsIgnoreCase(pathname.getName());
        }
    }

    public static class FlashFrameworkFilter implements FilenameFilter {
        public boolean accept(File dir, String name) {
            return name.equals("playerglobal.swc");
        }
    }

    public static void main(String[] args) throws Exception {
        FlashConverter converter = new FlashConverter(new File(args[0]), new File(args[1]));
        converter.convert();
    }

}
