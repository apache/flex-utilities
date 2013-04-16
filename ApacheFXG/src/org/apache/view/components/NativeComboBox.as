package org.apache.view.components
{
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	import mx.controls.ComboBox;
	import mx.events.ListEvent;
	
	public class NativeComboBox extends ComboBox
	{
		private var nm: NativeMenu;
		public function NativeComboBox()
		{
			super();
			nm = new NativeMenu();
			nm.addEventListener(Event.SELECT, handleSelect );
			addEventListener( MouseEvent.MOUSE_DOWN, onMouseDown, true);
		}
		
		private var _autoCheck:Boolean;
		public function get autoCheck():Boolean{return _autoCheck;}
		public function set autoCheck(value:Boolean):void{_autoCheck = value;}

		
		private var _clickMenuLocation:Boolean = false;
		public function get clickMenuLocation():Boolean
		{
			return _clickMenuLocation;
		}
		public function set clickMenuLocation ( value:Boolean ):void
		{
			_clickMenuLocation = value;
		}
		
		override protected function keyDownHandler(event:KeyboardEvent):void{
			event.preventDefault();
		}
		override protected function focusInHandler(event:FocusEvent):void{
			
		}
		private function onMouseDown( event: MouseEvent ): void
		{
			nm.removeAllItems();
			var ac: ArrayCollection;
			if ( dataProvider is Array )
			{
				ac = new ArrayCollection( dataProvider as Array );
			} else 
			{
				ac = dataProvider as ArrayCollection;
			}
			for ( var i: int = 0; i < ac.length; i++ )
			{
				var ci:Object = ac.getItemAt( i );
				var checked:Boolean = false;
				//var isObject:Boolean = typeof(ci) == "object";
				//trace(typeof(ci));
				var isSeparator:Boolean = false;
				switch(typeof(ci)){
					case "object":
						if(ci.hasOwnProperty("isSeparator")){
							isSeparator = ci.isSeparator;
						}
						if(ci.hasOwnProperty("checked")){
							checked = ci.checked;
						}
						break;
					case "xml":
						isSeparator = ci.@isSeparator == "true";
						checked = ci.@checked == "true";
						break;
				}
				var nmi:NativeMenuItem = new NativeMenuItem( itemToLabel( ci ), isSeparator );
				nmi.checked = checked;
				nmi.data = ci;
				nm.addItem( nmi );
			}
			
			if(_clickMenuLocation)
			{
				nm.display( parentApplication.stage, event.stageX, event.stageY );
			}
				
			else
			{
				var bounds:Rectangle = getBounds( parentApplication.stage );
				nm.display( parentApplication.stage, bounds.x, ( bounds.y + height ) );
			}
			event.stopPropagation();
		}
		private function handleSelect( event: Event ): void
		{
			var nmi: NativeMenuItem = event.target as NativeMenuItem;
			var idx: int = nm.getItemIndex( nmi );
			selectedIndex = idx;
			var evt: ListEvent = new ListEvent( ListEvent.CHANGE, false, true, 0, idx );
			dispatchEvent( evt );
			if(_autoCheck){
				setCheckmark(idx);
			}
		}
		private function setCheckmark(idx:int):void{
			var ac: ArrayCollection;
			if ( dataProvider is Array ){ac = new ArrayCollection( dataProvider as Array );}
			else {ac = dataProvider as ArrayCollection;}
			for ( var i: int = 0; i < ac.length; i++ )
			{
				var ci:Object = ac.getItemAt( i );
				var checked:Boolean = idx == i;
				var isSeparator:Boolean = false;
				switch(typeof(ci)){
					case "object":
						ci.checked = checked;
						break;
					case "xml":
						ci.@checked = checked;
						break;
				}
			}
		}
		override public function set selectedIndex(value:int):void{
			super.selectedIndex = value;
			if(autoCheck){
				setCheckmark(value);
			}
		}
	}
}