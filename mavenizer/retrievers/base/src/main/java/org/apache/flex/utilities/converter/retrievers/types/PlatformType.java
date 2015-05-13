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
package org.apache.flex.utilities.converter.retrievers.types;

/**
 * Created by cdutz on 18.05.2014.
 */
public enum PlatformType {

    WINDOWS,
    LINUX,
    MAC;

    public static PlatformType getCurrent()
    {
        PlatformType platformType = null;

        if (isWindows())
        {
            platformType = PlatformType.WINDOWS;
        }
        else if (isMac())
        {
            platformType = PlatformType.MAC;
        }
        else if (isUnixBased())
        {
            platformType = PlatformType.LINUX;
        }

        return platformType;
    }

    static final String NET_BSD = "netbsd";

    static final String FREE_BSD = "freebsd";

    static final String WINDOWS_OS = "windows";

    static final String MAC_OS = "mac os x";

    static final String MAC_OS_DARWIN = "darwin";

    static final String LINUX_OS = "linux";

    static final String SOLARIS_OS = "sunos";

    private static String osString()
    {
        return System.getProperty( "os.name" ).toLowerCase();
    }

    /**
     * Return a boolean to show if we are running on Windows.
     *
     * @return true if we are running on Windows.
     */
    private static boolean isWindows()
    {
        return osString().startsWith( WINDOWS_OS );
    }

    /**
     * Return a boolean to show if we are running on Linux.
     *
     * @return true if we are running on Linux.
     */
    private static boolean isLinux()
    {
        return osString().startsWith( LINUX_OS ) ||
                // I know, but people said that workds...
                osString().startsWith( NET_BSD ) ||
                osString().startsWith( FREE_BSD );
    }

    /**
     * Return a boolean to show if we are running on Solaris.
     *
     * @return true if we are running on Solaris.
     */
    private static boolean isSolaris()
    {
        return osString().startsWith( SOLARIS_OS );
    }

    /**
     * Return a boolean to show if we are running on a unix-based OS.
     *
     * @return true if we are running on a unix-based OS.
     */
    private static boolean isUnixBased()
    {
        return isLinux() || isSolaris();
    }

    /**
     * Return a boolean to show if we are running on Mac OS X.
     *
     * @return true if we are running on Mac OS X.
     */
    private static boolean isMac()
    {
        return osString().startsWith( MAC_OS ) || osString().startsWith( MAC_OS_DARWIN );
    }
}
