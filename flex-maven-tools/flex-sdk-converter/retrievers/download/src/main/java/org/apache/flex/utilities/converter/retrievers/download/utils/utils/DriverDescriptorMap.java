package org.apache.flex.utilities.converter.retrievers.download.utils.utils;

import java.io.DataInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by christoferdutz on 26.02.16.
 */
public class DriverDescriptorMap {

    private short blockSize;
    private int blockCount;
    private short deviceType;
    private short deviceId;
    private int driverData;
    private short driverDescriptorCount;
    private List<DriverDescriptor> driverDescroiptors;

    public DriverDescriptorMap(DataInputStream dis) {
        // Initialize the fields by parsing the input bytes.
        try {
            if (dis.readShort() != 0x4552) {
                throw new IllegalArgumentException("Invalid DriverDescriptorMap data. Expected magic number 0x4552");
            }
            blockSize = dis.readShort();
            blockCount = dis.readInt();
            deviceType = dis.readShort();
            deviceId = dis.readShort();
            driverData = dis.readInt();
            driverDescriptorCount = dis.readShort();
            driverDescroiptors = new ArrayList<DriverDescriptor>();
            for(int i = 0; i < 8; i++) {
                DriverDescriptor dd = new DriverDescriptor(dis);
                driverDescroiptors.add(dd);
            }
            dis.skipBytes(430);

        } catch (IOException e) {
            throw new IllegalArgumentException("Invalid DriverDescriptorMap data.");
        }
    }

    public short getBlockSize() {
        return blockSize;
    }

    public int getBlockCount() {
        return blockCount;
    }

    public short getDeviceType() {
        return deviceType;
    }

    public short getDeviceId() {
        return deviceId;
    }

    public int getDriverData() {
        return driverData;
    }

    public short getDriverDescriptorCount() {
        return driverDescriptorCount;
    }

    public List<DriverDescriptor> getDriverDescroiptors() {
        return driverDescroiptors;
    }

    @Override
    public String toString() {
        return "DriverDescriptorMap{" +
                "blockSize=" + blockSize +
                ", blockCount=" + blockCount +
                ", deviceType=" + deviceType +
                ", deviceId=" + deviceId +
                ", driverData=" + driverData +
                ", driverDescriptorCount=" + driverDescriptorCount +
                ", driverDescroiptors=" + driverDescroiptors +
                '}';
    }
}
