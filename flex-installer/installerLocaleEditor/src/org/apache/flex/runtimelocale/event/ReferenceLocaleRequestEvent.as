package org.apache.flex.runtimelocale.event {
	import flash.events.Event;

	public class ReferenceLocaleRequestEvent extends Event {

		public static const REFERENCE_LOCALE_REQUEST:String = "referenceLocaleRequest";

		public function ReferenceLocaleRequestEvent(type:String, locale:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_localeName = locale;
		}

		private var _localeName:String;

		override public function clone():Event {
			return new ReferenceLocaleRequestEvent(type, _localeName, bubbles, cancelable);
		}

		public function get localeName():String {
			return _localeName;
		}

		public function set localeName(value:String):void {
			_localeName = value;
		}
	}
}
