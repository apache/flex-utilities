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
package org.apache.flex.utils
{
    import flash.events.IOErrorEvent;
    
    import flash.desktop.NativeProcess;
    import flash.desktop.NativeProcessStartupInfo;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.NativeProcessExitEvent;
    import flash.events.ProgressEvent;
    import flash.filesystem.File;

    [Event(name="complete",type="flash.events.Event")]
    [Event(name="progress",type="flash.events.ProgressEvent")]
    [Event(name="standardErrorData",type="flash.events.ProgressEvent")]
    [Event(name="standardOutputIoError",type="flash.events.IOErrorEvent")]
    public class PowerShellFileDownloader extends EventDispatcher
    {
        private var _process:NativeProcess;
        private var _url:String;
        private var _downloadDestination:String;

        public function download(url:String, downloadDestination:String):void
        {
            cleanUpPowerShellDownloader();
            
            _url = url;
            _downloadDestination = downloadDestination;

            var startupInfo:NativeProcessStartupInfo = getNativeProcessStartupInfoDownload();
            
            _process = new NativeProcess();
            _process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onDownloadProgress);
            _process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onDownloadError);
            _process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
            _process.addEventListener(Event.STANDARD_OUTPUT_CLOSE, onStandardOutputClose);
            _process.addEventListener(NativeProcessExitEvent.EXIT, onDownloadComplete);
            _process.start(startupInfo);
        }

        private function onStandardOutputClose(event:Event):void
        {
            dispatchEvent(new Event(Event.COMPLETE));
            cleanUpPowerShellDownloader();
        }

        private function onIOError(event:IOErrorEvent):void
        {
            dispatchEvent(event.clone());
            cleanUpPowerShellDownloader();
        }

        private function onDownloadComplete(event:NativeProcessExitEvent):void
        {
            dispatchEvent(new Event(Event.COMPLETE));
            cleanUpPowerShellDownloader();
        }

        private function onDownloadError(event:ProgressEvent):void
        {
            dispatchEvent(new ProgressEvent(ProgressEvent.STANDARD_ERROR_DATA));
            cleanUpPowerShellDownloader();
        }

        private function onDownloadProgress(event:ProgressEvent):void
        {
            dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS, event.bubbles,
                    event.cancelable, event.bytesLoaded, event.bytesTotal));
        }

        private function getNativeProcessStartupInfoDownload():NativeProcessStartupInfo
        {
            var executable:File = new File("C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe");
            var startupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
            var arguments:Vector.<String> = new Vector.<String>();

            var command:String = getPowerShellDownloadCommand();
            arguments.push("-Command");
            arguments.push(command);

            startupInfo.executable = executable;
            startupInfo.arguments = arguments;

            return startupInfo;
        }

        private function getPowerShellDownloadCommand():String
        {
            var command:String = "& {";
            command += "Param([string]$url,[string]$outPath) ";
            command += "$url = [System.Uri]$url; ";
            command += "$webClient = New-Object System.Net.WebClient; ";
            command += "$webClient.DownloadFileAsync($url, $outPath); ";
            command += "while ($webClient.IsBusy) { Start-Sleep -Milliseconds 10 } ";
            command += "[Environment]::Exit(0);";
            command += "}";
            command += " ";
            command += "\"";
            command += _url;
            command += "\"";
            command += " ";
            command += "\"";
            command += _downloadDestination;
            command += "\"";

            return command;
        }

        private function cleanUpPowerShellDownloader():void
        {
            if (_process)
            {
                _process.closeInput();
                _process.removeEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onDownloadProgress);
                _process.removeEventListener(ProgressEvent.STANDARD_ERROR_DATA, onDownloadError);
                _process.removeEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
                _process.removeEventListener(Event.STANDARD_OUTPUT_CLOSE, onStandardOutputClose);
                _process.removeEventListener(NativeProcessExitEvent.EXIT, onDownloadComplete);

                _process = null;
            }

            _url = null;
            _downloadDestination = null;
        }
    }
}
