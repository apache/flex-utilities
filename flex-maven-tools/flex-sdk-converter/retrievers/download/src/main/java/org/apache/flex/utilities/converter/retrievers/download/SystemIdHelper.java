/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.flex.utilities.converter.retrievers.download;

import java.net.NetworkInterface;
import java.net.SocketException;
import java.util.Arrays;
import java.util.Enumeration;

public abstract class SystemIdHelper {

    public static String getSystemId() {
        try {
            Enumeration<NetworkInterface> nis = NetworkInterface.getNetworkInterfaces();
            byte[] macSum = new byte[] { 0,0,0,0,0,0};
            while (nis.hasMoreElements()) {
                NetworkInterface ni = nis.nextElement();
                byte[] mac = ni.getHardwareAddress();
                if((mac != null) && (mac.length >= 6)) {
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
