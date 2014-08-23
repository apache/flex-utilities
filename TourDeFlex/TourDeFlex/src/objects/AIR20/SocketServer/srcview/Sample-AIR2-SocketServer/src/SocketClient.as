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
package {
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;
	
	import spark.components.TextArea;
	
	public class SocketClient
	{
		private var serverURL:String;
		private var portNumber:int;
		private var socket:Socket;
		private var ta:TextArea;
		private var state:int = 0;
		

		public function SocketClient(server:String, port:int, output:TextArea)
		{
			serverURL = server;
			portNumber = port;
			ta = output;
			
			socket = new Socket();
			
			try
			{
				msg("Connecting to " + serverURL + ":" + portNumber + "\n");
				socket.connect(serverURL, portNumber);
			}
			catch (error:Error)
			{
				msg(error.message + "\n");
				socket.close();
			}
			socket.addEventListener(Event.CONNECT, connectHandler);
			socket.addEventListener(Event.CLOSE, closeHandler);
			socket.addEventListener(ErrorEvent.ERROR, errorHandler);
			socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, dataHandler);
			
		}
		
		public function closeSocket():void
		{
			try {
				socket.flush();
				socket.close();
			}
			catch (error:Error)
			{
				msg(error.message);
			}
		}
		
		public function writeToSocket(ba:ByteArray):void
		{
			try {
				socket.writeBytes(ba);
				socket.flush();
			}
			catch (error:Error)
			{
				msg(error.message);
				
			}
		}
	
		private function msg(value:String):void
		{
			ta.text += value+ "\n";
			setScroll();
		}
		
		public function setScroll():void
		{
			ta.scrollToRange(ta.y+20);
		}
		
		public function connectHandler(e:Event):void
		{
			msg("Socket Connected");
		}
		
		public function closeHandler(e:Event):void
		{
			msg("Socket Closed");
		}
		
		public function errorHandler(e:ErrorEvent):void
		{
			msg("Error " + e.text);
		}
		
		public function ioErrorHandler(e:IOErrorEvent):void
		{
			msg("IO Error " + e.text + " check to make sure the socket server is running.");
		}
		
		public function dataHandler(e:ProgressEvent):void
		{
			msg("Data Received - total bytes " +e.bytesTotal + " ");
			var bytes:ByteArray = new ByteArray();
			socket.readBytes(bytes);
			msg("Bytes received " + bytes);
			trace(bytes);
		}
	}
}
