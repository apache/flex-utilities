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
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.FileSetTaskHandler;
    import org.apache.flex.xml.ITagHandler;
    
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
        
        private function get fileName():String
		{
			return getAttributeValue("@file");
		}
		
        private function get toFileName():String
		{
			return getAttributeValue("@toFile");
		}
		
        private function get toDirName():String
		{
			return getAttributeValue("@toDir");
		}
		
        private function get overwrite():Boolean
		{
			return getAttributeValue("@overwrite") == "true";
		}
		
		private var mapper:GlobMapper;
        
		private function mapFileName(name:String):String
		{
			var from:String = mapper.from;
			if (from.indexOf(".*") == -1)
				from = from.replace("*", ".*");
			var regex:RegExp = new RegExp(from);
			var results:Array = name.match(regex);
			if (results && results.length == 1)
			{
				name = mapper.to.replace("*", results[0]);
				return name;
			}
			return null;
		}
		
		private var searchedForMapper:Boolean;
		
        override protected function actOnFile(dir:String, fileName:String):void
        {
			if (!searchedForMapper)
			{
				// look for a mapper
				for (var i:int = 0; i < numChildren; i++)
				{
					var child:ITagHandler = getChildAt(i);
					if (child is GlobMapper)
					{
						mapper = child as GlobMapper;
						break;
					}
				}
				searchedForMapper = true;
			}

            var srcName:String;
            if (dir)
                srcName = dir + File.separator + fileName;
            else
                srcName = fileName;
            var srcFile:File = File.applicationDirectory.resolvePath(srcName);
            
			if (mapper)
			{
				fileName = mapFileName(fileName);
				if (fileName == null)
					return;
			}
			
            var destName:String;
            if (toDirName)
                destName = toDirName + File.separator + fileName;
            else
                destName = toFileName;
            var destFile:File = File.applicationDirectory.resolvePath(destName);
                
            srcFile.copyTo(destFile, overwrite);
        }
        
        override public function execute(callbackMode:Boolean, context:Object):Boolean
        {
            var retVal:Boolean = super.execute(callbackMode, context);
            if (numChildren > 0)
                return retVal;
            
            var srcFile:File = File.applicationDirectory.resolvePath(fileName);
            var destFile:File = File.applicationDirectory.resolvePath(toFileName);;
            //var destDir:File = destFile.parent;
            //var resolveName:String = destFile.nativePath.substr(destFile.nativePath.lastIndexOf(File.separator) + 1);
            //destDir.resolvePath(resolveName);
            
            srcFile.copyTo(destFile, overwrite);
            return true;
        }
    }
}