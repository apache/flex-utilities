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