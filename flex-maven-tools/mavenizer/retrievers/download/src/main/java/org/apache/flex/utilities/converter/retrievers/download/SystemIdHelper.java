package org.apache.flex.utilities.converter.retrievers.download;

import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Arrays;
import java.util.Enumeration;

/**
 * Created by christoferdutz on 05.06.15.
 */
public abstract class SystemIdHelper {

    public static String getSystemId() {
        try {
            Enumeration<NetworkInterface> nis = NetworkInterface.getNetworkInterfaces();
            byte[] macSum = new byte[] { 0,0,0,0,0,0};
            while (nis.hasMoreElements()) {
                NetworkInterface ni = nis.nextElement();
                byte[] mac = ni.getHardwareAddress();
                if(mac != null) {
                    macSum[0] = (byte) ((macSum[0] + mac[0]) % 256);
                    macSum[1] = (byte) ((macSum[1] + mac[1]) % 256);
                    macSum[2] = (byte) ((macSum[2] + mac[2]) % 256);
                    macSum[3] = (byte) ((macSum[3] + mac[3]) % 256);
                    macSum[4] = (byte) ((macSum[4] + mac[4]) % 256);
                    macSum[5] = (byte) ((macSum[5] + mac[5]) % 256);
                }
            }
            return Integer.toHexString(Arrays.hashCode(macSum));
        } catch (SocketException e) {
            return null;
        }
    }

}
