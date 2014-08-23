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
    import org.apache.flex.ant.tags.filesetClasses.SelectorUtils;
    import org.apache.flex.ant.tags.filesetClasses.exceptions.BuildException;
    import org.apache.flex.ant.tags.supportClasses.NamedTagHandler;
    import org.apache.flex.ant.tags.supportClasses.ParentTagHandler;
    
    [Mixin]
    public class PatternSet extends ParentTagHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["patternset"] = PatternSet;
        }
        
        public function PatternSet()
        {
            super();
        }
        
        private var includes:Vector.<String>;
        private var excludes:Vector.<String>;
        
        private var processedChildren:Boolean;
        
        public function matches(path:String):Boolean
        {
            if (!processedChildren)
            {
                ant.processChildren(xml, this);
                processedChildren = true;
            }
            
            if (numChildren == 0)
                return true;
            
            if (includes == null)
            {
                var n:int = numChildren;
                var includes:Vector.<String> = new Vector.<String>();
                var excludes:Vector.<String> = new Vector.<String>();
                for (var i:int = 0; i < n; i++)
                {
                    var tag:NamedTagHandler = getChildAt(i) as NamedTagHandler;
                    tag.setContext(context);
                    if (tag is FileSetInclude)
                        includes.push(tag.name);
                    else if (tag is FileSetExclude)
                        excludes.push(tag.name);
                    else
                        throw new BuildException("Unsupported Tag at index " + i);
                }
            }
            var result:Boolean = false;
            for each (var inc:String in includes)
            {
                if (SelectorUtils.match(inc, path))
                {
                    result = true;
                    break;
                }
            }
            for each (var exc:String in excludes)
            {
                if (SelectorUtils.match(exc, path))
                {
                    result = false;
                    break;
                }
            }
            return result;
        }
        
    }
}