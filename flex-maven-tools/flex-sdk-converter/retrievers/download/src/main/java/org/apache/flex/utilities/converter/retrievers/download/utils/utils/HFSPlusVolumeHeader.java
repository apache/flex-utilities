package org.apache.flex.utilities.converter.retrievers.download.utils.utils;

import java.io.DataInputStream;
import java.io.IOException;
import java.util.Arrays;

/**
 * http://www.dubeyko.com/development/FileSystems/HFSPLUS/hexdumps/hfsplus_volume_header.html
 *
 * Created by christoferdutz on 24.02.16.
 */
public class HFSPlusVolumeHeader implements IHFSVolumeHeader {

    private short version;
    private int attributes;
    private int lastMountedVersion;
    private int journalInfoBlock;

    private int createDate;
    private int modifyDate;
    private int backupDate;
    private int checkedDate;

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

    private byte[] finderInfo;

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

            createDate = dis.readInt();
            modifyDate = dis.readInt();
            backupDate = dis.readInt();
            checkedDate = dis.readInt();

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

            finderInfo = new byte[32];
            dis.read(finderInfo);

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

    public int getLastMountedVersion() {
        return lastMountedVersion;
    }

    public int getJournalInfoBlock() {
        return journalInfoBlock;
    }

    public int getCreateDate() {
        return createDate;
    }

    public int getModifyDate() {
        return modifyDate;
    }

    public int getBackupDate() {
        return backupDate;
    }

    public int getCheckedDate() {
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

    public byte[] getFinderInfo() {
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
                ", finderInfo=" + Arrays.toString(finderInfo) +
                ", allocationFile=" + allocationFile +
                ", extentsFile=" + extentsFile +
                ", catalogFile=" + catalogFile +
                ", attributesFile=" + attributesFile +
                ", startupFile=" + startupFile +
                '}';
    }
}
