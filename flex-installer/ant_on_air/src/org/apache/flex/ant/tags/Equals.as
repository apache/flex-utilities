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
    import mx.utils.StringUtil;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.IValueTagHandler;
    import org.apache.flex.ant.tags.supportClasses.TagHandler;
    
    [Mixin]
    public class Equals extends TagHandler implements IValueTagHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["equals"] = Equals;
        }

        public function Equals()
        {
            super();
        }
        
        private function get arg1():String
		{
			return getAttributeValue("@arg1");
		}
		
        private function get arg2():String
		{
			return getAttributeValue("@arg2");
		}
		
        private function get casesensitive():Boolean
		{
			return getAttributeValue("@casesensitive") == "true";
		}
		
        private function get trim():Boolean
		{
			return getAttributeValue("@trim") == "true";
		}
        
        public function getValue(context:Object):Object
        {
			this.context = context;
			var val1:String = arg1;
            var val2:String = arg2;
            if (casesensitive)
            {
                val1 = val1.toLowerCase();
                val2 = val2.toLowerCase();
            }
            if (trim)
            {
                val1 = StringUtil.trim(val1 as String);
                val2 = StringUtil.trim(val2 as String);
            }
            return val1 == val2;
        }
                
    }
}