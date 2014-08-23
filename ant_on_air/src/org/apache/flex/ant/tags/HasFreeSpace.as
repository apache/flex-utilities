/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.flex.ant.tags
{
    import flash.filesystem.File;
    
    import mx.core.IFlexModuleFactory;
    
    import org.apache.flex.ant.Ant;
	import org.apache.flex.ant.tags.supportClasses.IValueTagHandler;
    import org.apache.flex.ant.tags.supportClasses.TagHandler;
    
    [Mixin]
    public class HasFreeSpace extends TagHandler implements IValueTagHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["hasfreespace"] = HasFreeSpace;
        }
        
        public function HasFreeSpace()
        {
            super();
        }
        
        private function get partition():String
        {
            return getAttributeValue("@partition");
        }
        
        private function get needed():String
        {
            return getAttributeValue("@needed");
        }
		
		public function getValue(context:Object):Object
        {
            this.context = context;
            
            var file:File = new File(partition);
			var space:Number = file.spaceAvailable;
			var postfix:String = needed.substr(-1,1);
			var amount:Number = Number(needed.substr(0, needed.length-1));
			
			for each (var modifier:String in ["K","M","G","T","P"]) {
				amount *= 1024;
				if (postfix == modifier) {
					break;
				}
			}

			return (space >= amount);
        }
        
    }
}