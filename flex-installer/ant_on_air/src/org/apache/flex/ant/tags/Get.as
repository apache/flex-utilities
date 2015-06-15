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
package org.apache.flex.ant.tags
{
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    import flash.utils.ByteArray;
    
    import mx.core.IFlexModuleFactory;
    import mx.resources.ResourceManager;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.TaskHandler;
    
    [ResourceBundle("ant")]
    [Mixin]
    public class Get extends TaskHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["get"] = Get;
        }
        
        private static const DOWNLOADS_SOURCEFORGE_NET:String = "http://downloads.sourceforge.net/";
        private static const SOURCEFORGE_NET:String = "http://sourceforge.net/";
        private static const DL_SOURCEFORGE_NET:String = ".dl.sourceforge.net/";
        private static const USE_MIRROR:String = "use_mirror=";
        
        public function Get()
        {
            super();
        }
        
        private function get src():String
        {
            return getAttributeValue("@src");
        }
        
        private function get dest():String
        {
            return getAttributeValue("@dest");
        }
        
        private function get skipexisting():Boolean
        {
            return getAttributeValue("@skipexisting") == "true";
        }
        
		private function get ignoreerrors():Boolean
		{
			return getAttributeValue("@ignoreerrors") == "true";
		}
		
        private var urlLoader:URLLoader;
        
        override public function execute(callbackMode:Boolean, context:Object):Boolean
        {
            super.execute(callbackMode, context);
            
            if (skipexisting)
            {
                var destFile:File = getDestFile();
                if (destFile.exists)
                    return true;
            }
            var s:String = ResourceManager.getInstance().getString('ant', 'GETTING');
            s = s.replace("%1", src);
            ant.output(ant.formatOutput("get", s));
            s = ResourceManager.getInstance().getString('ant', 'GETTO');
            s = s.replace("%1", getDestFile().nativePath);
            ant.output(ant.formatOutput("get", s));
            
            var actualSrc:String = src;
            var urlRequest:URLRequest = new URLRequest(actualSrc);
            urlRequest.followRedirects = false;
            urlRequest.manageCookies = false;
            urlRequest.userAgent = "Java";	// required to get sourceforge redirects to do the right thing
            urlLoader = new URLLoader();
            urlLoader.load(urlRequest);
            urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
            urlLoader.addEventListener(Event.COMPLETE, completeHandler);
            urlLoader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, statusHandler);
            urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler);
            urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            return false;
        }
        
        private function statusHandler(event:HTTPStatusEvent):void
        {
            if (event.status >= 300 && event.status < 400)
            {
                // redirect response
                
                urlLoader.close();
                
                // remove handlers from old request
                urlLoader.removeEventListener(Event.COMPLETE, completeHandler);
                urlLoader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, statusHandler);
                urlLoader.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
                urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler);
                urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
                
                var newlocation:String;
                for each (var header:URLRequestHeader in event.responseHeaders)
                {
                    if (header.name == "Location")
                    {
                        newlocation = header.value;
                        break;
                    }
                }
                if (newlocation)
                {
                    var srcIndex:int = src.indexOf(DOWNLOADS_SOURCEFORGE_NET);
                    var sfIndex:int = newlocation.indexOf(SOURCEFORGE_NET);
                    var mirrorIndex:int = newlocation.indexOf(USE_MIRROR);
                    if (srcIndex == 0 && sfIndex == 0 && mirrorIndex != -1 && event.status == 307)
                    {
                        // SourceForge redirects AIR requests differently from Ant requests.
                        // We can't control some of the additional headers that are sent
                        // but that appears to make the difference.  Just pick out the
                        // mirror and use it against dl.sourceforge.net
                        var mirror:String = newlocation.substring(mirrorIndex + USE_MIRROR.length);
                        newlocation = "http://" + mirror + DL_SOURCEFORGE_NET;
                        newlocation += src.substring(DOWNLOADS_SOURCEFORGE_NET.length);
                    }
                    ant.output(ant.formatOutput("get", "Redirected to: " + newlocation));
                    var urlRequest:URLRequest = new URLRequest(newlocation);
                    var refHeader:URLRequestHeader = new URLRequestHeader("Referer", src);
                    urlRequest.requestHeaders.push(refHeader);
                    urlRequest.manageCookies = false;
                    urlRequest.followRedirects = false;
                    urlRequest.userAgent = "Java";	// required to get sourceforge redirects to do the right thing
                    urlLoader = new URLLoader();
                    urlLoader.load(urlRequest);
                    urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
                    urlLoader.addEventListener(Event.COMPLETE, completeHandler);
                    urlLoader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, statusHandler);
                    urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
                    urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorEventHandler);
                    urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
                }
            }
        }
        
        private function ioErrorEventHandler(event:IOErrorEvent):void
        {
            ant.output(event.toString());
			if (!ignoreerrors)
			{
				ant.project.failureMessage = ant.formatOutput("get", event.toString());
	            ant.project.status = false;
			}
            dispatchEvent(new Event(Event.COMPLETE));
            event.preventDefault();
			urlLoader = null;
        }
        
        private function securityErrorHandler(event:SecurityErrorEvent):void
        {
            ant.output(event.toString());
			if (!ignoreerrors)
			{
				ant.project.failureMessage = ant.formatOutput("get", event.toString());
    	        ant.project.status = false;
			}
            dispatchEvent(new Event(Event.COMPLETE));
            event.preventDefault();
			urlLoader = null;
        }
        
        private function progressHandler(event:ProgressEvent):void
        {
            ant.progressClass = this;
            ant.dispatchEvent(event);
        }
        
        private function completeHandler(event:Event):void
        {
            var destFile:File = getDestFile();
            if (destFile)
            {
                var fs:FileStream = new FileStream();
                fs.open(destFile, FileMode.WRITE);
                fs.writeBytes(urlLoader.data as ByteArray);
                fs.close();
            }

            dispatchEvent(new Event(Event.COMPLETE));
			urlLoader = null;
        }
        
        private function getDestFile():File
        {
            try {
                var destFile:File = File.applicationDirectory.resolvePath(dest);
            } 
            catch (e:Error)
            {
                ant.output(dest);
                ant.output(e.message);
                if (failonerror)
				{
					ant.project.failureMessage = ant.formatOutput("get", e.message);
                    ant.project.status = false;
				}
                return null;							
            }
            
            if (destFile.isDirectory)
            {
                var fileName:String = src;
                var c:int = fileName.indexOf("?");
                if (c != -1)
                    fileName = fileName.substring(0, c);
                c = fileName.lastIndexOf("/");
                if (c != -1)
                    fileName = fileName.substr(c + 1);
                try {
                    destFile = destFile.resolvePath(fileName);
                } 
                catch (e:Error)
                {
                    ant.output(fileName);
                    ant.output(e.message);
                    if (failonerror)
					{
						ant.project.failureMessage = ant.formatOutput("get", e.message);						
                        ant.project.status = false;
					}
                    return null;							
                }
                
            }
            return destFile;
        }
    }
}