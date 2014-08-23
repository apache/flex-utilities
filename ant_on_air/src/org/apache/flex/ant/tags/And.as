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
    import org.apache.flex.ant.tags.supportClasses.IValueTagHandler;
    import org.apache.flex.ant.tags.supportClasses.ParentTagHandler;
    
    [Mixin]
    public class And extends ParentTagHandler implements IValueTagHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["and"] = And;
        }

        public function And()
        {
            super();
        }
        
        public function getValue(context:Object):Object
        {
            ant.processChildren(xml, this);
            if (numChildren > 0)
            {
				var n:int = numChildren;
				for (var i:int = 0; i < n; i++)
				{
	                var value:IValueTagHandler = getChildAt(i) as IValueTagHandler;
	                // get the value from the children
	                var val:Object = IValueTagHandler(value).getValue(context);
	                if (!(val == "true" || val == true))
	                {
	                    return false;
	                }
				}
				return true;
            }
			return false;
        }
    }
}