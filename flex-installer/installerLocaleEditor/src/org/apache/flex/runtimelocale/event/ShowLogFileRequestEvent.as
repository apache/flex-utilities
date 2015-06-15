package org.apache.flex.runtimelocale.event {
	import flash.events.Event;

	public class ShowLogFileRequestEvent extends Event {

		public static const SHOW_LOG_FILE_REQUEST:String = "showLogFileRequest";

		public function ShowLogFileRequestEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}
