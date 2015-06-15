package org.apache.flex.runtimelocale.event {
	import flash.events.Event;

	public class LocaleFileEvent extends Event {

		public static const FILE_READY:String = "localeFileReady";
		public static const FILE_SAVE_REQUEST:String = "localeFileSaveRequest";
		public static const FILE_SHOW_REQUEST:String = "localeFileShowRequest";

		public function LocaleFileEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}
