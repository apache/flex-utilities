package org.apache.flex.utilities.converter.retrievers.download.utils.utils;

import org.apache.flex.utilities.converter.retrievers.download.utils.DmgExtractor;

import java.io.DataInputStream;
import java.io.IOException;

/**
 * https://en.wikipedia.org/wiki/Apple_Partition_Map
 *
 * Created by christoferdutz on 25.02.16.
 */
public class ApplePartitionMap {

    public static int STATUS_ENTRY_IS_VALID                             = 0x00000001;
    public static int STATUS_ENTRY_IS_ALLOCATED                         = 0x00000002;
    public static int STATUS_ENTRY_IN_USE                               = 0x00000004;
    public static int STATUS_ENTRY_CONTAINS_BOOT_INFORMATION            = 0x00000008;
    public static int STATUS_PARTITION_IS_READABLE                      = 0x00000010;
    public static int STATUS_PARTITION_IS_WRITABLE                      = 0x00000020;
    public static int STATUS_BOOT_CODE_IS_POSITION_INDEPENDENT          = 0x00000040;
    public static int STATUS_PARTITION_CONTAINS_CHAIN_COMPATIBLE_DRIVER = 0x00000100;
    public static int STATUS_PARTITION_CONTAINS_A_REAL_DRIVER           = 0x00000200;
    public static int STATUS_PARTITION_CONTAINS_A_CHAIN_DRIVER          = 0x00000400;
    public static int STATUS_AUTOMATICALLY_MOUNT_AT_STARTUP             = 0x40000000;
    public static int STATUS_THE_STARTUP_PARTITION                      = 0x80000000;

    private int numPartitions;
    private int startingSectorOfPartition;
    private int sizeOfPartitionInSectors;
    private String nameOfPartition;
    private String typeOfPartition;
    private int startingSectorOfDataAreaInPartition;
    private int sizeOfDataAreaInPartitionInSectors;
    private int statusOfPartition;
    private int startingSectorOfBootCode;
    private int sizeOfBootCodeInSectors;
    private int addressOfBootloaderCode;
    private int bootCodeEntryPoint;
    private int bootCodeChecksum;
    private String processorType;

    public ApplePartitionMap(DataInputStream dis) {
        // Initialize the fields by parsing the input bytes.
        try {
            if(dis.readShort() != 0x504D) {
                throw new IllegalArgumentException("Invalid ApplePartitionMap data. Expected magic number 0x504D");
            }
            dis.skipBytes(2);
            numPartitions = dis.readInt();
            startingSectorOfPartition = dis.readInt();
            sizeOfPartitionInSectors = dis.readInt();
            byte[] buffer = new byte[32];
            dis.read(buffer);
            nameOfPartition = DmgExtractor.getStringFromZeroTerminatedByteArray(buffer);
            buffer = new byte[32];
            dis.read(buffer);
            typeOfPartition = DmgExtractor.getStringFromZeroTerminatedByteArray(buffer);
            startingSectorOfDataAreaInPartition = dis.readInt();
            sizeOfDataAreaInPartitionInSectors = dis.readInt();
            statusOfPartition = dis.readInt();
            startingSectorOfBootCode = dis.readInt();
            sizeOfBootCodeInSectors = dis.readInt();
            addressOfBootloaderCode = dis.readInt();
            dis.skipBytes(4);
            bootCodeEntryPoint = dis.readInt();
            dis.skipBytes(4);
            bootCodeChecksum = dis.readInt();
            buffer = new byte[16];
            dis.read(buffer);
            processorType = DmgExtractor.getStringFromZeroTerminatedByteArray(buffer);
            dis.skipBytes(376);
        } catch (IOException e) {
            throw new IllegalArgumentException("Invalid DmgPropertyListMishBlock data.");
        }
    }

    public int getNumPartitions() {
        return numPartitions;
    }

    public int getStartingSectorOfPartition() {
        return startingSectorOfPartition;
    }

    public int getSizeOfPartitionInSectors() {
        return sizeOfPartitionInSectors;
    }

    public String getNameOfPartition() {
        return nameOfPartition;
    }

    public String getTypeOfPartition() {
        return typeOfPartition;
    }

    public int getStartingSectorOfDataAreaInPartition() {
        return startingSectorOfDataAreaInPartition;
    }

    public int getSizeOfDataAreaInPartitionInSectors() {
        return sizeOfDataAreaInPartitionInSectors;
    }

    public int getStatusOfPartition() {
        return statusOfPartition;
    }

    public String getStatusOfPartitionName() {
        StringBuilder sb = new StringBuilder();
        if((statusOfPartition & STATUS_ENTRY_IS_VALID) != 0) {
            sb.append(", Entry is valid");
        }
        if((statusOfPartition & STATUS_ENTRY_IS_ALLOCATED) != 0) {
            sb.append(", Entry is allocated");
        }
        if((statusOfPartition & STATUS_ENTRY_IN_USE) != 0) {
            sb.append(", Entry in use");
        }
        if((statusOfPartition & STATUS_ENTRY_CONTAINS_BOOT_INFORMATION) != 0) {
            sb.append(", Entry contains boot information");
        }
        if((statusOfPartition & STATUS_PARTITION_IS_READABLE) != 0) {
            sb.append(", Partition is readable");
        }
        if((statusOfPartition & STATUS_PARTITION_IS_WRITABLE) != 0) {
            sb.append(", Partition is writable");
        }
        if((statusOfPartition & STATUS_BOOT_CODE_IS_POSITION_INDEPENDENT) != 0) {
            sb.append(", Boot code is position independent");
        }
        if((statusOfPartition & STATUS_PARTITION_CONTAINS_CHAIN_COMPATIBLE_DRIVER) != 0) {
            sb.append(", Partition contains chain-compatible driver");
        }
        if((statusOfPartition & STATUS_PARTITION_CONTAINS_A_REAL_DRIVER) != 0) {
            sb.append(", Partition contains a real driver");
        }
        if((statusOfPartition & STATUS_PARTITION_CONTAINS_A_CHAIN_DRIVER) != 0) {
            sb.append(", Partition contains a chain driver");
        }
        if((statusOfPartition & STATUS_AUTOMATICALLY_MOUNT_AT_STARTUP) != 0) {
            sb.append(", Automatically mount at startup");
        }
        if((statusOfPartition & STATUS_THE_STARTUP_PARTITION) != 0) {
            sb.append(", The startup partition");
        }
        if(sb.length() > 0) {
            return sb.toString().substring(2);
        }
        return "- none -";
    }

    public int getStartingSectorOfBootCode() {
        return startingSectorOfBootCode;
    }

    public int getSizeOfBootCodeInSectors() {
        return sizeOfBootCodeInSectors;
    }

    public int getAddressOfBootloaderCode() {
        return addressOfBootloaderCode;
    }

    public int getBootCodeEntryPoint() {
        return bootCodeEntryPoint;
    }

    public int getBootCodeChecksum() {
        return bootCodeChecksum;
    }

    public String getProcessorType() {
        return processorType;
    }

    @Override
    public String toString() {
        return "ApplePartitionMap{" +
                "numPartitions=" + numPartitions +
                ", startingSectorOfPartition=" + startingSectorOfPartition +
                ", sizeOfPartitionInSectors=" + sizeOfPartitionInSectors +
                ", nameOfPartition='" + nameOfPartition + '\'' +
                ", typeOfPartition='" + typeOfPartition + '\'' +
                ", startingSectorOfDataAreaInPartition=" + startingSectorOfDataAreaInPartition +
                ", sizeOfDataAreaInPartitionInSectors=" + sizeOfDataAreaInPartitionInSectors +
                ", statusOfPartition=" + statusOfPartition +
                ", startingSectorOfBootCode=" + startingSectorOfBootCode +
                ", sizeOfBootCodeInSectors=" + sizeOfBootCodeInSectors +
                ", addressOfBootloaderCode=" + addressOfBootloaderCode +
                ", bootCodeEntryPoint=" + bootCodeEntryPoint +
                ", bootCodeChecksum=" + bootCodeChecksum +
                ", processorType='" + processorType + '\'' +
                '}';
    }
}
