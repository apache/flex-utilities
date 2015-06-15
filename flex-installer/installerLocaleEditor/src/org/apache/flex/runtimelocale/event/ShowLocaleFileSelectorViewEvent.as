package org.apache.flex.runtimelocale.event {
	import flash.events.Event;

	public class ShowLocaleFileSelectorViewEvent extends Event {

		public static const SHOW_LOCALE_FILE_SELECTOR:String = "showLocaleFileSelectorView";

		public function ShowLocaleFileSelectorViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}
