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
    import flash.display.Sprite;
    import flash.events.StatusEvent;
    import flash.net.LocalConnection;
    import flash.trace.Trace;
    import flash.utils.getTimer;
    
    public class CodeCoveragePreloadSWF extends Sprite
    {
        public function CodeCoveragePreloadSWF()
        {
            Trace.setLevel(Trace.METHODS_AND_LINES, Trace.LISTENER);
            Trace.setListener(callback);
            lc = new LocalConnection();
            lc.addEventListener(StatusEvent.STATUS, onStatus);    
            lc.send("_CodeCoverageLC", "reset");
        }
        
        private var lc:LocalConnection;
        
        private var stringMap:Object = {};
        private var stringIndex:int = 0;
        
        private function onStatus(event:StatusEvent):void
        {
        }
        
        private var ids:String = "";
        private var lines:String = "";
        private var lastTime:Number = 0;
        
        public function callback(file_name:String, linenum:int, method_name:String, method_args:String):void
        {
            if (linenum > 0)
            {
                // trace(file_name, linenum);
                if (!stringMap.hasOwnProperty(file_name))
                {
                    lc.send("_CodeCoverageLC", "newString", file_name);
                    stringMap[file_name] = stringIndex.toString();
                    stringIndex++;
                }
                var id:String = stringMap[file_name];
                var line:String = linenum.toString();
                if (ids.length > 0)
                {
                    ids += " ";
                    lines += " ";
                }
                ids += id;
                lines += line;
                if (ids.length > 20000 || lines.length > 20000 || (lastTime > 0 && getTimer() - lastTime > 500))
                {
                    lc.send("_CodeCoverageLC", "debugline", ids, lines);
                    ids = "";
                    lines = "";
                }
                lastTime = getTimer();
            }
        }
    }
}