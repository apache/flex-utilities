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

package org.apache.flex.utilities.common.controls
{
	import flash.events.MouseEvent;

	import spark.components.Label;

	
	[Style(name="rollOverTextDecoration", type="String", enumeration="none,underline", inherit="yes")]
	public class LinkButton extends Label
	{
		private var _textDecoration:String;
		
		override public function initialize():void
		{
			super.initialize();
			setStyles();
		}
		
		protected function setStyles():void
		{
			this.buttonMode=true;
			this.addEventListener(MouseEvent.ROLL_OVER,handleRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT,handleRollOut);
		}
		
		protected function handleRollOver(e:MouseEvent):void
		{
			_textDecoration=getStyle("textDecoration");
			this.setStyle('textDecoration',getStyle("rollOverTextDecoration"));
		}
		
		protected function handleRollOut(e:MouseEvent):void
		{
			this.clearStyle('textDecoration');
			this.setStyle('textDecoration',_textDecoration);
		}
		
	}
}
