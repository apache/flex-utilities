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
import org.apache.commons.compress.archivers.ArchiveEntry;
import org.apache.commons.compress.archivers.tar.TarArchiveInputStream;
import org.apache.commons.compress.compressors.gzip.GzipCompressorInputStream;

import java.io.*;
import java.text.NumberFormat;
import java.util.Locale;

/**
 * Created with IntelliJ IDEA.
 * User: cdutz
 * Date: 14.05.12
 * Time: 22:42
 */
public class FlexRuntimeGenerator extends BaseGenerator {

    @Override
    public void process(File sdkSourceDirectory, boolean isApache, File sdkTargetDirectory, String sdkVersion,
                        boolean useApache)
            throws Exception
    {
        processFlashRuntime(sdkSourceDirectory, sdkTargetDirectory);
    }

    protected void processFlashRuntime(File sdkSourceDirectory, File sdkTargetDirectory)
            throws Exception
    {
        final File runtimeDirectory = new File(sdkSourceDirectory, "runtimes");
        final File flashPlayerDirectory = new File(runtimeDirectory, "player");

        File[] versions = flashPlayerDirectory.listFiles(new FileFilter() {
            public boolean accept(File pathname) {
                return pathname.isDirectory() && !"win".equalsIgnoreCase(pathname.getName()) &&
                        !"lnx".equalsIgnoreCase(pathname.getName()) && !"mac".equalsIgnoreCase(pathname.getName());
            }
        });
        // The flash-player 9 is installed directly in the player directory.
        if(new File(flashPlayerDirectory, "win").exists()) {
            final File[] extendedVersions = new File[versions.length + 1];
            System.arraycopy(versions, 0, extendedVersions, 0, versions.length);
            extendedVersions[versions.length] = flashPlayerDirectory;
            versions = extendedVersions;
        }

        if(versions != null) {
            for(final File versionDir : versions) {
                // If the versionDir is called "player", then this is the home of the flash-player version 9.
                final String playerVersionString = "player".equalsIgnoreCase(versionDir.getName()) ? "9.0" : versionDir.getName();
                final double playerVersion = Double.valueOf(playerVersionString);
                final NumberFormat doubleFormat = NumberFormat.getInstance(Locale.US);
                doubleFormat.setMinimumFractionDigits(1);
                doubleFormat.setMaximumFractionDigits(1);
                final String version = doubleFormat.format(playerVersion);

                final File targetDir = new File(sdkTargetDirectory, "com/adobe/flash/runtime/" + version);

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
                        if(!targetDir.exists()) {
                            if(!targetDir.mkdirs()) {
                                throw new RuntimeException("Could not create directory: " + targetDir.getAbsolutePath());
                            }
                        }
                        final File targetFile = new File(targetDir, "/runtime-" + version + "-win.exe");
                        copyFile(flashPlayerBinary, targetFile);
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
                        if(!targetDir.exists()) {
                            if(!targetDir.mkdirs()) {
                                throw new RuntimeException("Could not create directory: " + targetDir.getAbsolutePath());
                            }
                        }
                        final File targetFile = new File(targetDir, "/runtime-" + version + "-mac.zip");
                        copyFile(flashPlayerBinary, targetFile);
                    }
                }

                // Deploy Linux binaries.
                final File lnxDirectory = new File(versionDir, "lnx");
                if(lnxDirectory.exists()) {
                    // Find out if a flash-player binary exists.
                    File flashPlayerBinary = null;
                    if(new File(lnxDirectory, "flashplayer.tar.gz").exists()) {
                        flashPlayerBinary = new File(lnxDirectory, "flashplayer.tar.gz");
                    } else if(new File(lnxDirectory, "flashplayerdebugger.tar.gz").exists()) {
                        flashPlayerBinary = new File(lnxDirectory, "flashplayerdebugger.tar.gz");
                    }

                    // Decompress the archive.
                    // First unzip it.
                    final FileInputStream fin = new FileInputStream(flashPlayerBinary);
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
                        if(!targetDir.exists()) {
                            if(!targetDir.mkdirs()) {
                                throw new RuntimeException("Could not create directory: " + targetDir.getAbsolutePath());
                            }
                        }
                        final File targetFile = new File(targetDir, "/runtime-" + version + "-linux.uexe");
                        copyFile(uncompressedBinary, targetFile);

                        // Clean up in the temp directory.
                        if(!uncompressedBinary.delete()) {
                            System.out.println("Could not delete: " + uncompressedBinary.getAbsolutePath());
                        }
                    }

                    // Clean up in the temp directory.
                    if(!tempTarFile.delete()) {
                        System.out.println("Could not delete: " + tempTarFile.getAbsolutePath());
                    }
                }

                final MavenMetadata playerArtifact = new MavenMetadata();
                playerArtifact.setGroupId("com.adobe.flash");
                playerArtifact.setArtifactId("runtime");
                playerArtifact.setVersion(version);
                playerArtifact.setPackaging("exe");

                writeDocument(createPomDocument(playerArtifact), new File(targetDir, "runtime-" + version + ".pom"));
            }
        }
    }
}
