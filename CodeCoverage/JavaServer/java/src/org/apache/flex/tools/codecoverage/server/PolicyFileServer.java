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

import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.UnknownHostException;

/**
 * Thread to serve a policy file to the Flash Player to allow the Flash
 * client to connect to the data port.
 *
 */
public class PolicyFileServer implements Runnable 
{
    /**
     * Request sent by the Flash Player requesting the policy file.
     */
    private static final String EXPECTED_REQUEST = "<policy-file-request/>";
    
    /**
     * Template of the policy file. Variables in brackets are replaced with
     * the actual values.
     */
    private static final String POLICY_FILE = "<?xml version=\"1.0\"?>" +  
            "<!DOCTYPE cross-domain-policy SYSTEM \"http://www.adobe.com/xml/dtds/cross-domain-policy.dtd\">" + 
            "<cross-domain-policy>" +  
            "    <allow-access-from domain=\"{host}\" to-ports=\"{dataPort}\" />" +
            "</cross-domain-policy>";

    private final String host;
    private final int dataPort;
    private final int policyFilePort;
    private boolean listening = true;
    
    // cached policy file create from the template.
    private String policyFile;
    
    /**
     * 
     * @param host
     * @param dataPort
     * @param policyFilePort
     */
    public PolicyFileServer(final String host, final int dataPort, 
            final int policyFilePort)
    {
        this.host = host;
        this.dataPort = dataPort;
        this.policyFilePort = policyFilePort;

        initializePolicyFile();
    }
    
    /**
     * Wait for a connection on the policy file port. When a connection is received
     * reply with a policy file if the Flash Player is requesting.
     */
    @Override
    public void run() 
    {
        ServerSocket serverSocket = null;
        
        try
        { 
            // accept connections and return an in-memory policy file.
            serverSocket = new ServerSocket(policyFilePort);

            while (listening) 
            {
                try (Socket socket = serverSocket.accept())
                {
                    if (!listening)
                        break;
                    
                    writePolicyFile(socket);
                }
            }
        } 
        catch (IOException e) 
        {
            e.printStackTrace();
        }
        finally 
        {
            if (serverSocket != null)
            {
                try 
                {
                    serverSocket.close();
                } 
                catch (IOException e1) 
                {
                    e1.printStackTrace();
                }
            }
        }
    }

    /**
     * Create the policy file from the template.
     */
    private void initializePolicyFile()
    {
        policyFile = POLICY_FILE.replace("{host}", host);
        policyFile = policyFile.replace("{dataPort}", Integer.toString(dataPort));
    }

    /**
     * Write the in-memory policy file to the socket.
     * 
     * @param socket Socket to write security policy file to.
     */
    private void writePolicyFile(final Socket socket)
    {
        char[] cbuf = new char[64];
        
        try (InputStreamReader reader = new InputStreamReader(socket.getInputStream());
             OutputStreamWriter writer = new OutputStreamWriter(socket.getOutputStream()))
        {
            int result = reader.read(cbuf);
            if (result > 0 && EXPECTED_REQUEST.equals(cbuf))
            {
                writer.write(policyFile);
            }
        } catch (IOException e)
        {
            e.printStackTrace();
        }
    }

    /**
     * Close the resources held by this thread.
     * 
     * @throws IOException 
     * @throws UnknownHostException 
     * @throws InterruptedException 
     */
    public void close() throws UnknownHostException, IOException, InterruptedException
    {
        // connect to socket to unblock the accept call
        listening = false;
        final Socket socket = new Socket(host, policyFilePort);
        socket.close();
    }
    
}
