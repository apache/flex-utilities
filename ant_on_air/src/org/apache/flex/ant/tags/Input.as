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
        
        private var text:String;
        private var validArgs:Array;
        private var property:String;
        private var defaultValue:String;
        
        override protected function processAttribute(name:String, value:String):void
        {
            if (name == "message")
                text = value;
            else if (name == "validargs")
                validArgs = value.split("");
            else if (name == "addproperty")
                property = value;
            else if (name == "defaultvalue")
                defaultValue = value;
            else
                super.processAttribute(name, value);
        }

        override public function execute(callbackMode:Boolean):Boolean
        {
            super.execute(callbackMode);
            if (text)
                ant.output(ant.getValue(text, context));
            if (validArgs)
                ant.output("[" + validArgs + "]");
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