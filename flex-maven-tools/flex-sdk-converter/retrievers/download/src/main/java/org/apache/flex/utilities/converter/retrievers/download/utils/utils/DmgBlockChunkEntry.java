package org.apache.flex.utilities.converter.retrievers.download.utils.utils;

import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.IOException;

/**
 * Created by christoferdutz on 25.02.16.
 */
public class DmgBlockChunkEntry {

    private int entryType;          // Compression type used or entry type (see next table)
    private int comment;            // "+beg" or "+end", if EntryType is comment (0x7FFFFFFE). Else reserved.
    private long sectorNumber;      // Start sector of this chunk
    private long sectorCount;       // Number of sectors in this chunk
    private long compressedOffset;  // Start of chunk in data fork
    private long compressedLength;  // Count of bytes of chunk, in data fork

    public DmgBlockChunkEntry(byte[] data) {
        // Initialize the fields by parsing the input bytes.
        ByteArrayInputStream bis = new ByteArrayInputStream(data);
        DataInputStream dis = new DataInputStream(bis);
        try {
            entryType = dis.readInt();
            comment = dis.readInt();
            sectorNumber = dis.readLong();
            sectorCount = dis.readLong();
            compressedOffset = dis.readLong();
            compressedLength = dis.readLong();
        } catch (IOException e) {
            throw new IllegalArgumentException("Invalid DmgBlockChunkEntry data.");
        }
    }

    public int getEntryType() {
        return entryType;
    }

    public int getComment() {
        return comment;
    }

    public long getSectorNumber() {
        return sectorNumber;
    }

    public long getSectorCount() {
        return sectorCount;
    }

    public long getCompressedOffset() {
        return compressedOffset;
    }

    public long getCompressedLength() {
        return compressedLength;
    }

    @Override
    public String toString() {
        String entryTypeName;
        switch(entryType) {
            case 0x00000000:
                entryTypeName = "Zero-Fill";
                break;
            case 0x00000001:
                entryTypeName = "UDRW/UDRO - RAW or NULL compression (uncompressed)";
                break;
            case 0x00000002:
                entryTypeName = "Ignored/unknown";
                break;
            case 0x80000004:
                entryTypeName = "UDCO - Apple Data Compression (ADC)";
                break;
            case 0x80000005:
                entryTypeName = "UDZO - zLib data compression";
                break;
            case 0x80000006:
                entryTypeName = "UDBZ - bz2lib data compression";
                break;
            case 0x7ffffffe:
                entryTypeName = "No blocks - Comment: +beg and +end";
            default:
                entryTypeName = "Unknown entry type " + entryType;
        }
        return "DmgBlockChunkEntry{" +
                "entryType=" + entryTypeName +
                ", comment=" + comment +
                ", sectorNumber=" + sectorNumber +
                ", sectorCount=" + sectorCount +
                ", compressedOffset=" + compressedOffset +
                ", compressedLength=" + compressedLength +
                '}';
    }
}
