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
package org.apache.flex.utilities.converter.retrievers;

import org.apache.commons.compress.archivers.ArchiveEntry;
import org.apache.commons.compress.archivers.ArchiveException;
import org.apache.commons.compress.archivers.ArchiveInputStream;
import org.apache.commons.compress.archivers.ArchiveStreamFactory;
import org.apache.commons.compress.archivers.tar.TarArchiveInputStream;
import org.apache.commons.compress.compressors.bzip2.BZip2CompressorInputStream;
import org.apache.commons.compress.utils.CountingInputStream;
import org.apache.flex.utilities.converter.retrievers.exceptions.RetrieverException;
import org.apache.flex.utilities.converter.retrievers.utils.ProgressBar;

import java.io.*;

/**
 * Created by cdutz on 18.05.2014.
 */
public abstract class BaseRetriever implements Retriever {

    public static final int KILOBYTE = 1024;
    public static final int MEGABYTE = KILOBYTE * 1024;
    public static final int BUFFER_MAX = MEGABYTE;

    protected void unpack(File inputArchive, File targetDirectory) throws RetrieverException {
        if (!targetDirectory.mkdirs()) {
            throw new RetrieverException(
                    "Unable to create extraction directory " + targetDirectory.getAbsolutePath());
        }

        ArchiveInputStream archiveInputStream = null;
        ArchiveEntry entry;
        try {

            final CountingInputStream inputStream = new CountingInputStream(new FileInputStream(inputArchive));

            final long inputFileSize = inputArchive.length();

            if(inputArchive.getName().endsWith(".tbz2")) {
                archiveInputStream = new TarArchiveInputStream(
                        new BZip2CompressorInputStream(inputStream));
            } else {
                archiveInputStream = new ArchiveStreamFactory().createArchiveInputStream(
                        new BufferedInputStream(inputStream));
            }

            final ProgressBar progressBar = new ProgressBar(inputFileSize);
            while ((entry = archiveInputStream.getNextEntry()) != null) {
                final File outputFile = new File(targetDirectory, entry.getName());

                // Entry is a directory.
                if (entry.isDirectory()) {
                    if (!outputFile.exists()) {
                        if(!outputFile.mkdirs()) {
                            throw new RetrieverException(
                                    "Could not create output directory " + outputFile.getAbsolutePath());
                        }
                    }
                }

                // Entry is a file.
                else {
                    final byte[] data = new byte[BUFFER_MAX];
                    final FileOutputStream fos = new FileOutputStream(outputFile);
                    BufferedOutputStream dest = null;
                    try {
                        dest = new BufferedOutputStream(fos, BUFFER_MAX);

                        int count;
                        while ((count = archiveInputStream.read(data, 0, BUFFER_MAX)) != -1) {
                            dest.write(data, 0, count);
                            progressBar.updateProgress(inputStream.getBytesRead());
                        }
                    } finally {
                        if(dest != null) {
                            dest.flush();
                            dest.close();
                        }
                    }
                }

                progressBar.updateProgress(inputStream.getBytesRead());
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ArchiveException e) {
            e.printStackTrace();
        } finally {
            if(archiveInputStream != null) {
                try {
                    archiveInputStream.close();
                } catch(Exception e) {
                    // Ignore...
                }
            }
        }
    }

}
