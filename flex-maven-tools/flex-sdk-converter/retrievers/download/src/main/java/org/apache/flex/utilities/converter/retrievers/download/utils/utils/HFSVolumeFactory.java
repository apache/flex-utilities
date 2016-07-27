package org.apache.flex.utilities.converter.retrievers.download.utils.utils;

import java.io.DataInputStream;
import java.io.IOException;

/**
 * Created by christoferdutz on 27.02.16.
 */
public class HFSVolumeFactory {

    public static IHFSVolumeHeader readHfsVolumeHeader(DataInputStream dis) {
        try {
            short magicNumber = dis.readShort();
            if(magicNumber == 0x482B) {
                return new HFSPlusVolumeHeader(dis);
            } else {
                return new HFSVolumeHeader(dis);
            }
        } catch (IOException e) {
            throw new IllegalArgumentException("Invalid IHFSPVolumeHeader data.");
        }
    }

}
