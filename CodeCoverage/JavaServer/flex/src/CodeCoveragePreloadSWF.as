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
import flash.display.LoaderInfo;
import flash.display.Sprite;
import flash.events.Event;
import flash.trace.Trace;
import flash.utils.getTimer;

/**
 *  Main of preload SWF. This SWF listens to the trace of the primary application
 *  and sends the data to a server using a web socket.
 */
public class CodeCoveragePreloadSWF extends Sprite
{
	//--------------------------------------------------------------------------
	//
	//  Class constants
	//
	//--------------------------------------------------------------------------
	
	private static const DEFAULT_HOST:String = "localhost";
	private static const DEFAULT_DATA_PORT:int = 9097;
	private static const DEFAULT_POLICY_FILE_PORT:int = 9843;
	
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor 
     */
    public function CodeCoveragePreloadSWF()
    {
		createClientSocket();
        addEventListener("allComplete", allCompleteHandler);
		
        Trace.setLevel(Trace.METHODS_AND_LINES, Trace.LISTENER);
        Trace.setListener(methodsAndLinesCallback);
    }
	
    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

	/**
	 * Map the debug file info to an index number to reduce the amount
	 * of data sent over the port and stored.
	 * 
	 * Key debug_file string
	 * Index: unique index representing the key.
	 */
    private var stringMap:Object = {};
	
	/**
	 * incremented to provide a unique index for every string.
	 */
    private var stringIndex:int = 0;
	
	/**
	 *	Collection of lines that have been sent to server.
	 *  For the purposes of code coverage there is no need to send a debug line
	 *  more than once. 
	 */
	private var lineMap:Object = {};
	
	/**
	 * socket to send trace data to the server.
	 */
	private var socket:CodeCoverageClientSocket;
	
	/**
	 * If true ignore the trace data. Used to prevent this code from being part of code
	 * coverage. Is this needed if the application is run w/o debug instructions.
	 */
	private var ignoreTrace:Boolean; 
	
	//--------------------------------------------------------------------------
	//
	//	Methods
	//
	//--------------------------------------------------------------------------

	/**
	 * Create a socket to handle sending trace data to the server.
	 */
	private function createClientSocket():void
	{
		var key:String;
		var value:String;
		var paramObj:Object = LoaderInfo(this.root.loaderInfo).parameters;
		var host:String = DEFAULT_HOST;
		var port:int = DEFAULT_DATA_PORT;
		var policyFilePort:int = DEFAULT_POLICY_FILE_PORT;
		
		for (key in paramObj) 
		{
			value = String(paramObj[key]);
			if (key == "host")
				host = value;
			else if (key == "dataPort")
				port = int(value);
			else if (key == "policyFilePort")
				policyFilePort = int(value);
		}

		socket = new CodeCoverageClientSocket(host, port, policyFilePort);
	}

	//--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------
    
	/**
	 * Callback for methods and lines trace data.
	 */
    public function methodsAndLinesCallback(filename:String, lineNumber:int, methodName:String, methodArgs:String):void
    {
        if (lineNumber <= 0 || ignoreTrace)
            return;
        
		try
        {
			// Map file name to and index
            if (!stringMap.hasOwnProperty(filename))
            {
                socket.sendData("#" + stringIndex + "," + filename + "\n");
                stringMap[filename] = stringIndex.toString();
                stringIndex++;
            }
            
            var id:String = stringMap[filename];
            var line:String = lineNumber.toString();
			var data:String = id + "," + line + "\n";
			
			// Only send a debug line once.
			if (!lineMap.hasOwnProperty(data))
				lineMap[data] = 1;
			else
				return;
			
            socket.sendData(data);
        }
        catch (e:Error)
        {
            trace("CodeCoveragePreloadSWF Error: " + e.message);
        }

    }

	/**
	 * Called when the main application finishing loading.
	 * This provides us with the name of the SWF.
	 */
    private function allCompleteHandler(event:Event):void
    {
		ignoreTrace = true;
		removeEventListener("allComplete", allCompleteHandler);

        var loaderInfo:LoaderInfo = event.target as LoaderInfo;
        socket.sendData("@" + loaderInfo.loaderURL + "\n");
		ignoreTrace = false;
    }
    
}
}