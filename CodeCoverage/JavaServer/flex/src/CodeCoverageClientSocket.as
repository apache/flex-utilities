////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

package
{
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;
import flash.system.Security;

/**
 * Wrapper around a Flash Player Socket.
 */
public class CodeCoverageClientSocket extends Socket
{
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------
    
    /**
     *  Constructor
	 * 
	 *  @param host The host to connect to.
	 *  @param port The port to send trace data to.
	 *  @param policyFilePort The port used to load the policy file.
     */
    public function CodeCoverageClientSocket(host:String, port:int, policyFilePort:int)
    {
        super();
        addListeners();
		
		var policyFile:String = "xmlsocket://" + host + ":" + policyFilePort;
        Security.loadPolicyFile(policyFile);
        connect(host, port);
    }
    
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
     *  Buffer output from trace data received before a connect is avaiable from
     *  the server. 
     */
    private var preConnectBuffer:Array = [];
    private var connectionAvailable:Boolean;
	
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------
    
	/**
	 * Send data to the sever.
	 * 
	 * If the socket is not connected the data will be buffered until the 
	 * connection is made.
	 * 
	 * @param data The data to send.
	 */
    public function sendData(data:String):void 
    {
        if (connectionAvailable)
        {
            writeUTFBytes(data);
	        flush();
        }
        else
        {
            preConnectBuffer.push(data);
        }
    }
    
	private function addListeners():void
	{
		addEventListener(Event.CLOSE, closeHandler);
		addEventListener(Event.CONNECT, connectHandler);
		addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	}
	
    //--------------------------------------------------------------------------
    //
    //  Event handler
    //
    //--------------------------------------------------------------------------
    
    private function closeHandler(event:Event):void 
    {
        connectionAvailable = false;
    }
    
	/**
	 * Call when the socket connection is established.
	 */
    private function connectHandler(event:Event):void
    {
        removeEventListener(Event.CONNECT, connectHandler);
		
		// Write out buffered data.
        if (preConnectBuffer.length > 0)
        {
            var data:String = preConnectBuffer.join("");
            writeUTFBytes(data);
			flush();
        }
        
        connectionAvailable = true;
        preConnectBuffer = [];
    }
    
    private function ioErrorHandler(event:IOErrorEvent):void
    {
        trace("CodeCoveragePreloadSWF ioErrorHandler: " + event.errorID);
    }
    
    private function securityErrorHandler(event:SecurityErrorEvent):void
    {
        trace("CodeCoveragePreloadSWF securityErrorHandler: " + event.errorID);
    }
    
}    
}