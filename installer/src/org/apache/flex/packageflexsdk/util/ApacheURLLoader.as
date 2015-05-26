/**
 Licensed to the Apache Software Foundation (ASF) under one or more
 contributor license agreements.  See the NOTICE file distributed with
 this work for additional information regarding copyright ownership.
 The ASF licenses this file to You under the Apache License, Version 2.0
 (the "License"); you may not use this file except in compliance with
 the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.

 */

/**
 *
 * This is a really hackey way to intercept all the HTTPS calls and send them via
 * as3httpdclient instead of the browser-captured URLLoader.  Don't follow this
 * example -- refactor your application to avoid having to do this.
 *
 */
package org.apache.flex.packageflexsdk.util
{
    import com.adobe.net.URI;

    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;

    import org.httpclient.HttpClient;
    import org.httpclient.events.HttpDataEvent;
    import org.httpclient.events.HttpErrorEvent;
    import org.httpclient.events.HttpResponseEvent;

    public class ApacheURLLoader extends URLLoader
    {

        private var httpsData:ByteArray = new ByteArray();

        public function ApacheURLLoader(request:URLRequest = null)
        {
            super(request);
        }

        override public function load(request:URLRequest):void
        {
            if (request.url.indexOf("https://") != 0)
            {
                super.load(request);
            }
            else
            {
                var httpsClient:HttpClient = new HttpClient();
                httpsClient.addEventListener(HttpErrorEvent.ERROR, httpsErrorEvent);
                httpsClient.addEventListener(HttpDataEvent.DATA, httpsDataArrived);
                httpsClient.addEventListener(HttpResponseEvent.COMPLETE, httpsCompleteEvent);
                httpsClient.addEventListener(IOErrorEvent.IO_ERROR, httpsIOError);
                httpsClient.addEventListener(SecurityErrorEvent.SECURITY_ERROR, httpsSecurityError);
                // ProgressEvent is not available in this manner.
                // We can't emulate the HTTP Status Event.  It is internal to the Flash Player and won't
                //    let us override the status item.

                this.httpsData = new ByteArray();
                httpsClient.get(new URI(request.url));
            }

        }

        private function httpsDataArrived(event:HttpDataEvent):void
        {
            this.httpsData.writeBytes(event.bytes);
        }

        private function httpsSecurityError(event:SecurityErrorEvent):void
        {
            dispatchEvent(event.clone());
        }

        private function httpsIOError(event:IOErrorEvent):void
        {
            dispatchEvent(event.clone());
        }

        private function httpsCompleteEvent(event:HttpResponseEvent):void
        {
            this.data = new ByteArray();
            this.data.writeBytes(this.httpsData);
            this.data.position=0;
            var e:Event = new Event(Event.COMPLETE);
            dispatchEvent(e);
        }

        private function httpsErrorEvent(event:HttpErrorEvent):void
        {
            var e:IOErrorEvent = new IOErrorEvent(IOErrorEvent.NETWORK_ERROR);
            e.text = event.text;
            dispatchEvent(e);
        }
    }

}
