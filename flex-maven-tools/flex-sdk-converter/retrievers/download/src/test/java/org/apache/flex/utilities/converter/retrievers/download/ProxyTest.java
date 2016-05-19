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

import org.apache.flex.utilities.converter.api.ProxySettings;
import org.apache.flex.utilities.converter.retrievers.types.PlatformType;
import org.apache.flex.utilities.converter.retrievers.types.SdkType;
import org.mockserver.integration.ClientAndProxy;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

import static org.mockserver.integration.ClientAndProxy.startClientAndProxy;

/**
 * Created by christoferdutz on 02.07.15.
 */
public class ProxyTest {

    private ClientAndProxy proxy;

    @BeforeMethod
    public void startProxy() {
        proxy = startClientAndProxy(3456);
        // Make the test accept the license agreement.
        System.setProperty("com.adobe.systemIdsForWhichTheTermsOfTheAdobeLicenseAgreementAreAccepted", SystemIdHelper.getSystemId());
    }

    @AfterMethod
    public void stopProxy() {
        proxy.stop();
    }

    /**
     * Does a download using the URLConnection class
     */
    @Test
    public void simpleFastHttpNoAuthProxy() throws Exception {
        ProxySettings proxySettings = new ProxySettings("HTTP", "localhost", 3456, null, null, null);
        ProxySettings.setProxySettings(proxySettings);
        DownloadRetriever downloadRetriever = new DownloadRetriever();
        downloadRetriever.retrieve(SdkType.FLASH, "17.0", PlatformType.WINDOWS);
    }

    /**
     * Does a download using the HttpClient class
     */
    // TODO: Re-Include this.
    @Test(enabled = false)
    public void simpleSafeHttpNoAuthProxy() throws Exception {
        ProxySettings proxySettings = new ProxySettings("HTTP", "localhost", 3456, null, null, null);
        ProxySettings.setProxySettings(proxySettings);
        DownloadRetriever downloadRetriever = new DownloadRetriever();
        downloadRetriever.retrieve(SdkType.FONTKIT, "1.0", PlatformType.WINDOWS);
    }

    /**
     * Does a download using the URLConnection class using a proxy that requires authentication.
     */
    @Test(enabled = false)
    public void simpleFastHttpWithAuthProxy() throws Exception {
        ProxySettings proxySettings = new ProxySettings("HTTP", "localhost", 3456, "testuser", "testpass", null);
        ProxySettings.setProxySettings(proxySettings);
        DownloadRetriever downloadRetriever = new DownloadRetriever();
        downloadRetriever.retrieve(SdkType.FLASH, "17.0", PlatformType.WINDOWS);
    }

    /**
     * Does a download using the HttpClient class using a proxy that requires authentication.
     */
    @Test(enabled = false)
    public void simpleSafeHttpWithAuthProxy() throws Exception {
        ProxySettings proxySettings = new ProxySettings("HTTP", "localhost", 3456, "testuser", "testpass", null);
        ProxySettings.setProxySettings(proxySettings);
        DownloadRetriever downloadRetriever = new DownloadRetriever();
        downloadRetriever.retrieve(SdkType.FONTKIT, "1.0", PlatformType.WINDOWS);
    }

}
