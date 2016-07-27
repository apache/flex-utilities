package org.apache.flex.utilities.converter.retrievers.download.utils.utils;

import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.IOException;

/**
 * Created by christoferdutz on 25.02.16.
 */
public class DmgUdifChecksum {

    private int type;
    private int size;
    private byte[] data;

    public DmgUdifChecksum(byte[] data) {
        // Initialize the fields by parsing the input bytes.
        ByteArrayInputStream bis = new ByteArrayInputStream(data);
        DataInputStream dis = new DataInputStream(bis);
        try {
            type = dis.readInt();
            size = dis.readInt();
            this.data = new byte[128];
            dis.read(this.data, 0, 128);
        } catch (IOException e) {
            throw new IllegalArgumentException("Invalid DmgUdifChecksum data.");
        }
    }

    public int getType() {
        return type;
    }

    public int getSize() {
        return size;
    }

    public byte[] getData() {
        return data;
    }

}
