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
package org.apache.flex.utilities.converter.retrievers.download.utils.utils;

import java.io.DataInputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.Date;

/**
 * http://www.dubeyko.com/development/FileSystems/HFSPLUS/hexdumps/hfsplus_volume_header.html
 * http://dubeiko.com/development/FileSystems/HFSPLUS/tn1150.html
 * http://dubeyko.com/development/FileSystems/HFSPLUS/tn1150.html#CatalogFile
 *
 * Created by christoferdutz on 24.02.16.
 */
public class HFSPlusVolumeHeader implements IHFSVolumeHeader {

    private static final int VOLUME_UNMOUNTED = 0x0100;
    private static final int VOLUME_SPARED_BLOCKS = 0x0200;
    private static final int VOLUME_NOCACHE_REQUIRED = 0x0400;
    private static final int BOOT_VOLUME_INCONSISTENT = 0x0800;
    private static final int CATALOG_NODE_IDS_REUSED = 0x1000;
    private static final int VOLUME_JOURNALED = 0x2000;
    private static final int VOLUME_SOFTWARE_LOCK= 0x8000;

    private static final long UNSIGNED_INT_BITS = 0xFFFFFFFFL;
    private static final long CONVERT_MAC_TO_JAVA_TIME = 2082880800L;

    private short version;
    private int attributes;
    private int lastMountedVersion;
    private int journalInfoBlock;

    private Date createDate;
    private Date modifyDate;
    private Date backupDate;
    private Date checkedDate;

    private int fileCount;
    private int folderCount;

    private int blockSize;
    private int totalBlocks;
    private int freeBlocks;

    private int nextAllocation;
    private int rsrcClumpSize;
    private int nextCatalogID;
    private int dataClumpSize;

    private int writeCount;
    private long encodingsBitmap;

    private HFSPlusFinderInfo finderInfo;

    private HFSPlusForkData allocationFile;
    private HFSPlusForkData extentsFile;
    private HFSPlusForkData catalogFile;
    private HFSPlusForkData attributesFile;
    private HFSPlusForkData startupFile;

    public HFSPlusVolumeHeader(DataInputStream dis) {
        try {
            version = dis.readShort();
            attributes = dis.readInt();
            lastMountedVersion = dis.readInt();
            journalInfoBlock = dis.readInt();

            createDate = readMacDate(dis);
            modifyDate = readMacDate(dis);
            backupDate = readMacDate(dis);
            checkedDate = readMacDate(dis);

            fileCount = dis.readInt();
            folderCount = dis.readInt();

            blockSize = dis.readInt();
            totalBlocks = dis.readInt();
            freeBlocks = dis.readInt();

            nextAllocation = dis.readInt();
            rsrcClumpSize = dis.readInt();
            dataClumpSize = dis.readInt();
            nextCatalogID = dis.readInt();

            writeCount = dis.readInt();
            encodingsBitmap = dis.readLong();

            finderInfo = new HFSPlusFinderInfo(dis);

            allocationFile = new HFSPlusForkData(dis);
            extentsFile = new HFSPlusForkData(dis);
            catalogFile = new HFSPlusForkData(dis);
            attributesFile = new HFSPlusForkData(dis);
            startupFile = new HFSPlusForkData(dis);
        } catch (IOException e) {
            throw new IllegalArgumentException("Invalid HFSPlusVolumeHeader data.");
        }
    }

    public short getVersion() {
        return version;
    }

    public int getAttributes() {
        return attributes;
    }

    /**
     * @return true if the volume was correctly flushed before being unmounted or ejected.
     */
    public boolean isVolumeUnmounted() {
        return (attributes & VOLUME_UNMOUNTED) != 0;
    }

    /**
     * @return true if there are any records in the extents overflow file for bad blocks
     * (belonging to file ID kHFSBadBlockFileID).
     */
    public boolean isSparedBlocks() {
        return (attributes & VOLUME_SPARED_BLOCKS) != 0;
    }

    /**
     * @return true if the blocks from this volume should not be cached.
     */
    public boolean isNoCacheRequired() {
        return (attributes & VOLUME_NOCACHE_REQUIRED) != 0;
    }

    /**
     * @return true if the volume was NOT correctly flushed before being unmounted or ejected.
     */
    public boolean isBootVolumeInconsistent() {
        return (attributes & BOOT_VOLUME_INCONSISTENT) != 0;
    }

    /**
     * @return true when the nextCatalogID field overflows 32 bits, forcing smaller catalog node
     * IDs to be reused. When this bit is set, it is common (and not an error) for catalog records
     * to exist with IDs greater than or equal to nextCatalogID.
     */
    public boolean isCatalogIdsReused() {
        return (attributes & CATALOG_NODE_IDS_REUSED) != 0;
    }

    /**
     * @return true if the volume has a journal.*2
     *
     */
    public boolean isVolumeJournaled() {
        return (attributes & VOLUME_JOURNALED) != 0;
    }

    /**
     * @return true if the volume is write-protected due to a software setting. Any implementations
     * must refuse to write to a volume with this bit set.
     */
    public boolean isVolumeSoftwareLocked() {
        return (attributes & VOLUME_SOFTWARE_LOCK) != 0;
    }

    public int getLastMountedVersion() {
        return lastMountedVersion;
    }

    public int getJournalInfoBlock() {
        return journalInfoBlock;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public Date getModifyDate() {
        return modifyDate;
    }

    public Date getBackupDate() {
        return backupDate;
    }

    public Date getCheckedDate() {
        return checkedDate;
    }

    public int getFileCount() {
        return fileCount;
    }

    public int getFolderCount() {
        return folderCount;
    }

    public int getBlockSize() {
        return blockSize;
    }

    public int getTotalBlocks() {
        return totalBlocks;
    }

    public int getFreeBlocks() {
        return freeBlocks;
    }

    public int getNextAllocation() {
        return nextAllocation;
    }

    public int getRsrcClumpSize() {
        return rsrcClumpSize;
    }

    public int getDataClumpSize() {
        return dataClumpSize;
    }

    public int getWriteCount() {
        return writeCount;
    }

    public long getEncodingsBitmap() {
        return encodingsBitmap;
    }

    public int getNextCatalogID() {
        return nextCatalogID;
    }

    public HFSPlusFinderInfo getFinderInfo() {
        return finderInfo;
    }

    public HFSPlusForkData getAllocationFile() {
        return allocationFile;
    }

    public HFSPlusForkData getExtentsFile() {
        return extentsFile;
    }

    public HFSPlusForkData getCatalogFile() {
        return catalogFile;
    }

    public HFSPlusForkData getAttributesFile() {
        return attributesFile;
    }

    public HFSPlusForkData getStartupFile() {
        return startupFile;
    }

    /**
     * Convert the dates saved as HFS+ date (32 bit integer representing the number
     * of seconds since 01.01.1994) to java dates.
     * @param dis input stream to read from.
     * @return Date in Java representation (number of milliseconds since 01.01.1970)
     * @throws IOException something went wrong.
     */
    private Date readMacDate(DataInputStream dis) throws IOException {
        return new Date(((UNSIGNED_INT_BITS & dis.readInt()) - CONVERT_MAC_TO_JAVA_TIME) * 1000);
    }

    @Override
    public String toString() {
        return "HFSPlusVolumeHeader{" +
                "version=" + version +
                ", attributes=" + attributes +
                ", lastMountedVersion=" + lastMountedVersion +
                ", journalInfoBlock=" + journalInfoBlock +
                ", createDate=" + createDate +
                ", modifyDate=" + modifyDate +
                ", backupDate=" + backupDate +
                ", checkedDate=" + checkedDate +
                ", fileCount=" + fileCount +
                ", folderCount=" + folderCount +
                ", blockSize=" + blockSize +
                ", totalBlocks=" + totalBlocks +
                ", freeBlocks=" + freeBlocks +
                ", nextAllocation=" + nextAllocation +
                ", rsrcClumpSize=" + rsrcClumpSize +
                ", nextCatalogID=" + nextCatalogID +
                ", dataClumpSize=" + dataClumpSize +
                ", writeCount=" + writeCount +
                ", encodingsBitmap=" + encodingsBitmap +
                ", finderInfo=" + finderInfo +
                ", allocationFile=" + allocationFile +
                ", extentsFile=" + extentsFile +
                ", catalogFile=" + catalogFile +
                ", attributesFile=" + attributesFile +
                ", startupFile=" + startupFile +
                '}';
    }
}
