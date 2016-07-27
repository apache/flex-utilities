package org.apache.flex.utilities.converter.retrievers.download.utils.utils;

import java.io.DataInputStream;
import java.io.IOException;

/**
 * Created by christoferdutz on 26.02.16.
 */
public class DriverDescriptor {

    private int driverBlockStart;
    private short driverBlockCount;
    private short driverSystemType;

    public DriverDescriptor(DataInputStream dis) {
        // Initialize the fields by parsing the input bytes.
        try {
            driverBlockStart = dis.readInt();
            driverBlockCount = dis.readShort();
            driverSystemType = dis.readShort();
        } catch (IOException e) {
            throw new IllegalArgumentException("Invalid DriverDescriptor data.");
        }
    }

    public int getDriverBlockStart() {
        return driverBlockStart;
    }

    public short getDriverBlockCount() {
        return driverBlockCount;
    }

    public short getDriverSystemType() {
        return driverSystemType;
    }

}
