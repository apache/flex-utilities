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

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;

/**
 * Thread to accept requests to connections to the data port.
 * When a connection is made an instance of the DataSocketThread is created to
 * read data from the socket.
 * 
 */
public class DataSocketAccepter implements Runnable
{

    private static final String filenameTemplate = "ccdata_{0}.txt";

    private ServerSocket socket;
    private BufferedWriter fileWriter;
    private Thread dataSocketReader;
    private volatile boolean listening = true;
    private final File dataDirectory;
    private int fileCount;
    private Socket currentSocket;
    private final String host;
    private final int dataPort;
    
    /**
     * Constructor.
     * 
     * @param host The host of the dataPort.
     * @param dataPort The data port to service.
     * @param dataDirectory The directory where the data files are stored.
     * Each new connection results in a new file created in this directory.
     */
    public DataSocketAccepter(final String host, final int dataPort, 
            final File dataDirectory, final int fileCount)
    {
       
       if (dataDirectory == null)
           throw new NullPointerException("dataDirectory may not be null");
        
       this.host = host;
       this.dataPort = dataPort;
       this.dataDirectory = dataDirectory;
       this.fileCount = fileCount;
    }
    
    /**
     * This thread will block waiting on a connect to the data port. Once a 
     * connection has been made an instance of DataSocketThread is run to read
     * the data on the port and this thread waits for the next connection.
     * Only one instance of the DataSocketThread is allowed. Before a new instance
     * is created the current one is closed.
     */
    @Override
    public void run() 
    {
        try
        { 
            socket = new ServerSocket(dataPort);
            
            while (listening) 
            {
                Socket newSocket = socket.accept();
                
                closeResources();
                currentSocket = newSocket;
                
                if (!listening)
                    break;
                
                String filename = filenameTemplate.replace("{0}", String.valueOf(fileCount++));
                File file = new File(dataDirectory, filename);
                System.out.println("saving trace data to " + file.getAbsolutePath());
                fileWriter = new BufferedWriter(new FileWriter(file));
                dataSocketReader = new Thread(new DataSocketReader(newSocket, fileWriter));
                dataSocketReader.start();
            }
        } 
        catch (IOException e) 
        {
            e.printStackTrace();
        } catch (InterruptedException e)
        {
            e.printStackTrace();
        }
        finally
        {
            if (currentSocket != null)
            {
                try 
                {
                    currentSocket.close();
                }
                catch (IOException e1)
                {
                    e1.printStackTrace();
                }
            }
            
            if (fileWriter != null)
            {
                try 
                {
                    fileWriter.close();
                } 
                catch (IOException e)
                {
                    e.printStackTrace();
                }
            }            
        }
    }

    /**
     * Close this thread.
     * 
     * @throws IOException 
     * @throws InterruptedException 
     */
    public void close() throws IOException
    {
        // connect to socket to unblock the accept call
        listening = false;
        Socket socket = new Socket(host, dataPort);
        socket.close();
    }
    
    /**
     * Close the resources used by data socket thread.
     * @throws InterruptedException
     * @throws IOException
     */
    private void closeResources() throws InterruptedException, IOException
    {
        if (dataSocketReader != null)
        {
            dataSocketReader.interrupt();
            dataSocketReader.join();
            dataSocketReader = null;
        }
        
        if (currentSocket != null)
            currentSocket.close();
        
        if (fileWriter != null)
        {
            fileWriter.close();
            fileWriter = null;
        }
    }
}
