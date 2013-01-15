package org.apache.flex.runtimelocale.event {
	import flash.events.Event;

	public class ApplicationStatusEvent extends Event {

		public static const APPLICATION_ERROR_STATUS:String = "applicationErrorStatus";
		public static const APPLICATION_INFO_STATUS:String = "applicationInfoStatus";

		private var _statusMessage:String;
		private var _caption:String;

		public function ApplicationStatusEvent(type:String, message:String, caption:String=null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_statusMessage = message;
			_caption = caption;
		}

		public function get caption():String {
			return _caption;
		}

		public function get statusMessage():String {
			return _statusMessage;
		}

		override public function clone():Event {
			return new ApplicationStatusEvent(type, _statusMessage, _caption, bubbles, cancelable);
		}

	}
}
