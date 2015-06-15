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
    import flash.filesystem.File;
    
    import mx.core.IFlexModuleFactory;
    import mx.resources.ResourceManager;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.FileSetTaskHandler;
    
    [ResourceBundle("ant")]
    [Mixin]
    public class Delete extends FileSetTaskHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["delete"] = Delete;
        }
        
        public function Delete()
        {
            super();
        }
        
        private function get fileName():String
        {
            return getAttributeValue("@file");
        }
        
        private function get dirName():String
        {
            return getAttributeValue("@dir");
        }
        
        override protected function actOnFile(dir:String, fileName:String):void
        {
            var srcName:String;
            if (dir)
                srcName = dir + File.separator + fileName;
            else
                srcName = fileName;
            try {
                var delFile:File = File.applicationDirectory.resolvePath(srcName);
            } 
            catch (e:Error)
            {
                ant.output(fileName);
                ant.output(e.message);
                if (failonerror)
				{
					ant.project.failureMessage = e.message;
                    ant.project.status = false;
				}
                return;							
            }
            
            if (delFile.isDirectory)
                delFile.deleteDirectory(true);
            else
                delFile.deleteFile();
        }
        
        override public function execute(callbackMode:Boolean, context:Object):Boolean
        {
            var retVal:Boolean = super.execute(callbackMode, context);
            if (numChildren > 0)
                return retVal;
            
            var s:String;
            
            if (fileName)
            {
                try {
                    var delFile:File = File.applicationDirectory.resolvePath(fileName);
                } 
                catch (e:Error)
                {
                    ant.output(fileName);
                    ant.output(e.message);
                    if (failonerror)
					{
						ant.project.failureMessage = e.message;
                        ant.project.status = false;
					}
                    return true;							
                }
                
                s = ResourceManager.getInstance().getString('ant', 'DELETEFILE');
                s = s.replace("%1", delFile.nativePath);
                ant.output(ant.formatOutput("delete", s));
                delFile.deleteFile();
            }
            else if (dirName)
            {
                try {
                    var delDir:File = File.applicationDirectory.resolvePath(dirName);
                } 
                catch (e:Error)
                {
                    ant.output(fileName);
                    ant.output(e.message);
                    if (failonerror)
					{
						ant.project.failureMessage = e.message;
                        ant.project.status = false;
					}
                    return true;							
                }
                
                s = ResourceManager.getInstance().getString('ant', 'DELETEDIR');
                s = s.replace("%1", delDir.nativePath);
                ant.output(ant.formatOutput("delete", s));
                delDir.deleteDirectory(true);
            }            
            return true;
        }
        
    }
}