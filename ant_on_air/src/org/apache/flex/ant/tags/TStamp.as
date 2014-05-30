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
    import mx.core.IFlexModuleFactory;
    import mx.resources.ResourceManager;
    
    import spark.formatters.DateTimeFormatter;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.TaskHandler;
    
    [ResourceBundle("ant")]
    [Mixin]
    public class TStamp extends TaskHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["tstamp"] = TStamp;
        }
        
        public function TStamp()
        {
        }
        
        override public function execute(callbackMode:Boolean, context:Object):Boolean
        {
            super.execute(callbackMode, context);
            
            var d:Date = new Date();
            var df:DateTimeFormatter = new DateTimeFormatter();
            df.dateTimePattern = "yyyyMMdd";
            var dstamp:String = df.format(d);
            context["DSTAMP"] = dstamp;
            df.dateTimePattern = "hhmm";
            var tstamp:String = df.format(d);
            context["TSTAMP"] = tstamp;
            df.dateTimePattern = "MMMM dd yyyy";
            var today:String = df.format(d);
            context["TODAY"] = today;
            
            return true;
        }
        
        private function get prefix():String
        {
            return getAttributeValue("@prefix");
        }        
        
    } 
}