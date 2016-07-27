package org.apache.flex.utilities.converter.retrievers.download.utils.utils;

import java.io.DataInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by christoferdutz on 26.02.16.
 */
public class HFSPlusForkData {

    private long logicalSize;
    private int clumpSize;
    private int totalBlocks;
    private List<HFSPlusExtent> extents;

    public HFSPlusForkData(DataInputStream dis) {
        try {
            logicalSize = dis.readLong();
            clumpSize = dis.readInt();
            totalBlocks = dis.readInt();
            extents = new ArrayList<HFSPlusExtent>(8);
            for(int i = 0; i < 8; i++) {
                HFSPlusExtent extent = new HFSPlusExtent(dis);
                extents.add(extent);
            }
        } catch (IOException e) {
            throw new IllegalArgumentException("Invalid HFSPlusVolumeHeader data.");
        }
    }

    public long getLogicalSize() {
        return logicalSize;
    }

    public int getClumpSize() {
        return clumpSize;
    }

    public int getTotalBlocks() {
        return totalBlocks;
    }

    public List<HFSPlusExtent> getExtents() {
        return extents;
    }

    @Override
    public String toString() {
        return "HFSPlusForkData{" +
                "logicalSize=" + logicalSize +
                ", clumpSize=" + clumpSize +
                ", totalBlocks=" + totalBlocks +
                ", extents=" + extents +
                '}';
    }
}
