package org.apache.flex.utilities.converter.api;

/**
 * Created by christoferdutz on 01.07.15.
 */
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
