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
    import org.apache.flex.ant.tags.supportClasses.TaskHandler;
    
	[ResourceBundle("ant")]
    [Mixin]
    public class Mkdir extends TaskHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["mkdir"] = Mkdir;
        }

        public function Mkdir()
        {
            super();
        }
        
        private function get _dir():String
		{
			return getAttributeValue("@dir");
		}
        
        override public function execute(callbackMode:Boolean, context:Object):Boolean
        {
            super.execute(callbackMode, context);
            
			try
			{
	            var dir:File = new File(_dir);
			} 
			catch (e:Error)
			{
				ant.output(_dir);
				ant.output(e.message);
				if (failonerror)
				{
					ant.project.failureMessage = e.message;
					ant.project.status = false;
				}
				return true;							
			}

            dir.createDirectory();
            
			var s:String = ResourceManager.getInstance().getString('ant', 'MKDIR');
			s = s.replace("%1", dir.nativePath);
			ant.output(ant.formatOutput("mkdir", s));
            return true;
        }
        
    }
}