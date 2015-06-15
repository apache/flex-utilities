package org.apache.flex.runtimelocale.event {
	import flash.events.Event;

	public class ShowHelpRequestEvent extends Event {

		public static const SHOW_HELP_REQUEST:String = "showHelpRequest";

		public function ShowHelpRequestEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}
