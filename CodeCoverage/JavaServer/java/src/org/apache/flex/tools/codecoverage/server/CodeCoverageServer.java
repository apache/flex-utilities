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
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.net.ConnectException;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.URL;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.io.FileUtils;

/**
 * Main class of the Code Coverage Server.
 * 
 * This class serves the command port.
 * Creates threads to serve the data port and the policy file port.
 *
 */
public class CodeCoverageServer
{
    private static enum ExitCode
    {
        SUCCESS(0),
        HELP(1),
        INVALID_OPTIONS(2),
        ERRORS(3);
        
        private final int exitCode;
        
        private ExitCode(int exitCode)
        {
            this.exitCode = exitCode;
        }
        
        public int getExitCode()
        {
            return exitCode;
        }
    }
    
    /**
     * Commands
     */
    public static final String START_COMMAND = "start";
    public static final String STOP_COMMAND = "stop";
    public static final String STATUS_COMMAND = "status";
    public static final String ALIVE_COMMAND = "alive";
    
    /**
     * Responses
     */
    public static final String SUCCESS_RESPONSE = "0";
    public static final String ERROR_RESPONSE = "-1";
    
    /**
     * Command line options
     */
    
    /**
     * Controls whether the server removes all existing data files on startup
     * or appends to the existing data files.
     */
    public static final String OPTION_APPEND = "-append";
            
    /**
     * Default configuration values
     */
    private static final String DEFAULT_HOST = "localhost";
    private static final int DEFAULT_DATA_PORT = 9097;
    private static final int DEFAULT_COMMAND_PORT = 9098;
    private static final int DEFAULT_POLICY_FILE_PORT = 9843;
    private static final String DEFAULT_PRELOAD_SWF = "CodeCoveragePreloadSWF.swf"; 
    
    /**
     * config.properties keys
     */
    private static final String MM_CFG_PATH = "mmCfgPath";
    private static final String PRELOAD_SWF_KEY = "preloadSWF";
    private static final String DATA_DIRECTORY_KEY = "dataDirectory";
    private static final String HOST_KEY = "host";
    private static final String DATA_PORT_KEY = "dataPort";
    private static final String COMMAND_PORT_KEY = "commandPort";
    private static final String POLICY_FILE_PORT_KEY = "policyFilePort";
    
    private static final boolean ADD_PRELOADSWF_KEY = true;
    private static final boolean REMOVE_PRELOADSWF_KEY = false;

    private static final String CCSERVER_VERSION = "0.9.1";
    
    private static boolean start;
    private static boolean stop;
    private static boolean append = false;
    
    /**
     * @param args
     */
    public static void main(String[] args) 
    {
        CodeCoverageServer server = new CodeCoverageServer();
        final int exitCode = server.mainNoExit(args);
        System.exit(exitCode);
    }

    /**
     * Entry point for the server instance.
     * 
     * @param args Command line args
     * @return One of EXIT_CODE enum.
     */
    private int mainNoExit(String[] args)
    {
        System.out.println("Apache Flex Code Coverage Server");
        System.out.println("Version " + CCSERVER_VERSION);
        System.out.println("");

        if (args.length == 0 ||
            args.length == 1 && "-help".equals(args[0]))
        {
            System.out.println("Usage: ccserver [-append] [start | stop]");
            return ExitCode.HELP.getExitCode();
        }

        try
        {
            if (!initializeProperties() ||
                !processArgs(args))
            {
                return ExitCode.INVALID_OPTIONS.getExitCode();
            }

            if (start)
                start();
            else if (stop)
                stop();
            
        }
        catch (IOException e)
        {
            e.printStackTrace();
            return ExitCode.ERRORS.getExitCode();
        }
        catch (InterruptedException e)
        {
            e.printStackTrace();
            return ExitCode.ERRORS.getExitCode();
        }

        return ExitCode.SUCCESS.getExitCode();
    }

    private Properties config = new Properties();
    private boolean listening = true;
    private String host;
    private int dataPort;
    private int commandPort;
    private int policyFilePort;
    private String preloadSWFPath;
    
    /**
     * Constructor.
     */
    public CodeCoverageServer() 
    {
    }
    
    /**
     * Process commmand line args.
     * @param args
     * @return true if the args are correct, false if there were errors.
     */
    private boolean processArgs(final String[] args)
    {
        for (final String arg : args)
        {
            switch (arg)
            {
                case OPTION_APPEND:
                {
                    append = true;
                    break;
                }
                case START_COMMAND:
                {
                    start = true;
                    break;
                }
                case STOP_COMMAND:
                {
                    stop = true;
                    break;
                }
                default:
                {
                    System.err.println("unexpected argument: " + arg);
                    return false;
                }
            }
        }
        
        // start is the default action.
        if (!start && !stop)
            start = true;
        
        return true;
    }

    /**
     * Starts the server.
     * 
     * @throws IOException
     * @throws InterruptedException
     */
    public void start() throws IOException, InterruptedException
    {
        if (isAlive())
        {
            System.out.println("Apache Flex Code Coverage Server is already running");
            return;
        }
        
        final String dataProperty = config.getProperty(DATA_DIRECTORY_KEY);
        final File dataDirectory;
        
        if (dataProperty == null)
            dataDirectory = new File(System.getProperty("user.home"), "ccdata");
        else 
            dataDirectory = new File(dataProperty); 
        
        if (!dataDirectory.exists())
        {
            // mkdir() is creating the directory but returning false, so
            // re-test with exists()
            if (!dataDirectory.mkdir() && !dataDirectory.exists())
            {
                System.err.println("Error: Data directory does not exist and unable to create it: " + dataDirectory.getAbsolutePath());
                return;
            }
        }
        
        int fileCount = initDataDirectory(dataDirectory);
        
        // modify mm.cfg file
        updateMMCFG(ADD_PRELOADSWF_KEY);

        // create thread to listen for connections on the data port
        final DataSocketAccepter dataSocketAccepter = 
                new DataSocketAccepter(host, dataPort, dataDirectory, fileCount);
        final Thread dataThread = new Thread(dataSocketAccepter);
        dataThread.start();
        
        // create thread to listen the policy file port and server up the socket policy file.
        final PolicyFileServer policyFileServer = new PolicyFileServer(host,
                dataPort, policyFilePort);
        final Thread policyFileServerThread = new Thread(policyFileServer);
        policyFileServerThread.start();
        
        System.out.println("listening on port " + dataPort);

        // read commands on command socket
        final ServerSocket commandSocket = new ServerSocket(commandPort);
        
        try
        {
            while (listening)
            {
                try (Socket socket = commandSocket.accept();
                     InputStreamReader reader = new InputStreamReader(socket.getInputStream());
                     OutputStreamWriter writer = new OutputStreamWriter(socket.getOutputStream()))
                {
                    // wait for request
                    char[] cbuf = new char[256];
                    int charsRead = reader.read(cbuf);
                    if (charsRead > 0)
                    {
                        processCommand(reader, writer, String.valueOf(cbuf).trim());
                    }
                }
            }
        }
        finally
        {
            commandSocket.close();
            policyFileServer.close();
            policyFileServerThread.join();
            dataSocketAccepter.close();
            dataThread.join();
            updateMMCFG(REMOVE_PRELOADSWF_KEY);        	
        }
        
        System.out.println("stopping Apache Flex Code Coverage Server");
    }

    /**
     * Either remove all files or if -append is set then figure out
     * which number to start incrementing at.
     * 
     * @param dataDirectory
     * @throws IOException 
     */
    private int initDataDirectory(File dataDirectory) throws IOException
    {
        int maxFileIndex = 0;
        Pattern filenamePattern = Pattern.compile("ccdata_(\\d+)\\.txt");
        
        if (append)
        {
            
            String[] filenames = dataDirectory.list();
            for (String filename : filenames)
            {
                Matcher matcher = filenamePattern.matcher(filename);
                boolean matches = matcher.matches();
                if (matches)
                {
                    try
                    {
                        String indexString = matcher.group(1);
                        int value = Integer.parseInt(indexString);
                        if (value >= maxFileIndex)
                            maxFileIndex = value + 1;
                    }
                    catch (Exception e)
                    {
                        // ignore
                    }
                }
            }
            
        }
        else
        {
            FileUtils.cleanDirectory(dataDirectory);
        }

        return maxFileIndex;
    }

    /**
     * Process a server command.
     * 
     * @param reader The socket reader.
     * @param writer The socket writer.
     * @param command The command to process.
     * @throws IOException 
     */
    private void processCommand(final InputStreamReader reader, 
            final OutputStreamWriter writer, final String command) throws IOException
    {
        String response = SUCCESS_RESPONSE;
        
        switch (command)
        {
            case STOP_COMMAND:
            {
                listening = false;
                break;
            }
            case ALIVE_COMMAND:
            {
                break;
            }
            default:
            {
                response = ERROR_RESPONSE;
                System.err.println("ccserver: unknown command " + command);
            }
        }
        
        // acknowledge command
        writer.append(response);
        writer.flush();
    }

    /**
     * Initialize properties from config file.
     * Validate the properties.
     * 
     * @return true if the properties are valid, false otherwise.
     * @throws IOException
     */
    private boolean initializeProperties() throws IOException
    {
        readProperties();
        
        host = config.getProperty(HOST_KEY, DEFAULT_HOST);
        dataPort = getIntegerProperty(DATA_PORT_KEY, DEFAULT_DATA_PORT);
        commandPort = getIntegerProperty(COMMAND_PORT_KEY, DEFAULT_COMMAND_PORT);
        policyFilePort = getIntegerProperty(POLICY_FILE_PORT_KEY, DEFAULT_POLICY_FILE_PORT);

        // get absolute path of preloadSWF.
        if (!initializePreloadSWF())
            return false;
        
        return true;
    }

    /**
     * Initialize the preloadSWF value.
     * 
     * @return true if value, false otherwise.
     * @throws UnsupportedEncodingException 
     */
    private boolean initializePreloadSWF() throws UnsupportedEncodingException
    {
        // if the path of the preload SWF is not configured, then try to locate
        // it in the same directory as the jar containing this class.
        preloadSWFPath = config.getProperty(PRELOAD_SWF_KEY, DEFAULT_PRELOAD_SWF);
        File preloadSWFFile = new File(preloadSWFPath);
        if (!preloadSWFFile.exists())
        {
            URL preloadSWFURL = getClass().getClassLoader().getResource(preloadSWFPath);
            if (preloadSWFURL != null)
            {
                preloadSWFPath = URLDecoder.decode(preloadSWFURL.getPath(), "UTF-8");
                preloadSWFFile = new File(preloadSWFPath);
            }
            
            if (!preloadSWFFile.exists())
            {
                System.out.println("preloadSWF not found: " + preloadSWFPath);
                return false;
            }
        }
        
        preloadSWFPath = preloadSWFFile.getAbsolutePath();
        return true;
    }

    /**
     * Handle NumberFormatExeptions values in the configuration file.
     * 
     * @param key
     * @param defaultValue
     * @return integer value of a configuration value.
     */
    private int getIntegerProperty(String key, int defaultValue)
    {
        String value = config.getProperty(key);
        int result = defaultValue;
        
        try
        {
            result = Integer.valueOf(value);            
        }
        catch (NumberFormatException e)
        {
            // ignore, result is already set to defualt value
        }
        
        return result;
    }
    
    /**
     * Send command to the command port to stop the server.
     * 
     * @throws IOException
     */
    public void stop() throws IOException
    {
        if (!isAlive())
        {
            System.out.println("Apache Flex Code Coverage Server not running");
            return;
        }

        // connect to the server and send a command
        sendCommand(STOP_COMMAND);
    }
    
    /**
     * Read properties from the config.properties file.
     * 
     * @throws IOException
     */
    private void readProperties() throws IOException
    {
        try (InputStream inputStream = getClass().getClassLoader().
                getResourceAsStream("ccserver.properties"))
        {
            if (inputStream != null)
                config.load(inputStream);
        }
    }
    
    /**
     * Update the user's mm.cfg file to either add or remove the preloadSWF
     * key.
     * 
     * @param addPreloadSWF If true add "preloadSWF=" to the user's mm.cfg.
     * @throws IOException 
     */
    private void updateMMCFG(final boolean addPreloadSWF) throws IOException
    {
        // open mm.cfg
        String filename = config.getProperty(MM_CFG_PATH, 
                System.getProperty("user.home") + "/mm.cfg");
        
        // read mm.cfg
    	List<String> lines = new ArrayList<String>();
        try (Reader fileReader = new FileReader(filename);
        	 BufferedReader bufferedReader = new BufferedReader(fileReader))
        {
        	String line = null;
        	while ((line = bufferedReader.readLine()) != null)
        	{
    			// if found a preloadSWF line then don't write it in order to 
    			// remove it. If we are adding the line we will append it later.
        		if (!(line.startsWith(PRELOAD_SWF_KEY + "=")))
        		{
        			lines.add(line);
        		}
        	}
            
        	// if adding the preloadSWF key, append the preloadSWF property
        	if (addPreloadSWF)
        	{
        	    StringBuilder preloadSWF = new StringBuilder(PRELOAD_SWF_KEY);
        	    preloadSWF.append("="); 
        	    preloadSWF.append(preloadSWFPath);
        	    preloadSWF.append("?host=");
        	    preloadSWF.append(host);
        	    preloadSWF.append("&dataPort=");
        	    preloadSWF.append(dataPort);
        	    preloadSWF.append("&policyFilePort=");
        	    preloadSWF.append(policyFilePort);
        		lines.add(preloadSWF.toString());
        	}
        }
        catch (FileNotFoundException e)
        {
            System.err.println("Unable to open mm.cfg. Create the file in the user home directory or specify the location by setting the mmCfgPath property in ccserver.properties.");
            e.printStackTrace();
            return;
        }
        
        // write mm.cfg
        try (FileWriter fileWriter = new FileWriter(filename);
        	 BufferedWriter bufferedWriter = new BufferedWriter(fileWriter))
        {
        	for (String line : lines)
        	{
        		bufferedWriter.write(line);
        		bufferedWriter.newLine();
        	}
        }
        
    }
    
    /**
     * Send a command and get the response.
     * 
     * @param command
     * @return A String containing the response. If there is no response an
     * empty string will be returned. 
     * @throws IOException
     */
    private String sendCommand(String command) throws IOException
    {
        String result = "";
        char[] cbuf = new char[512];

        try (Socket socket = new Socket(host, commandPort);
            InputStreamReader reader = new InputStreamReader(socket.getInputStream());
            PrintWriter writer = new PrintWriter(socket.getOutputStream()))
        {
            // send command
            writer.print(command);
            writer.flush();

            // read response
            int charsRead = reader.read(cbuf);
            if (charsRead != -1)
                result = String.valueOf(cbuf, 0, charsRead);
        }
        
        return result;
    }
    
    /**
     * Test if the server is already running.
     * 
     * @return true if the server is running, false otherwise.
     * @throws IOException 
     */
    private boolean isAlive() throws IOException
    {
        try 
        {
            String result = sendCommand(ALIVE_COMMAND);
            if (result.length() > 0)
                return true;
            
            return false;
        }
        catch (ConnectException e)
        {
            // server not running so connection failed.
            return false;
        }
    }
    
}
