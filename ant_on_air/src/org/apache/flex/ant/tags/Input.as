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
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    
    import mx.core.IFlexModuleFactory;
    
    import org.apache.flex.ant.Ant;
    import org.apache.flex.ant.tags.supportClasses.TaskHandler;
    
    [Mixin]
    public class Input extends TaskHandler
    {
        public static function init(mf:IFlexModuleFactory):void
        {
            Ant.antTagProcessors["input"] = Input;
        }

        public function Input()
        {
            super();
        }
        
        private function get text():String
		{
			return getAttributeValue("@message");
		}
		
        private function get validArgs():Array
		{
			var val:String = getNullOrAttributeValue("@validargs");
			return val == null ? null : val.split(",");
		}
		
        private function get property():String
		{
			return getAttributeValue("@addproperty");
		}
		
        private function get defaultValue():String
		{
			return getAttributeValue("@defaultvalue");
		}
        
        override public function execute(callbackMode:Boolean, context:Object):Boolean
        {
            super.execute(callbackMode, context);
			var s:String = "";
            if (text)
                s += ant.getValue(text, context);
            if (validArgs)
                s += " (" + validArgs + ")";
			ant.output(ant.formatOutput("input", s));
            ant.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
            return false;
        }
        
        // consumer should re-dispatch keyboard events from ant instance
        private function keyDownHandler(event:KeyboardEvent):void
        {
            var val:String;
            
            if (validArgs == null && event.keyCode == Keyboard.ENTER)
                val = defaultValue;
            else if (validArgs.indexOf(String.fromCharCode(event.charCode)) != -1)
                val = String.fromCharCode(event.charCode);
            
            if (val != null)
            {
                ant.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
                if (!context.hasOwnProperty(property))
                    context[property] = val;
                dispatchEvent(new Event(Event.COMPLETE));
            }
        }
    }
}