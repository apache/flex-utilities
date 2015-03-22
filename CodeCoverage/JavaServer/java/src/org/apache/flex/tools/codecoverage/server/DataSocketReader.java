/*
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

package org.apache.flex.tools.codecoverage.server;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Socket;

/**
 * Thread to read trace data from the Flex client. 
 * All data read from the socket is written directly to the writer
 * with no processing.
 * 
 */
public class DataSocketReader implements Runnable 
{
    private Socket socket;
    private BufferedWriter fileWriter;

    /**
     * Constructor.
     * 
     * @param socket The socket to read from.
     * @param fileWriter The writer to write the data to.
     */
    public DataSocketReader(final Socket socket, final BufferedWriter fileWriter)
    {
        this.socket = socket;
        this.fileWriter = fileWriter;
    }
    
    /**
     * Read data from the socket and write it the specified file until
     * we are interrupted.
     */
    @Override
    public void run() 
    {
        // listen for data
        final char[] cbuf = new char[512 * 1024];
        
        try (BufferedReader in = new BufferedReader(
                    new InputStreamReader(
                        socket.getInputStream()), 512 * 1024))
        {
            while (!Thread.interrupted() && !socket.isClosed())
            {
                int charsRead = in.read(cbuf);
                if (charsRead > 0)
                {
                    String buf = String.valueOf(cbuf, 0, charsRead);
                    fileWriter.write(buf);  
                }
                else
                {
                    Thread.sleep(1000);
                }
            }
        } 
        catch (IOException e) 
        {
            e.printStackTrace();
        }
        catch (InterruptedException e) 
        {
        	// This happens when we are interrupted while sleeping.
        }
    }
}
