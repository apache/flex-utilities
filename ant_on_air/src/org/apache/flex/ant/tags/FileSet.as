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
    import org.apache.flex.ant.tags.filesetClasses.DirectoryScanner;
    import org.apache.flex.ant.tags.filesetClasses.exceptions.BuildException;
    import org.apache.flex.ant.tags.supportClasses.IValueTagHandler;
    import org.apache.flex.ant.tags.supportClasses.NamedTagHandler;
    import org.apache.flex.ant.tags.supportClasses.ParentTagHandler;
    
    [Mixin]
    public class FileSet extends ParentTagHandler implements IValueTagHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["fileset"] = FileSet;
        }

        public function FileSet()
        {
            super();
        }
        
        private var _dir:String;
        
        public function get dir():String
        {
            return _dir;
        }
        
        private var _value:Vector.<String>;
        
        public function get value():Object
        {
            if (_value) return _value;
            
            var ds:DirectoryScanner = new DirectoryScanner();
            var n:int = numChildren;
            var includes:Vector.<String> = new Vector.<String>();
            var excludes:Vector.<String> = new Vector.<String>();
            for (var i:int = 0; i < n; i++)
            {
                var tag:NamedTagHandler = getChildAt(i) as NamedTagHandler;
                if (tag is FileSetInclude)
                    includes.push(tag.name);
                else if (tag is FileSetExclude)
                    excludes.push(tag.name);
                else
                    throw new BuildException("Unsupported Tag at index " + i);
            }
            ds.setIncludes(includes);
            ds.setExcludes(excludes);
            if (_dir != null)
                ds.setBasedir(_dir);
            ds.scan();
            _value = ds.getIncludedFiles();
            return _value;
        }
        
        override protected function processAttribute(name:String, value:String):void
        {
            if (name == "dir")
                _dir = value;
        }
        
    }
}