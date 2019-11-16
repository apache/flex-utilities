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
package org.apache.flex.utilities.converter.api;

public class ProxySettings {

    private static ProxySettings proxySettings = null;

    public static void setProxySettings(ProxySettings proxySettings) {
        ProxySettings.proxySettings = proxySettings;
    }

    public static ProxySettings getProxySettings() {
        return proxySettings;
    }

    private String protocol;
    private String host;
    private int port;
    private String nonProxyHost;
    private String username;
    private String password;

    public ProxySettings(String protocol, String host, int port, String nonProxyHost, String username, String password) {
        this.protocol = protocol;
        this.host = host;
        this.port = port;
        this.nonProxyHost = nonProxyHost;
        this.username = username;
        this.password = password;
    }

    public String getProtocol() {
        return protocol;
    }

    public String getHost() {
        return host;
    }

    public int getPort() {
        return port;
    }

    public String getNonProxyHost() {
        return nonProxyHost;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

}
