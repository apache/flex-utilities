package org.apache.flex.utilities.converter.retrievers.download.utils.utils;

import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.IOException;

/**
 * Created by christoferdutz on 24.02.16.
 */
public class DmgTrailer {

    private int version;                // Current version is 4
    private int headerSize;             // sizeof(this), always 512
    private int flags;                  // Flags
    private long runningDataForkOffset; //
    private long dataForkOffset;        // Data fork offset (usually 0, beginning of file)
    private long dataForkLength;        // Size of data fork (usually up to the XMLOffset, below)
    private long rsrcForkOffset;        // Resource fork offset, if any
    private long rsrcForkLength;        // Resource fork length, if any
    private int segmentNumber;          // Usually 1, may be 0
    private int segmentCount;           // Usually 1, may be 0
    private byte[] segmentID;           // 128-bit (16 byte) GUID identifier of segment (if SegmentNumber !=0)

    private int dataChecksumType;       // Data fork
    private int dataChecksumSize;       //  Checksum Information
    private byte[] dataChecksum;        // Up to 128-bytes (32 x 4) of checksum

    private long xmlOffset;             // Offset of property list in DMG, from beginning
    private long xmlLength;             // Length of property list

    private int checksumType;           // Master
    private int checksumSize;           // Checksum information
    private byte[] checksum;            // Up to 128-bytes (32 x 4) of checksum

    private int imageVariant;           // Commonly 1
    private long sectorCount;           // Size of DMG when expanded, in sectors

    public DmgTrailer(byte[] data) {
        // Initialize the fields by parsing the input bytes.
        ByteArrayInputStream bis = new ByteArrayInputStream(data);
        DataInputStream dis = new DataInputStream(bis);
        try {
            dis.readInt();
            version = dis.readInt();
            headerSize = dis.readInt();
            flags = dis.readInt();
            runningDataForkOffset = dis.readLong();
            dataForkOffset = dis.readLong();
            dataForkLength = dis.readLong();
            rsrcForkOffset = dis.readLong();
            rsrcForkLength = dis.readLong();
            segmentNumber = dis.readInt();
            segmentCount = dis.readInt();
            segmentID = new byte[16];
            dis.read(segmentID, 0, 16);
            dataChecksumType = dis.readInt();
            dataChecksumSize = dis.readInt();
            dataChecksum = new byte[128];
            dis.read(dataChecksum, 0, 128);
            xmlOffset = dis.readLong();
            xmlLength = dis.readLong();
            byte[] reserved = new byte[120];
            dis.read(reserved, 0, 120);
            checksumType = dis.readInt();
            checksumSize = dis.readInt();
            checksum = new byte[120];
            dis.read(checksum, 0, 120);
            imageVariant = dis.readInt();
            sectorCount = dis.readLong();
        } catch (IOException e) {
            throw new IllegalArgumentException("Invalid DmgTrailer data.");
        }
    }

    public int getVersion() {
        return version;
    }

    public int getHeaderSize() {
        return headerSize;
    }

    public int getFlags() {
        return flags;
    }

    public long getRunningDataForkOffset() {
        return runningDataForkOffset;
    }

    public long getDataForkOffset() {
        return dataForkOffset;
    }

    public long getDataForkLength() {
        return dataForkLength;
    }

    public long getRsrcForkOffset() {
        return rsrcForkOffset;
    }

    public long getRsrcForkLength() {
        return rsrcForkLength;
    }

    public int getSegmentNumber() {
        return segmentNumber;
    }

    public int getSegmentCount() {
        return segmentCount;
    }

    public byte[] getSegmentID() {
        return segmentID;
    }

    public int getDataChecksumType() {
        return dataChecksumType;
    }

    public int getDataChecksumSize() {
        return dataChecksumSize;
    }

    public byte[] getDataChecksum() {
        return dataChecksum;
    }

    public long getXmlOffset() {
        return xmlOffset;
    }

    public long getXmlLength() {
        return xmlLength;
    }

    public int getChecksumType() {
        return checksumType;
    }

    public int getChecksumSize() {
        return checksumSize;
    }

    public byte[] getChecksum() {
        return checksum;
    }

    public int getImageVariant() {
        return imageVariant;
    }

    public long getSectorCount() {
        return sectorCount;
    }
}
