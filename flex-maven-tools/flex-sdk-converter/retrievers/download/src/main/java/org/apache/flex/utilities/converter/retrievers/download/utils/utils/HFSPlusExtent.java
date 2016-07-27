package org.apache.flex.utilities.converter.retrievers.download.utils.utils;

import java.io.DataInputStream;
import java.io.IOException;
import java.util.ArrayList;

/**
 * Created by christoferdutz on 27.02.16.
 */
public class HFSPlusExtent {

    private int startBlock;
    private int blockCount;

    public HFSPlusExtent(DataInputStream dis) {
        try {
            startBlock = dis.readInt();
            blockCount = dis.readInt();
        } catch (IOException e) {
            throw new IllegalArgumentException("Invalid HFSPlusVolumeHeader data.");
        }
    }

    public int getStartBlock() {
        return startBlock;
    }

    public int getBlockCount() {
        return blockCount;
    }

    @Override
    public String toString() {
        return "HFSPlusExtent{" +
                "startBlock=" + startBlock +
                ", blockCount=" + blockCount +
                '}';
    }

}
