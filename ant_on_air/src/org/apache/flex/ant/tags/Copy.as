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
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.FileSetTaskHandler;
    
    [Mixin]
    public class Copy extends FileSetTaskHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["copy"] = Copy;
        }

        public function Copy()
        {
            super();
        }
        
        private var fileName:String;
        private var toFileName:String;
        private var toDirName:String;
        private var overwrite:Boolean;
        
        override protected function processAttribute(name:String, value:String):void
        {
            if (name == "file")
                fileName = value;
            else if (name == "toFile")
                toFileName == value;
            else if (name == "toDir")
                toDirName = value;
            else if (name == "overwrite")
                overwrite = value == "true";
            else
                super.processAttribute(name, value);
        }

        override protected function actOnFile(dir:String, fileName:String):void
        {
            
        }
        
        /**
         *  Do the work.
         *  TaskHandlers lazily create their children so
         *  super.execute() should be called before
         *  doing any real work. 
         */
        override public function execute():Boolean
        {
            return true;
        }
    }
}